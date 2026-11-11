#pragma once

#include "geometry.hpp"
#include "z_order.hpp"

#include <array>
#include <cstddef>
#include <cstdint>
#include <ranges>
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
