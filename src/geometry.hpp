#pragma once

#include <array>
#include <cmath>
#include <compare>
#include <cstddef>
#include <cstdint>
#include <format>
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
struct Point {
    static constexpr size_t dimension_count = dimensions;
    std::array<int32_t, dimensions> vector;
};

template <size_t dimensions>
struct std::formatter<Point<dimensions>> : std::formatter<std::string> {
    auto format(const Point<dimensions> &point, auto &ctx) const {
        return std::format_to(ctx.out(), "({:n:L})", point.vector);
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

inline void attempt_to_improve(ClosestPair<Point2D> &closest_pair, Point2D point_a, Point2D point_b) {
    if (auto gap = squared_euclidean_distance_between(point_a, point_b); gap < closest_pair.gap) {
        closest_pair = { point_a, point_b, gap };
    }
}
