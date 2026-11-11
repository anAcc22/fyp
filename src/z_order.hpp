#pragma once

#include "geometry.hpp"

#include <algorithm>
#include <array>
#include <bit>
#include <cstddef>
#include <cstdint>
#include <ranges>
#include <vector>

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
uint32_t shift_range_of(const std::vector<Point<dimensions>> &points) {
    auto largest_coordinate = std::ranges::max(
        points | std::views::transform([](const auto &point) { return std::ranges::max(point.vector); }));
    return std::bit_ceil(static_cast<uint32_t>(largest_coordinate) + 1);
}

template <size_t dimensions>
void examine_neighbours_in_z_order(
    std::vector<Point<dimensions>> &points, const std::array<uint32_t, dimensions> &shift, size_t neighbours_per_point,
    ClosestPair<Point<dimensions>> &closest_pair) {
    auto n = points.size();

    std::ranges::sort(
        points, [&](const auto &point_a, const auto &point_b) { return comes_before_in_z_order(point_a, point_b, shift); });

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, std::min(i + 1 + neighbours_per_point, n))) {
            attempt_to_improve(closest_pair, points[i], points[j]);
        }
    }
}
