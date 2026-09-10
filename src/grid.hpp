#pragma once

#include "generator.hpp"
#include "geometry.hpp"
#include "multithreading.hpp"
#include "utilities.hpp"
#include <compare>
#include <cstddef>
#include <cstdint>
#include <functional>

struct GridSquare {
    int64_t x, y;
    friend auto operator<=>(GridSquare, GridSquare) = default;
};

template <>
struct std::hash<GridSquare> {
    size_t operator()(GridSquare square) const noexcept {
        auto mix = [](uint64_t x) {
            x += 0x9e3779b97f4a7c15;
            x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
            x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
            return x ^ (x >> 31);
        };
        return mix(square.x) ^ (mix(square.y) << 1);
    }
};

ClosestPair<Point2D> grid_decomposition(std::vector<Point2D> points);

ClosestPair<Point2D> parallel_grid_decomposition(std::vector<Point2D> points);

template <size_t dimensions>
    requires(dimensions >= 1)
struct GridBox {
    static constexpr size_t dimension_count = dimensions;
    std::array<int64_t, dimensions> vector;
    friend auto operator<=>(GridBox, GridBox) = default;
};

template <size_t dimensions>
struct std::hash<GridBox<dimensions>> {
    size_t operator()(GridBox<dimensions> box) const noexcept {
        auto mix = [](uint64_t x) {
            x += 0x9e3779b97f4a7c15;
            x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
            x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
            return x ^ (x >> 31);
        };
        size_t answer{};
        for (auto x : box.vector) answer = mix(answer ^ mix(x));
        return answer;
    }
};

template <
    size_t dimensions, GridWidthStrategy strategy = GridWidthStrategy::Sampling,
    double multiplier = DEFAULT_GRID_WIDTH_MULTIPLIER>
ClosestPair<Point<dimensions>> grid_decomposition(std::vector<Point<dimensions>> points) {
    auto n = points.size();

    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    int64_t grid_width{};

    if constexpr (strategy == GridWidthStrategy::Sampling) {
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

        grid_width = ceiling_square_root(grid_width_squared);
    } else {
        grid_width = expected_nearest_neighbour_distance<dimensions, multiplier>(points);
    }

    std::unordered_map<GridBox<dimensions>, std::vector<Point<dimensions>>> points_by_box;
    points_by_box.reserve(n);

    for (auto point : points) {
        GridBox<dimensions> box{};
        for (auto [i, x] : std::views::enumerate(point.vector)) box.vector[i] = x / grid_width;
        points_by_box[box].push_back(point);
    }

    for (const auto &[box, inner_points] : points_by_box) {
        auto cnt = inner_points.size();

        for (auto i : std::views::iota(0uz, cnt)) {
            for (auto j : std::views::iota(i + 1, cnt)) {
                attempt_to_improve(closest_pair, inner_points[i], inner_points[j]);
            }
        }

        for (auto raw_offset : std::views::iota(0uz, fast_exponentiation(3uz, dimensions))) {
            auto offset = offset_from<dimensions>(raw_offset);

            if (auto u = std::ranges::find_if(offset, [](auto x) { return x; }); u == end(offset) || *u <= 0) continue;

            auto outer_box = box;

            for (auto i : std::views::iota(0uz, dimensions)) {
                outer_box.vector[i] += offset[i];
            }

            auto iter = points_by_box.find(outer_box);
            if (iter == end(points_by_box)) continue;

            const auto &outer_points = iter->second;

            for (auto [point_a, point_b] : std::views::cartesian_product(inner_points, outer_points)) {
                attempt_to_improve(closest_pair, point_a, point_b);
            }
        }
    }

    return closest_pair;
}

template <
    size_t dimensions, GridWidthStrategy strategy = GridWidthStrategy::Sampling,
    double multiplier = DEFAULT_GRID_WIDTH_MULTIPLIER>
ClosestPair<Point<dimensions>> parallel_grid_decomposition(std::vector<Point<dimensions>> points) {
    auto n = points.size();

    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    int64_t grid_width{};

    if constexpr (strategy == GridWidthStrategy::Sampling) {
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

        grid_width = ceiling_square_root(grid_width_squared);
    } else {
        grid_width = expected_nearest_neighbour_distance<dimensions, multiplier>(points);
    }

    std::unordered_map<GridBox<dimensions>, std::vector<Point<dimensions>>> points_by_box;
    points_by_box.reserve(n);

    for (auto point : points) {
        GridBox<dimensions> box{};
        for (auto [i, x] : std::views::enumerate(point.vector)) box.vector[i] = x / grid_width;
        points_by_box[box].push_back(point);
    }

    std::vector<ClosestPair<Point<dimensions>>> best_of_thread(THREAD_COUNT);
    std::vector<decltype(begin(points_by_box))> point_iterators;
    point_iterators.reserve(n);

    for (auto u = begin(points_by_box); u != end(points_by_box); u++) {
        point_iterators.push_back(u);
    }

    auto solve = [&](size_t start_index) -> void {
        auto closest_pair = ClosestPair<Point<dimensions>>::init();

        for (const auto box_and_points :
             point_iterators | std::views::drop(start_index) | std::views::stride(THREAD_COUNT)) {
            const auto &box          = box_and_points->first;
            const auto &inner_points = box_and_points->second;

            auto cnt = inner_points.size();

            for (auto i : std::views::iota(0uz, cnt)) {
                for (auto j : std::views::iota(i + 1, cnt)) {
                    attempt_to_improve(closest_pair, inner_points[i], inner_points[j]);
                }
            }

            for (auto raw_offset : std::views::iota(0uz, fast_exponentiation(3uz, dimensions))) {
                auto offset = offset_from<dimensions>(raw_offset);

                if (auto u = std::ranges::find_if(offset, [](auto x) { return x; }); u == end(offset) || *u <= 0)
                    continue;

                auto outer_box = box;

                for (auto i : std::views::iota(0uz, dimensions)) {
                    outer_box.vector[i] += offset[i];
                }

                auto iter = points_by_box.find(outer_box);
                if (iter == end(points_by_box)) continue;

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

        for (auto i : std::views::iota(0uz, THREAD_COUNT)) {
            threads.emplace_back(solve, i);
        }
    }

    for (auto i : std::views::iota(0uz, THREAD_COUNT)) {
        const auto &thread_best = best_of_thread[i];
        if (thread_best.gap < closest_pair.gap) closest_pair = thread_best;
    }

    return closest_pair;
}
