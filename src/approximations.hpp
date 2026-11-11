#pragma once

#include "geometry.hpp"
#include "kd_tree.hpp"
#include "z_order.hpp"

#include <array>
#include <cstddef>
#include <cstdint>
#include <format>
#include <limits>
#include <ranges>
#include <string>
#include <utility>
#include <vector>

template <size_t dimensions>
ClosestPair<Point<dimensions>> examine_neighbours_along_chan_shifted_z_order_curves(std::vector<Point<dimensions>> points) {
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    constexpr size_t even_dimensions = dimensions % 2 == 0 ? dimensions : dimensions + 1;
    constexpr size_t shift_count     = even_dimensions + 1;

    uint64_t shift_range = shift_range_of(points);

    for (auto shift_index : std::views::iota(0uz, shift_count)) {
        std::array<uint32_t, dimensions> shift;
        shift.fill(static_cast<uint32_t>(shift_index * shift_range / shift_count));

        examine_neighbours_in_z_order(points, shift, 1, closest_pair);
    }

    return closest_pair;
}

struct ApproximateBestFirstKdTreeParams {
    double epsilon = 0.1;
};

template <>
struct std::formatter<ApproximateBestFirstKdTreeParams> : std::formatter<std::string> {
    auto format(const ApproximateBestFirstKdTreeParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "epsilon={}", params.epsilon);
    }
};

template <size_t dimensions>
ClosestPair<Point<dimensions>>
approximate_best_first_kd_tree(std::vector<Point<dimensions>> points, ApproximateBestFirstKdTreeParams params) {
    return best_first_kd_tree_search(std::move(points), std::numeric_limits<size_t>::max(), params.epsilon);
}
