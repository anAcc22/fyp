#include "harness.hpp"

#include "benchmark.hpp"
#include "brute_force.hpp"
#include "divide_and_conquer.hpp"
#include "grid.hpp"
#include "heuristics.hpp"
#include "kd_tree.hpp"
#include "sweepline.hpp"

#include <algorithm>
#include <format>
#include <fstream>
#include <functional>
#include <print>
#include <ranges>
#include <utility>
#include <variant>

bool supports_dimensions(SolverName name, Dimensions dimensions) {
    switch (name) {
        case SolverName::Sweepline:
        case SolverName::DivideAndConquer:
            return dimensions == 2;
        case SolverName::GridDecomposition:
        case SolverName::ParallelGridDecomposition:
            return dimensions <= MAX_GRID_DIMENSIONS;
        default:
            return true;
    }
}

bool has_matching_params(const SolverSettings &solver) {
    switch (solver.name) {
        case SolverName::ExamineRandomPairs:
            return std::holds_alternative<ExamineRandomPairsParams>(solver.params);
        case SolverName::ExamineNeighboursAlongEachAxis:
            return std::holds_alternative<ExamineNeighboursAlongEachAxisParams>(solver.params);
        case SolverName::GridDecomposition:
        case SolverName::ParallelGridDecomposition:
            return std::holds_alternative<GridDecompositionParams>(solver.params);
        default:
            return std::holds_alternative<std::monostate>(solver.params);
    }
}

std::vector<ErrorMessage> error_messages_for(const HarnessSettings &settings) {
    std::vector<ErrorMessage> error_messages;

    if (settings.dimensions.empty()) error_messages.push_back("no dimensions given");
    if (settings.point_counts.empty()) error_messages.push_back("no point counts given");
    if (settings.solvers.empty()) error_messages.push_back("no solvers given");
    if (settings.trial_count == 0) error_messages.push_back("trial count must be at least 1");

    for (auto dimensions : settings.dimensions) {
        if (!std::ranges::contains(SUPPORTED_DIMENSIONS, dimensions)) {
            error_messages.push_back(std::format("{} dimensions is not in SUPPORTED_DIMENSIONS", dimensions));
        }
    }

    for (auto point_count : settings.point_counts) {
        if (point_count < 2) error_messages.push_back(std::format("point count {} is below 2", point_count));
    }

    for (const auto &solver : settings.solvers) {
        if (!has_matching_params(solver)) {
            error_messages.push_back(std::format("{} was given the wrong kind of params", solver.name));
        }

        if (auto *params = std::get_if<ExamineNeighboursAlongEachAxisParams>(&solver.params)) {
            if (params->window_size < 2) {
                error_messages.push_back(std::format("{} needs a window_size of at least 2", solver.name));
            }
        }

        for (auto dimensions : settings.dimensions) {
            if (!supports_dimensions(solver.name, dimensions)) {
                error_messages.push_back(std::format("{} does not support {} dimensions", solver.name, dimensions));
            }
        }
    }

    return error_messages;
}

std::vector<Point2D> as_points_2d(const std::vector<Point<2>> &dataset) {
    return dataset | std::views::transform([](Point<2> point) { return Point2D{ point[0], point[1] }; })
           | std::ranges::to<std::vector>();
}

template <size_t dimensions>
SolverMeasurement run_solver(
    const SolverSettings &solver, const std::vector<Point<dimensions>> &dataset, Trial trial,
    std::optional<int64_t> true_gap) {
    using PointType = Point<dimensions>;

    switch (solver.name) {
        case SolverName::ExamineAllPairs:
            return measure_solver(examine_all_pairs<PointType>, dataset, trial, true_gap);
        case SolverName::ExamineAllPairsInParallel:
            return measure_solver(examine_all_pairs_in_parallel<PointType>, dataset, trial, true_gap);
        case SolverName::KdTree:
            return measure_solver(kd_tree<dimensions>, dataset, trial, true_gap);
        case SolverName::ParallelKdTree:
            return measure_solver(parallel_kd_tree<dimensions>, dataset, trial, true_gap);
        case SolverName::GridDecomposition: {
            auto params = std::get<GridDecompositionParams>(solver.params);
            auto grid   = [params](std::vector<PointType> points) { return grid_decomposition(points, params); };
            return measure_solver(grid, dataset, trial, true_gap);
        }
        case SolverName::ParallelGridDecomposition: {
            auto params = std::get<GridDecompositionParams>(solver.params);
            auto grid = [params](std::vector<PointType> points) { return parallel_grid_decomposition(points, params); };
            return measure_solver(grid, dataset, trial, true_gap);
        }
        case SolverName::ExamineRandomPairs: {
            auto params = std::get<ExamineRandomPairsParams>(solver.params);
            auto random_pairs
                = [params](std::vector<PointType> points) { return examine_random_pairs(points, params); };
            return measure_solver(random_pairs, dataset, trial, true_gap);
        }
        case SolverName::ExamineNeighboursAlongEachAxis: {
            auto params                     = std::get<ExamineNeighboursAlongEachAxisParams>(solver.params);
            auto neighbours_along_each_axis = [params](std::vector<PointType> points) {
                return examine_neighbours_along_each_axis(points, params);
            };
            return measure_solver(neighbours_along_each_axis, dataset, trial, true_gap);
        }
        case SolverName::Sweepline:
            if constexpr (dimensions == 2) return measure_solver(sweepline, as_points_2d(dataset), trial, true_gap);
            break;
        case SolverName::DivideAndConquer:
            if constexpr (dimensions == 2) {
                return measure_solver(divide_and_conquer, as_points_2d(dataset), trial, true_gap);
            }
            break;
    }

    std::unreachable();
}

