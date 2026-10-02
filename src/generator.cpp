#include "generator.hpp"
#include "sweepline.hpp"

#include <algorithm>
#include <cmath>
#include <format>
#include <fstream>
#include <print>
#include <ranges>

int32_t safe_max_coordinate_at(Dimensions dimensions) {
    constexpr static int64_t LIMIT = 1'000'000'000'000'000'000LL;
    return static_cast<int32_t>(std::sqrt(static_cast<double>(LIMIT) / dimensions));
}

void save_points_to_disk(Trial trial, const std::vector<Point2D> &points) {
    auto path = std::format("data/points_2D_only_{}_trial_{:02}.csv", trial.point_count, trial.trial_number);
    std::ofstream file(path);
    std::println(file, "x,y,is_part_of_shortest_pair");

    auto shortest_pair = sweepline(points);
    auto point_a_idx   = std::ranges::find(points, shortest_pair.point_a) - begin(points);
    auto point_b_idx   = std::ranges::find_last(points, shortest_pair.point_b).begin() - begin(points);

    for (auto [i, point] : std::views::enumerate(points)) {
        std::println(file, "{},{},{}", point.x, point.y, (i == point_a_idx || i == point_b_idx ? 1 : 0));
    }
}
