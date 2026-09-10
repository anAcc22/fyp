#pragma once

#include "geometry.hpp"
#include "multithreading.hpp"

#include <algorithm>
#include <cstddef>
#include <numeric>
#include <ranges>
#include <vector>

template <size_t dimensions>
void build_kd_tree(std::vector<Point<dimensions>> &points, size_t l, size_t r, size_t depth) {
    if (!(l < r)) return;

    auto axis = depth % dimensions;
    auto m    = std::midpoint(l, r);

    std::nth_element(begin(points) + l, begin(points) + m, begin(points) + r, [axis](const auto &a, const auto &b) {
        return a.vector[axis] < b.vector[axis];
    });

    build_kd_tree(points, l, m, depth + 1);
    build_kd_tree(points, m + 1, r, depth + 1);
}

template <size_t dimensions>
void find_and_improve_with_kd_tree(
    const std::vector<Point<dimensions>> &points, size_t l, size_t r, size_t depth, size_t query_index,
    ClosestPair<Point<dimensions>> &closest_pair) {
    if (!(l < r)) return;

    auto axis  = depth % dimensions;
    auto m     = std::midpoint(l, r);
    auto query = points[query_index];

    if (m != query_index) attempt_to_improve(closest_pair, query, points[m]);

    int64_t gap_to_plane = int64_t{ query.vector[axis] } - points[m].vector[axis];

    auto near_l = l, near_r = m, far_l = m + 1, far_r = r;

    if (gap_to_plane > 0) {
        std::swap(near_l, far_l);
        std::swap(near_r, far_r);
    }

    find_and_improve_with_kd_tree(points, near_l, near_r, depth + 1, query_index, closest_pair);

    if (gap_to_plane * gap_to_plane >= closest_pair.gap) return;

    find_and_improve_with_kd_tree(points, far_l, far_r, depth + 1, query_index, closest_pair);
}

template <size_t dimensions>
ClosestPair<Point<dimensions>> kd_tree(std::vector<Point<dimensions>> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    build_kd_tree(points, 0uz, n, 0uz);

    for (auto i : std::views::iota(0uz, n)) {
        find_and_improve_with_kd_tree(points, 0uz, n, 0uz, i, closest_pair);
    }

    return closest_pair;
}

template <size_t dimensions>
ClosestPair<Point<dimensions>> parallel_kd_tree(std::vector<Point<dimensions>> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    build_kd_tree(points, 0uz, n, 0uz);

    std::vector<ClosestPair<Point<dimensions>>> best_of_thread(THREAD_COUNT);

    auto solve = [&](size_t start_index) -> void {
        auto closest_pair = ClosestPair<Point<dimensions>>::init();

        for (auto i : std::views::iota(start_index, n) | std::views::stride(THREAD_COUNT)) {
            find_and_improve_with_kd_tree(points, 0uz, n, 0uz, i, closest_pair);
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
