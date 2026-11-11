#pragma once

#include "geometry.hpp"
#include "multithreading.hpp"

#include <algorithm>
#include <atomic>
#include <cstddef>
#include <cstdint>
#include <numeric>
#include <ranges>
#include <vector>

template <size_t dimensions>
void build_kd_tree(std::vector<Point<dimensions>> &points, size_t l, size_t r, size_t depth) {
    if (!(l < r)) return;

    auto axis = depth % dimensions;
    auto m    = std::midpoint(l, r);

    std::nth_element(begin(points) + l, begin(points) + m, begin(points) + r, [axis](const auto &a, const auto &b) {
        return a[axis] < b[axis];
    });

    build_kd_tree(points, l, m, depth + 1);
    build_kd_tree(points, m + 1, r, depth + 1);
}

template <size_t dimensions>
void find_and_improve_with_kd_tree(
    const std::vector<Point<dimensions>> &points, size_t l, size_t r, size_t depth, size_t query_index,
    ClosestPair<Point<dimensions>> &closest_pair,
    int64_t outside_bound = ClosestPair<Point<dimensions>>::INFINITE_GAP) {
    if (!(l < r)) return;

    auto axis  = depth % dimensions;
    auto m     = std::midpoint(l, r);
    auto query = points[query_index];

    if (m != query_index) attempt_to_improve(closest_pair, query, points[m]);

    int64_t gap_to_plane = int64_t{ query[axis] } - points[m][axis];

    auto near_l = l, near_r = m, far_l = m + 1, far_r = r;

    if (gap_to_plane > 0) {
        std::swap(near_l, far_l);
        std::swap(near_r, far_r);
    }

    find_and_improve_with_kd_tree(points, near_l, near_r, depth + 1, query_index, closest_pair, outside_bound);

    if (gap_to_plane * gap_to_plane >= std::min(closest_pair.gap, outside_bound)) return;

    find_and_improve_with_kd_tree(points, far_l, far_r, depth + 1, query_index, closest_pair, outside_bound);
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
    std::atomic<int64_t> shared_gap{ ClosestPair<Point<dimensions>>::INFINITE_GAP };

    auto solve = [&](size_t start_index) -> void {
        auto closest_pair = ClosestPair<Point<dimensions>>::init();

        for (auto i = start_index; i < n; i += THREAD_COUNT) {
            auto snapshot = shared_gap.load(std::memory_order_relaxed);
            find_and_improve_with_kd_tree(points, 0uz, n, 0uz, i, closest_pair, snapshot);

            auto current = shared_gap.load(std::memory_order_relaxed);
            while (closest_pair.gap < current
                   && !shared_gap.compare_exchange_weak(current, closest_pair.gap, std::memory_order_relaxed)) {
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

struct KdTreeRegion {
    int64_t lower_bound;
    size_t l, r, depth;
};

template <size_t dimensions>
ClosestPair<Point<dimensions>>
best_first_kd_tree_search(std::vector<Point<dimensions>> points, size_t comparisons_per_point, double epsilon) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    build_kd_tree(points, 0uz, n, 0uz);

    auto further_away = [](const KdTreeRegion &region_a, const KdTreeRegion &region_b) {
        return region_a.lower_bound > region_b.lower_bound;
    };

    auto squared_slack = (1 + epsilon) * (1 + epsilon);

    auto cannot_improve_enough = [&](int64_t lower_bound) {
        return lower_bound >= closest_pair.gap
               || (epsilon > 0
                   && static_cast<double>(lower_bound) * squared_slack >= static_cast<double>(closest_pair.gap));
    };

    std::vector<KdTreeRegion> regions_to_visit;

    for (auto query_index : std::views::iota(0uz, n)) {
        auto query       = points[query_index];
        auto comparisons = 0uz;

        regions_to_visit.clear();
        regions_to_visit.push_back({ .lower_bound = 0, .l = 0, .r = n, .depth = 0 });

        while (!regions_to_visit.empty() && comparisons < comparisons_per_point) {
            std::ranges::pop_heap(regions_to_visit, further_away);
            auto region = regions_to_visit.back();
            regions_to_visit.pop_back();

            if (cannot_improve_enough(region.lower_bound)) break;

            auto axis = region.depth % dimensions;
            auto m    = std::midpoint(region.l, region.r);

            if (m != query_index) {
                attempt_to_improve(closest_pair, query, points[m]);
                comparisons++;
            }

            int64_t gap_to_plane = int64_t{ query[axis] } - points[m][axis];

            KdTreeRegion lower_side{ region.lower_bound, region.l, m, region.depth + 1 };
            KdTreeRegion upper_side{ region.lower_bound, m + 1, region.r, region.depth + 1 };

            auto &far_side       = gap_to_plane > 0 ? lower_side : upper_side;
            far_side.lower_bound = std::max(region.lower_bound, gap_to_plane * gap_to_plane);

            for (const auto &side : { lower_side, upper_side }) {
                if (side.l < side.r && !cannot_improve_enough(side.lower_bound)) {
                    regions_to_visit.push_back(side);
                    std::ranges::push_heap(regions_to_visit, further_away);
                }
            }
        }
    }

    return closest_pair;
}
