#pragma once

#include <array>
#include <cmath>
#include <compare>
#include <cstddef>
#include <cstdint>
#include <format>
#include <ranges>
#include <string>

struct Point2D {
    static constexpr size_t dimension_count = 2;
    int32_t x, y;
    friend auto operator<=>(Point2D, Point2D) = default;
};

template <>
struct std::formatter<Point2D> : std::formatter<std::string> {
    auto format(const Point2D &point, auto &ctx) const {
        return std::format_to(ctx.out(), "({:L}, {:L})", point.x, point.y);
    }
};

template <size_t dimensions>
    requires(dimensions >= 1)
struct Point {
    static constexpr size_t dimension_count = dimensions;
    std::array<int32_t, dimensions> vector;
    friend auto operator<=>(Point, Point) = default;
};

template <size_t dimensions>
struct std::formatter<Point<dimensions>> : std::formatter<std::string> {
    auto format(const Point<dimensions> &point, auto &ctx) const {
        if constexpr (dimensions == 1) {
            return std::format_to(ctx.out(), "[{}]({:L})", dimensions, point.vector[0]);
        } else {
            return std::format_to(ctx.out(), "[{}]({:L}, ...)", dimensions, point.vector[0]);
        }
    }
};

template <typename PointType>
struct ClosestPair {
    PointType point_a, point_b;
    int64_t gap;
    constexpr static int64_t INFINITE_GAP = std::numeric_limits<int64_t>::max();
    static ClosestPair init() {
        ClosestPair closest_pair{};
        closest_pair.gap = INFINITE_GAP;
        return closest_pair;
    }
};

template <typename PointType>
struct std::formatter<ClosestPair<PointType>> : std::formatter<std::string> {
    auto format(const ClosestPair<PointType> &pair, auto &ctx) const {
        auto [point_a, point_b, gap] = pair;
        if (point_a > point_b) swap(point_a, point_b);
        return std::format_to(ctx.out(), "{} <-> {} (gap: {:.3f})", point_a, point_b, sqrt(gap));
    }
};

enum class Axis {
    X,
    Y,
};

inline int64_t squared_distance(Point2D point_a, Point2D point_b, Axis axis) {
    int64_t gap = (axis == Axis::X ? int64_t{ point_a.x } - point_b.x : int64_t{ point_a.y } - point_b.y);
    return gap * gap;
}

inline int64_t squared_euclidean_distance_between(Point2D point_a, Point2D point_b) {
    return squared_distance(point_a, point_b, Axis::X) + squared_distance(point_a, point_b, Axis::Y);
}

template <size_t dimensions>
int64_t squared_euclidean_distance_between(Point<dimensions> point_a, Point<dimensions> point_b) {
    int64_t total = 0;
    for (auto i : std::views::iota(0uz, dimensions)) {
        int64_t gap = int64_t{ point_a.vector[i] } - point_b.vector[i];
        total += gap * gap;
    }
    return total;
}

template <typename PointType>
void attempt_to_improve(ClosestPair<PointType> &closest_pair, PointType point_a, PointType point_b) {
    if (auto gap = squared_euclidean_distance_between(point_a, point_b); gap < closest_pair.gap) {
        closest_pair = { point_a, point_b, gap };
    }
}
