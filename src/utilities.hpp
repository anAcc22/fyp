#pragma once

#include "geometry.hpp"

#include <cmath>
#include <ranges>
#include <algorithm>
#include <numeric>
#include <numbers>
#include <vector>

template <typename T>
T ceiling_square_root(T x) {
    T low = 0, high = sqrt(x), ans = -1;
    while (low <= high) {
        auto mid = std::midpoint(low, high);
        if (mid * mid < x) ans = mid, low = mid + 1;
        else high = mid - 1;
    }
    return ans + 1;
}

template <typename T, typename U>
T fast_exponentiation(T base, U power) {
    T answer{ 1 };
    while (power) {
        if (power & 1) answer *= base;
        base *= base;
        power >>= 1;
    }
    return answer;
}

template <size_t dimensions, typename T>
std::array<int16_t, dimensions> offset_from(T raw_offset) {
    std::array<int16_t, dimensions> offset;
    static constexpr auto BASE = 3;
    for (auto i : std::views::iota(0uz, dimensions)) {
        int16_t state = raw_offset % BASE;
        offset[i]     = state - 1;
        raw_offset /= BASE;
    }
    return offset;
}

enum class GridWidthStrategy {
    Sampling,
    UniformRandomNearestNeighbor,
};

inline constexpr double DEFAULT_GRID_WIDTH_MULTIPLIER = 2.0;

template <size_t dimensions>
double unit_ball_volume() {
    return std::pow(std::numbers::pi, dimensions / 2.0) / std::tgamma(dimensions / 2.0 + 1.0);
}

template <size_t dimensions>
double bounding_box_volume(const std::vector<Point<dimensions>> &points) {
    double volume = 1.0;

    for (auto axis : std::views::iota(0uz, dimensions)) {
        auto coordinate  = [axis](const auto &point) { return point.vector[axis]; };
        auto [low, high] = std::ranges::minmax(points | std::views::transform(coordinate));
        volume *= static_cast<double>(high - low) + 1.0;
    }

    return volume;
}

template <size_t dimensions, double multiplier>
int64_t expected_nearest_neighbour_distance(const std::vector<Point<dimensions>> &points) {
    auto ball_volume
        = bounding_box_volume(points) / (static_cast<double>(points.size()) * unit_ball_volume<dimensions>());

    auto distance = std::tgamma(1.0 + 1.0 / dimensions) * std::pow(ball_volume, 1.0 / dimensions);

    return std::max<int64_t>(1, static_cast<int64_t>(multiplier * distance));
}
