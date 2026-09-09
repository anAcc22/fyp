#pragma once

#include <compare>
#include <random>
#include <vector>

#include "geometry.hpp"

constexpr auto SEED = 42;

inline std::mt19937_64 point_generator_randomiser(SEED);
inline std::mt19937_64 point_selector_randomiser(SEED);

using Dimensions = int;

struct Generator {
    size_t point_count = 0;
    int32_t min_value = 0, max_value = 0;
    friend auto operator<=>(Generator, Generator) = default;
};

int32_t safe_max_coordinate_at(Dimensions dimensions);

Generator generator_for(size_t point_count, Dimensions dimensions);

void save_points_to_disk(Generator params, const std::vector<Point2D> &points);

std::vector<Point2D> generate_points(Generator params);
