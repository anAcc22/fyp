#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <concepts>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <limits>
#include <optional>
#include <ranges>
#include <thread>
#include <utility>
#include <vector>

#include "generator.hpp"
#include "geometry.hpp"
#include "multithreading.hpp"

using Seconds = std::chrono::duration<double>;

enum class RelativeCheck {
    False,
    True,
};

struct ReferenceDistances {
    double best;
    double typical;
};

template <typename PointType>
ReferenceDistances reference_distances_within(const std::vector<PointType> &points) {
    auto n          = points.size();
    auto pair_count = n * (n - 1) / 2;

    std::vector<int64_t> best_gap_of_thread(THREAD_COUNT, ClosestPair<PointType>::INFINITE_GAP);
    std::vector<double> distance_sum_of_thread(THREAD_COUNT, 0.0);

    auto solve = [&](size_t start_index) -> void {
        auto best_gap     = ClosestPair<PointType>::INFINITE_GAP;
        auto distance_sum = 0.0;

        for (auto i = start_index; i < n; i += THREAD_COUNT) {
            for (auto j : std::views::iota(i + 1, n)) {
                auto gap = squared_euclidean_distance_between(points[i], points[j]);
                best_gap = std::min(best_gap, gap);
                distance_sum += std::sqrt(static_cast<double>(gap));
            }
        }

        best_gap_of_thread[start_index]     = best_gap;
        distance_sum_of_thread[start_index] = distance_sum;
    };

    {
        std::vector<std::jthread> threads;

        for (auto i : std::views::iota(0uz, THREAD_COUNT)) {
            threads.emplace_back(solve, i);
        }
    }

    return {
        .best    = std::sqrt(static_cast<double>(std::ranges::min(best_gap_of_thread))),
        .typical = std::ranges::fold_left(distance_sum_of_thread, 0.0, std::plus{}) / static_cast<double>(pair_count),
    };
}

inline double ratio_of(double yours, ReferenceDistances reference) {
    if (reference.best == 0) return yours == 0 ? 1.0 : std::numeric_limits<double>::infinity();
    return yours / reference.best;
}

inline double normalised_score_of(double yours, ReferenceDistances reference) {
    if (reference.typical == reference.best) return 1.0;
    return (reference.typical - yours) / (reference.typical - reference.best);
}

struct SolverMeasurement {
    Seconds runtime;
    std::optional<double> ratio            = std::nullopt;
    std::optional<double> normalised_score = std::nullopt;
};

template <typename PointType>
SolverMeasurement measure_solver(
    std::invocable<std::vector<PointType>> auto solver, const std::vector<PointType> &dataset, Trial trial,
    std::optional<ReferenceDistances> reference) {
    solver_randomiser.seed(seed_for(trial, TrialSeedSuffix::Solver));

    auto dataset_copy = dataset;

    auto start_time   = std::chrono::steady_clock::now();
    auto closest_pair = solver(std::move(dataset_copy));
    auto end_time     = std::chrono::steady_clock::now();

    auto yours = std::sqrt(static_cast<double>(closest_pair.gap));

    return {
        .runtime = end_time - start_time,
        .ratio   = reference.transform([&](ReferenceDistances reference) { return ratio_of(yours, reference); }),
        .normalised_score
        = reference.transform([&](ReferenceDistances reference) { return normalised_score_of(yours, reference); }),
    };
}
