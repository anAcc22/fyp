#pragma once

#include "generator.hpp"
#include "geometry.hpp"
#include "kd_tree.hpp"

#include <algorithm>
#include <array>
#include <bit>
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

inline bool has_lower_most_significant_bit(uint32_t a, uint32_t b) { return a < b && a < (a ^ b); }

template <size_t dimensions>
bool comes_before_in_z_order(
    const Point<dimensions> &point_a, const Point<dimensions> &point_b, const std::array<uint32_t, dimensions> &shift) {
    size_t deciding_axis        = 0;
    uint32_t highest_difference = 0;

    for (auto axis : std::views::iota(0uz, dimensions)) {
        uint32_t shifted_a  = static_cast<uint32_t>(point_a[axis]) + shift[axis];
        uint32_t shifted_b  = static_cast<uint32_t>(point_b[axis]) + shift[axis];
        uint32_t difference = shifted_a ^ shifted_b;

        if (has_lower_most_significant_bit(highest_difference, difference)) {
            deciding_axis      = axis;
            highest_difference = difference;
        }
    }

    return point_a[deciding_axis] < point_b[deciding_axis];
}

template <size_t dimensions>
ClosestPair<Point<dimensions>> examine_neighbours_along_z_order_curve(
    std::vector<Point<dimensions>> points, ExamineNeighboursAlongZOrderCurveParams params) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    auto largest_coordinate = std::ranges::max(
        points | std::views::transform([](const auto &point) { return std::ranges::max(point.vector); }));
    auto shift_range = std::bit_ceil(static_cast<uint32_t>(largest_coordinate) + 1);

    std::uniform_int_distribution<uint32_t> shift_distribution(0, shift_range - 1);
    std::array<uint32_t, dimensions> shift{};

    for (auto shift_index : std::views::iota(0uz, params.shift_count)) {
        if (shift_index > 0) {
            for (auto &component : shift) component = shift_distribution(solver_randomiser);
        }

        std::ranges::sort(points, [&](const auto &point_a, const auto &point_b) {
            return comes_before_in_z_order(point_a, point_b, shift);
        });

        for (auto i : std::views::iota(0uz, n)) {
            for (auto j : std::views::iota(i + 1, std::min(i + 1 + params.neighbours_per_point, n))) {
                attempt_to_improve(closest_pair, points[i], points[j]);
            }
        }
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

struct KdTreeRegion {
    int64_t lower_bound;
    size_t l, r, depth;
};

template <size_t dimensions>
ClosestPair<Point<dimensions>> best_first_kd_tree(std::vector<Point<dimensions>> points, BestFirstKdTreeParams params) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    build_kd_tree(points, 0uz, n, 0uz);

    auto further_away = [](const KdTreeRegion &region_a, const KdTreeRegion &region_b) {
        return region_a.lower_bound > region_b.lower_bound;
    };

    std::vector<KdTreeRegion> regions_to_visit;

    for (auto query_index : std::views::iota(0uz, n)) {
        auto query       = points[query_index];
        auto comparisons = 0uz;

        regions_to_visit.clear();
        regions_to_visit.push_back({ .lower_bound = 0, .l = 0, .r = n, .depth = 0 });

        while (!regions_to_visit.empty() && comparisons < params.comparisons_per_point) {
            std::ranges::pop_heap(regions_to_visit, further_away);
            auto region = regions_to_visit.back();
            regions_to_visit.pop_back();

            if (region.lower_bound >= closest_pair.gap) break;

            auto axis = region.depth % dimensions;
            auto m    = std::midpoint(region.l, region.r);

            if (m != query_index) {
                attempt_to_improve(closest_pair, query, points[m]);
                comparisons++;
            }

            int64_t gap_to_plane = int64_t{ query[axis] } - points[m][axis];

            KdTreeRegion lower_side{ region.lower_bound, region.l, m, region.depth + 1 };
            KdTreeRegion upper_side{ region.lower_bound, m + 1, region.r, region.depth + 1 };

            auto &far_side       = gap_to_plane > 0 ? lower_side : upper_side;
            far_side.lower_bound = std::max(region.lower_bound, gap_to_plane * gap_to_plane);

            for (const auto &side : { lower_side, upper_side }) {
                if (side.l < side.r && side.lower_bound < closest_pair.gap) {
                    regions_to_visit.push_back(side);
                    std::ranges::push_heap(regions_to_visit, further_away);
                }
            }
        }
    }

    return closest_pair;
}
