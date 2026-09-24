#pragma once

#include "generator.hpp"
#include "geometry.hpp"

#include <cstddef>
#include <random>
#include <ranges>
#include <vector>

template <typename PointType, size_t scaling_factor = 1>
ClosestPair<PointType> examine_random_pairs(std::vector<PointType> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<PointType>::init();
    auto attempts     = scaling_factor * n;

    std::uniform_int_distribution index_generator(0uz, n - 1);

    for (auto _ : std::views::iota(0uz, attempts)) {
        auto i = index_generator(point_selector_randomiser);
        auto j = index_generator(point_selector_randomiser);

        if (i == j) continue;

        auto point_a = points[i], point_b = points[j];

        attempt_to_improve(closest_pair, point_a, point_b);
    }

    return closest_pair;
}
