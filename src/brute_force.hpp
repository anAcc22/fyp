#pragma once

#include "solvers.hpp"
#include "multithreading.hpp"

#include <limits>
#include <ranges>

template <typename PointType>
ClosestPair<PointType> examine_all_pairs(std::vector<PointType> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<PointType>::init();

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, n)) {
            attempt_to_improve(closest_pair, points[i], points[j]);
        }
    }

    return closest_pair;
}

template <typename PointType>
ClosestPair<PointType> examine_all_pairs_in_parallel(std::vector<PointType> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<PointType>::init();

    std::vector<ClosestPair<PointType>> best_of_thread(THREAD_COUNT);

    auto solve = [&](size_t start_index) -> void {
        auto closest_pair = ClosestPair<PointType>::init();

        for (auto i : std::views::iota(start_index, n) | std::views::stride(THREAD_COUNT)) {
            for (auto j : std::views::iota(i + 1, n)) {
                attempt_to_improve(closest_pair, points[i], points[j]);
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
