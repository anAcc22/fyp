#pragma once

#include <algorithm>
#include <cassert>
#include <concepts>
#include <compare>
#include <random>
#include <fstream>
#include <vector>
#include <map>

#include "geometry.hpp"

constexpr auto SEED = 42;

inline std::mt19937_64 point_generator_randomiser(SEED);
inline std::mt19937_64 point_selector_randomiser(SEED);

using Dimensions = size_t;

struct Generator {
    size_t point_count = 0;
    int32_t min_value = 0, max_value = 0;
    friend auto operator<=>(Generator, Generator) = default;
};

inline void randomise_coordinates(Point2D &point, auto &randomiser, auto &distribution) {
    point.x = distribution(randomiser);
    point.y = distribution(randomiser);
}

template <size_t dimensions>
void randomise_coordinates(Point<dimensions> &point, auto &randomiser, auto &distribution) {
    for (auto &coordinate : point.vector) coordinate = distribution(randomiser);
}

int32_t safe_max_coordinate_at(Dimensions dimensions);

Generator generator_for(size_t point_count, Dimensions dimensions);

void save_points_to_disk(Generator params, const std::vector<Point2D> &points);

template <size_t dimensions>
void save_points_to_disk(Generator params, const std::vector<Point<dimensions>> &points) {
    auto path
        = "data/general_points_" + std::to_string(dimensions) + "D_" + std::to_string(params.point_count) + ".csv";

    std::ofstream file(path);

    std::println(
        file,
        "{}",
        std::views::iota(0uz, dimensions) | std::views::transform([](auto i) { return std::format("x{}", i); })
            | std::views::join_with(',') | std::ranges::to<std::string>());

    for (auto [i, point] : std::views::enumerate(points)) {
        std::string row;
        for (auto [j, x] : std::views::enumerate(point.vector)) {
            if (j) row += ",";
            row += std::to_string(x);
        }
        std::println(file, "{}", row);
    }
}

template <typename PointType>
std::vector<PointType> generate_points(Generator params) {
    assert(params.point_count >= 2);

    static std::map<Generator, std::vector<PointType>> cached_points;
    if (cached_points.contains(params)) return cached_points[params];

    std::vector<PointType> points(params.point_count);
    std::uniform_int_distribution coord_generator(params.min_value, params.max_value);

    for (auto &point : points) {
        randomise_coordinates(point, point_generator_randomiser, coord_generator);
    }

    save_points_to_disk(params, points);

    return cached_points[params] = points;
}
