#pragma once

#include "generator.hpp"
#include "geometry.hpp"

#include <algorithm>
#include <cstddef>
#include <format>
#include <string>
#include <random>
#include <ranges>
#include <vector>

struct ExamineRandomPairsParams {
    size_t attempts_per_point = 1;
};

template <>
struct std::formatter<ExamineRandomPairsParams> : std::formatter<std::string> {
    auto format(const ExamineRandomPairsParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "attempts_per_point={}", params.attempts_per_point);
    }
};

template <typename PointType>
ClosestPair<PointType> examine_random_pairs(std::vector<PointType> points, ExamineRandomPairsParams params) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<PointType>::init();
    auto attempts     = params.attempts_per_point * n;

    std::uniform_int_distribution index_generator(0uz, n - 1);

    for (auto _ : std::views::iota(0uz, attempts)) {
        auto i = index_generator(solver_randomiser);
        auto j = index_generator(solver_randomiser);

        if (i == j) continue;

        auto point_a = points[i], point_b = points[j];

        attempt_to_improve(closest_pair, point_a, point_b);
    }

    return closest_pair;
}

struct ExamineNeighboursAlongEachAxisParams {
    size_t window_size = 2;
};

template <>
struct std::formatter<ExamineNeighboursAlongEachAxisParams> : std::formatter<std::string> {
    auto format(const ExamineNeighboursAlongEachAxisParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "window_size={}", params.window_size);
    }
};

template <size_t dimensions>
ClosestPair<Point<dimensions>>
examine_neighbours_along_each_axis(std::vector<Point<dimensions>> points, ExamineNeighboursAlongEachAxisParams params) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    for (auto axis : std::views::iota(0uz, dimensions)) {
        std::ranges::sort(points, {}, [axis](const auto &point) { return point[axis]; });

        for (auto i : std::views::iota(0uz, n)) {
            for (auto j : std::views::iota(i + 1, std::min(i + params.window_size, n))) {
                attempt_to_improve(closest_pair, points[i], points[j]);
            }
        }
    }

    return closest_pair;
}
