#include "generator.hpp"

#include <algorithm>
#include <cassert>
#include <cmath>
#include <fstream>
#include <map>
#include <print>
#include <ranges>
#include <string>

#include "solvers.hpp"

int32_t safe_max_coordinate_at(Dimensions dimensions) {
    constexpr static int64_t LIMIT = 1'000'000'000'000'000'000LL;
    return static_cast<int32_t>(std::sqrt(static_cast<double>(LIMIT) / dimensions));
}

Generator generator_for(size_t point_count, Dimensions dimensions) {
    return Generator{ .point_count = point_count, .min_value = 0, .max_value = safe_max_coordinate_at(dimensions) };
}

void save_points_to_disk(Generator params, const std::vector<Point2D> &points) {
    auto path = "data/points_" + std::to_string(params.point_count) + ".csv";
    std::ofstream file(path);
    std::println(file, "x,y,is_part_of_shortest_pair");

    auto shortest_pair = sweepline(points);
    auto point_a_idx   = std::ranges::find(points, shortest_pair.point_a) - begin(points);
    auto point_b_idx   = std::ranges::find_last(points, shortest_pair.point_b).begin() - begin(points);

    for (auto [i, point] : std::views::enumerate(points)) {
        std::println(file, "{},{},{}", point.x, point.y, (i == point_a_idx || i == point_b_idx ? 1 : 0));
    }
}