template <size_t dimensions>
void run_trials_at(const HarnessSettings &settings, std::vector<TrialResult> &results) {
    for (auto point_count : settings.point_counts) {
        for (auto trial_number : std::views::iota(1uz, settings.trial_count + 1)) {
            Trial trial{
                .base_seed    = settings.base_seed,
                .dimensions   = dimensions,
                .point_count  = point_count,
                .trial_number = trial_number,
            };

            auto dataset = generate_points<Point<dimensions>>(trial);

            if (settings.save_datasets) save_points_to_disk(trial, dataset);

            std::optional<int64_t> true_gap;
            if (settings.relative_check == RelativeCheck::True) true_gap = true_closest_gap_within(dataset);

            for (auto solver_index : std::views::iota(0uz, settings.solvers.size())) {
                auto measurement = run_solver(settings.solvers[solver_index], dataset, trial, true_gap);

                results.push_back(
                    {
                        .solver_index = solver_index,
                        .trial        = trial,
                        .runtime      = measurement.runtime,
                        .ratio        = measurement.ratio,
                    });
            }
        }
    }
}

template <size_t index = 0>
void run_trials_at_runtime_dimension(
    Dimensions dimensions, const HarnessSettings &settings, std::vector<TrialResult> &results) {
    if constexpr (index < SUPPORTED_DIMENSIONS.size()) {
        constexpr auto supported_dimensions = SUPPORTED_DIMENSIONS[index];
        if (dimensions == supported_dimensions) return run_trials_at<supported_dimensions>(settings, results);
        run_trials_at_runtime_dimension<index + 1>(dimensions, settings, results);
    }
}

std::expected<std::vector<TrialResult>, std::vector<ErrorMessage>> run_harness(const HarnessSettings &settings) {
    if (auto error_messages = error_messages_for(settings); !error_messages.empty()) {
        return std::unexpected(error_messages);
    }

    std::vector<TrialResult> results;

    for (auto dimensions : settings.dimensions) {
        run_trials_at_runtime_dimension(dimensions, settings, results);
    }

    return results;
}

template <typename T>
T mean_of(const std::vector<T> &values) {
    return std::ranges::fold_left(values, T{}, std::plus{}) / static_cast<double>(values.size());
}

void print_summary(const HarnessSettings &settings, const std::vector<TrialResult> &results) {
    for (auto solver_index : std::views::iota(0uz, settings.solvers.size())) {
        const auto &solver = settings.solvers[solver_index];

        if (std::holds_alternative<std::monostate>(solver.params)) {
            std::println("|> {}", solver.name);
        } else {
            std::println("|> {} ({})", solver.name, solver.params);
        }

        for (auto dimensions : settings.dimensions) {
            for (auto point_count : settings.point_counts) {
                auto matching_results = results | std::views::filter([&](const TrialResult &result) {
                                            return result.solver_index == solver_index
                                                   && result.trial.dimensions == dimensions
                                                   && result.trial.point_count == point_count;
                                        });

                auto runtimes
                    = matching_results | std::views::transform(&TrialResult::runtime) | std::ranges::to<std::vector>();

                auto summary = std::format(
                    "Dimensions: {}, Point Count: {:L}, Mean Runtime: {:.3f}s",
                    dimensions,
                    point_count,
                    mean_of(runtimes).count());

                if (settings.relative_check == RelativeCheck::True) {
                    auto ratios = matching_results
                                  | std::views::transform([](const TrialResult &result) { return *result.ratio; })
                                  | std::ranges::to<std::vector>();
                    summary += std::format(", Mean Ratio: {:.3f}", mean_of(ratios));
                }

                std::println("{}", summary);
            }
        }

        std::println();
    }
}

void save_results_to_disk(
    const HarnessSettings &settings, const std::vector<TrialResult> &results, const std::filesystem::path &path) {
    std::ofstream file(path);

    std::println(file, "solver,params,dimensions,point_count,trial_number,runtime_seconds,ratio");

    for (const auto &result : results) {
        const auto &solver = settings.solvers[result.solver_index];
        auto ratio         = result.ratio.transform([](double ratio) { return std::format("{}", ratio); });

        std::println(
            file,
            "{},\"{}\",{},{},{},{},{}",
            solver.name,
            solver.params,
            result.trial.dimensions,
            result.trial.point_count,
            result.trial.trial_number,
            result.runtime.count(),
            ratio.value_or(""));
    }
}
