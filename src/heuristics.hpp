#pragma once

#include "generator.hpp"
#include "geometry.hpp"
#include "kd_tree.hpp"
#include "z_order.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <format>
#include <functional>
#include <numeric>
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

    std::uniform_int_distribution partner_generator(0uz, n - 2);

    for (auto _ : std::views::iota(0uz, params.attempts_per_point)) {
        for (auto i : std::views::iota(0uz, n)) {
            auto partner = partner_generator(solver_randomiser);
            if (partner >= i) partner++;

            attempt_to_improve(closest_pair, points[i], points[partner]);
        }
    }

    return closest_pair;
}

struct ExamineNeighboursAlongEachAxisParams {
    size_t neighbours_per_point = 1;
};

template <>
struct std::formatter<ExamineNeighboursAlongEachAxisParams> : std::formatter<std::string> {
    auto format(const ExamineNeighboursAlongEachAxisParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "neighbours_per_point={}", params.neighbours_per_point);
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
            for (auto j : std::views::iota(i + 1, std::min(i + 1 + params.neighbours_per_point, n))) {
                attempt_to_improve(closest_pair, points[i], points[j]);
            }
        }
    }

    return closest_pair;
}

struct ExamineNeighboursAlongRandomDirectionsParams {
    size_t direction_count      = 1;
    size_t neighbours_per_point = 1;
};

template <>
struct std::formatter<ExamineNeighboursAlongRandomDirectionsParams> : std::formatter<std::string> {
    auto format(const ExamineNeighboursAlongRandomDirectionsParams &params, auto &ctx) const {
        return std::format_to(
            ctx.out(),
            "direction_count={}, neighbours_per_point={}",
            params.direction_count,
            params.neighbours_per_point);
    }
};

template <size_t dimensions>
double projection_of(const Point<dimensions> &point, const std::array<double, dimensions> &direction) {
    return std::ranges::fold_left(
        std::views::zip_transform(std::multiplies{}, direction, point.vector), 0.0, std::plus{});
}

template <size_t dimensions>
ClosestPair<Point<dimensions>> examine_neighbours_along_random_directions(
    std::vector<Point<dimensions>> points, ExamineNeighboursAlongRandomDirectionsParams params) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    std::normal_distribution<double> component_distribution;

    std::vector<double> projections(n);
    std::vector<size_t> order(n);
    std::iota(begin(order), end(order), 0uz);

    for (auto _ : std::views::iota(0uz, params.direction_count)) {
        std::array<double, dimensions> direction;
        for (auto &component : direction) component = component_distribution(solver_randomiser);

        std::ranges::transform(
            points, begin(projections), [&](const auto &point) { return projection_of(point, direction); });

        std::ranges::sort(order, {}, [&](size_t index) { return projections[index]; });

        for (auto i : std::views::iota(0uz, n)) {
            for (auto j : std::views::iota(i + 1, std::min(i + 1 + params.neighbours_per_point, n))) {
                attempt_to_improve(closest_pair, points[order[i]], points[order[j]]);
            }
        }
    }

    return closest_pair;
}

struct ExamineNeighboursAlongZOrderCurveParams {
    size_t shift_count          = 1;
    size_t neighbours_per_point = 1;
};

template <>
struct std::formatter<ExamineNeighboursAlongZOrderCurveParams> : std::formatter<std::string> {
    auto format(const ExamineNeighboursAlongZOrderCurveParams &params, auto &ctx) const {
        return std::format_to(
            ctx.out(), "shift_count={}, neighbours_per_point={}", params.shift_count, params.neighbours_per_point);
    }
};

template <size_t dimensions>
ClosestPair<Point<dimensions>> examine_neighbours_along_z_order_curve(
    std::vector<Point<dimensions>> points, ExamineNeighboursAlongZOrderCurveParams params) {
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    std::uniform_int_distribution<uint32_t> shift_distribution(0, shift_range_of(points) - 1);
    std::array<uint32_t, dimensions> shift{};

    for (auto shift_index : std::views::iota(0uz, params.shift_count)) {
        if (shift_index > 0) {
            for (auto &component : shift) component = shift_distribution(solver_randomiser);
        }

        examine_neighbours_in_z_order(points, shift, params.neighbours_per_point, closest_pair);
    }

    return closest_pair;
}

struct BestFirstKdTreeParams {
    size_t comparisons_per_point = 32;
};

template <>
struct std::formatter<BestFirstKdTreeParams> : std::formatter<std::string> {
    auto format(const BestFirstKdTreeParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "comparisons_per_point={}", params.comparisons_per_point);
    }
};

template <size_t dimensions>
ClosestPair<Point<dimensions>> best_first_kd_tree(std::vector<Point<dimensions>> points, BestFirstKdTreeParams params) {
    return best_first_kd_tree_search(std::move(points), params.comparisons_per_point, 0.0);
}
