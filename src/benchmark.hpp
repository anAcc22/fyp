#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <optional>
#include <ranges>
#include <vector>

#include "generator.hpp"
#include "geometry.hpp"

template <typename PointType>
struct RunStatistics {
    ClosestPair<PointType> closest_pair;
    std::chrono::duration<double> time_taken;
    std::optional<double> ratio = std::nullopt;
};

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
    auto n = points.size();

    auto gaps_from = [&](size_t i) {
        return std::views::iota(i + 1, n) | std::views::transform([&, i](size_t j) {
                   return squared_euclidean_distance_between(points[i], points[j]);
               });
    };

    return std::ranges::min(std::views::iota(0uz, n) | std::views::transform(gaps_from) | std::views::join);
}

template <typename PointType>
RunStatistics<PointType> time_taken_by(
    ClosestPair<PointType> (*solver)(std::vector<PointType>), size_t point_count, RelativeCheck relative_check) {
    auto params       = generator_for(point_count, PointType::dimension_count);
    auto points       = generate_points<PointType>(params);
    auto start_time   = std::chrono::steady_clock::now();
    auto closest_pair = solver(points);
    auto end_time     = std::chrono::steady_clock::now();

    RunStatistics stats = { .closest_pair = closest_pair, .time_taken = end_time - start_time };

    if (relative_check == RelativeCheck::True) {
        stats.ratio = approximation_ratio_of(closest_pair.gap, true_closest_gap_within(points));
    }

    return stats;
}
