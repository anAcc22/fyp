#pragma once

#include <cmath>
#include <compare>
#include <format>
#include <string>

struct Point2D {
    int32_t x, y;
    friend auto operator<=>(Point2D, Point2D) = default;
};

template <size_t dimensions>
struct Point {
    std::array<int32_t, dimensions> vector;
};

template <>
struct std::formatter<Point2D> : std::formatter<std::string> {
    auto format(const Point2D &p, auto &ctx) const { return std::format_to(ctx.out(), "({:L}, {:L})", p.x, p.y); }
};

struct ClosestPair {
    Point2D point_a, point_b;
    int64_t gap;
};

template <>
struct std::formatter<ClosestPair> : std::formatter<std::string> {
    auto format(const ClosestPair &pair, auto &ctx) const {
        auto [point_a, point_b, gap] = pair;
        return std::format_to(ctx.out(), "{} <-> {} (gap: {:.3f})", point_a, point_b, sqrt(gap));
    }
};

enum class Axis {
    X,
    Y,
};

inline int64_t squared_distance(Point2D point_a, Point2D point_b, Axis axis) {
    auto gap = (axis == Axis::X ? point_a.x - point_b.x : point_a.y - point_b.y);
    return gap * gap;
}

inline int64_t squared_euclidean_distance_between(Point2D point_a, Point2D point_b) {
    return squared_distance(point_a, point_b, Axis::X) + squared_distance(point_a, point_b, Axis::Y);
}

inline void attempt_to_improve(ClosestPair &closest_pair, Point2D point_a, Point2D point_b) {
    if (auto gap = squared_euclidean_distance_between(point_a, point_b); gap < closest_pair.gap) {
        closest_pair = { point_a, point_b, gap };
    }
}
