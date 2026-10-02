#pragma once

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <format>
#include <fstream>
#include <print>
#include <random>
#include <ranges>
#include <string>
#include <utility>
#include <vector>

#include "geometry.hpp"
#include "utilities.hpp"

inline constexpr uint64_t DEFAULT_BASE_SEED = 42;

inline std::mt19937_64 solver_randomiser(DEFAULT_BASE_SEED);

using Dimensions = size_t;

struct Trial {
    uint64_t base_seed;
    Dimensions dimensions;
    size_t point_count;
    size_t trial_number;
};

enum class TrialSeedSuffix {
    Dataset,
    Solver,
};

inline uint64_t seed_for(Trial trial, TrialSeedSuffix suffix) {
    auto seed = trial.base_seed;

    for (uint64_t part : { trial.dimensions,
                           trial.point_count,
                           trial.trial_number,
                           static_cast<uint64_t>(std::to_underlying(suffix)) }) {
        seed = mix_bits(seed ^ mix_bits(part));
    }

    return seed;
}

inline void randomise_coordinates(Point2D &point, auto &randomiser, auto &distribution) {
    point.x = distribution(randomiser);
    point.y = distribution(randomiser);
}

template <size_t dimensions>
void randomise_coordinates(Point<dimensions> &point, auto &randomiser, auto &distribution) {
    for (auto &coordinate : point.vector) coordinate = distribution(randomiser);
}

int32_t safe_max_coordinate_at(Dimensions dimensions);

void save_points_to_disk(Trial trial, const std::vector<Point2D> &points);

template <size_t dimensions>
void save_points_to_disk(Trial trial, const std::vector<Point<dimensions>> &points) {
    auto path
        = std::format("data/general_points_{}D_{}_trial_{:02}.csv", dimensions, trial.point_count, trial.trial_number);

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
std::vector<PointType> generate_points(Trial trial) {
    assert(trial.point_count >= 2);
    assert(trial.dimensions == PointType::dimension_count);

    std::mt19937_64 dataset_randomiser(seed_for(trial, TrialSeedSuffix::Dataset));
    std::uniform_int_distribution coordinate_distribution(0, safe_max_coordinate_at(trial.dimensions));

    std::vector<PointType> points(trial.point_count);

    for (auto &point : points) {
        randomise_coordinates(point, dataset_randomiser, coordinate_distribution);
    }

    return points;
}
