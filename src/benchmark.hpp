#pragma once

#include <chrono>
#include <cmath>
#include <concepts>
#include <cstdint>
#include <limits>
#include <optional>
#include <utility>
#include <vector>

#include "brute_force.hpp"
#include "generator.hpp"
#include "geometry.hpp"

using Seconds = std::chrono::duration<double>;

enum class RelativeCheck {
    False,
    True,
};

inline double approximation_ratio_of(int64_t found_gap, int64_t true_gap) {
    if (true_gap == 0) return found_gap == 0 ? 1.0 : std::numeric_limits<double>::infinity();
    return std::sqrt(static_cast<double>(found_gap) / static_cast<double>(true_gap));
}

template <typename PointType>
int64_t true_closest_gap_within(const std::vector<PointType> &points) {
    return examine_all_pairs_in_parallel(points).gap;
}

struct SolverMeasurement {
    Seconds runtime;
    std::optional<double> ratio = std::nullopt;
};

template <typename PointType>
SolverMeasurement measure_solver(
    std::invocable<std::vector<PointType>> auto solver, const std::vector<PointType> &dataset, Trial trial,
    std::optional<int64_t> true_gap) {
    solver_randomiser.seed(seed_for(trial, TrialSeedSuffix::Solver));

    auto dataset_copy = dataset;

    auto start_time   = std::chrono::steady_clock::now();
    auto closest_pair = solver(std::move(dataset_copy));
    auto end_time     = std::chrono::steady_clock::now();

    return {
        .runtime = end_time - start_time,
        .ratio   = true_gap.transform([&](int64_t gap) { return approximation_ratio_of(closest_pair.gap, gap); }),
    };
}
