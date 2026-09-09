#include "solvers.hpp"

#include <algorithm>
#include <limits>
#include <random>
#include <ranges>
#include <thread>
#include <unordered_map>
#include <utility>
#include <vector>

#include "generator.hpp"
#include "grid.hpp"
#include "utilities.hpp"

ClosestPair grid_decomposition(std::vector<Point2D> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<int64_t>::max();

    int64_t grid_width_squared = std::numeric_limits<int64_t>::max();
    std::uniform_int_distribution index_generator(0uz, n - 1);

    for (auto _ : std::views::iota(0uz, n)) {
        auto i = index_generator(point_selector_randomiser);
        auto j = index_generator(point_selector_randomiser);

        if (i == j) continue;

        auto point_a = points[i], point_b = points[j];

        if (point_a == point_b) {
            closest_pair.point_a = point_a;
            closest_pair.point_b = point_b;
            closest_pair.gap     = 0;
            return closest_pair;
        }

        grid_width_squared = std::min(grid_width_squared, squared_euclidean_distance_between(point_a, point_b));
    }

    auto grid_width = ceiling_square_root(grid_width_squared);

    std::unordered_map<GridSquare, std::vector<Point2D>> points_by_square;
    points_by_square.reserve(n);

    for (auto point : points) {
        auto square_x = point.x / grid_width, square_y = point.y / grid_width;
        points_by_square[{ square_x, square_y }].push_back(point);
    }

    for (const auto &[square, inner_points] : points_by_square) {
        auto cnt = inner_points.size();

        for (auto i : std::views::iota(0uz, cnt)) {
            for (auto j : std::views::iota(i + 1, cnt)) {
                attempt_to_improve(closest_pair, inner_points[i], inner_points[j]);
            }
        }

        for (auto [offset_x, offset_y] : { std::pair{ 1, -1 }, { 1, 0 }, { 1, 1 }, { 0, 1 } }) {

            auto outer_square_x = square.x + offset_x, outer_square_y = square.y + offset_y;
            GridSquare outer_square{ outer_square_x, outer_square_y };

            auto iter = points_by_square.find(outer_square);
            if (iter == end(points_by_square)) continue;

            const auto &outer_points = iter->second;

            for (auto [point_a, point_b] : std::views::cartesian_product(inner_points, outer_points)) {
                attempt_to_improve(closest_pair, point_a, point_b);
            }
        }
    }

    return closest_pair;
}

ClosestPair parallel_grid_decomposition(std::vector<Point2D> points) {
    static ThreadCount thread_cnt = std::thread::hardware_concurrency();

    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<int64_t>::max();

    int64_t grid_width_squared = std::numeric_limits<int64_t>::max();
    std::uniform_int_distribution index_generator(0uz, n - 1);

    for (auto _ : std::views::iota(0uz, n)) {
        auto i = index_generator(point_selector_randomiser);
        auto j = index_generator(point_selector_randomiser);

        if (i == j) continue;

        auto point_a = points[i], point_b = points[j];

        if (point_a == point_b) {
            closest_pair.point_a = point_a;
            closest_pair.point_b = point_b;
            closest_pair.gap     = 0;
            return closest_pair;
        }

        grid_width_squared = std::min(grid_width_squared, squared_euclidean_distance_between(point_a, point_b));
    }

    auto grid_width = ceiling_square_root(grid_width_squared);

    std::unordered_map<GridSquare, std::vector<Point2D>> points_by_square;
    points_by_square.reserve(n);

    for (auto point : points) {
        auto square_x = point.x / grid_width, square_y = point.y / grid_width;
        points_by_square[{ square_x, square_y }].push_back(point);
    }

    std::vector<ClosestPair> best_of_thread(thread_cnt);
    std::vector<decltype(begin(points_by_square))> point_iterators;
    point_iterators.reserve(n);

    for (auto u = begin(points_by_square); u != end(points_by_square); u++) {
        point_iterators.push_back(u);
    }

    auto solve = [&](int start_index) -> void {
        ClosestPair closest_pair{};
        closest_pair.gap = std::numeric_limits<int64_t>::max();

        for (const auto u : point_iterators | std::views::drop(start_index) | std::views::stride(thread_cnt)) {
            const auto &square       = u->first;
            const auto &inner_points = u->second;

            auto cnt = inner_points.size();

            for (auto i : std::views::iota(0uz, cnt)) {
                for (auto j : std::views::iota(i + 1, cnt)) {
                    attempt_to_improve(closest_pair, inner_points[i], inner_points[j]);
                }
            }

            for (auto [offset_x, offset_y] : { std::pair{ 1, -1 }, { 1, 0 }, { 1, 1 }, { 0, 1 } }) {

                auto outer_square_x = square.x + offset_x, outer_square_y = square.y + offset_y;
                GridSquare outer_square{ outer_square_x, outer_square_y };

                auto iter = points_by_square.find(outer_square);
                if (iter == end(points_by_square)) continue;

                const auto &outer_points = iter->second;

                for (auto [point_a, point_b] : std::views::cartesian_product(inner_points, outer_points)) {
                    attempt_to_improve(closest_pair, point_a, point_b);
                }
            }
        }

        best_of_thread[start_index] = closest_pair;
    };

    {
        std::vector<std::jthread> threads;

        for (auto i : std::views::iota(0, thread_cnt)) {
            threads.emplace_back(solve, i);
        }
    }

    for (auto i : std::views::iota(0, thread_cnt)) {
        const auto &thread_best = best_of_thread[i];
        if (thread_best.gap < closest_pair.gap) closest_pair = thread_best;
    }

    return closest_pair;
}
