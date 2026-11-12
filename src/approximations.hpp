#pragma once

#include "generator.hpp"
#include "geometry.hpp"
#include "heuristics.hpp"
#include "kd_tree.hpp"
#include "z_order.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <format>
#include <limits>
#include <numbers>
#include <numeric>
#include <random>
#include <ranges>
#include <span>
#include <string>
#include <utility>
#include <vector>

template <size_t dimensions>
ClosestPair<Point<dimensions>> examine_neighbours_along_chan_shifted_z_order_curves(std::vector<Point<dimensions>> points) {
    auto closest_pair = ClosestPair<Point<dimensions>>::init();

    constexpr size_t even_dimensions = dimensions % 2 == 0 ? dimensions : dimensions + 1;
    constexpr size_t shift_count     = even_dimensions + 1;

    uint64_t shift_range = shift_range_of(points);

    for (auto shift_index : std::views::iota(0uz, shift_count)) {
        std::array<uint32_t, dimensions> shift;
        shift.fill(static_cast<uint32_t>(shift_index * shift_range / shift_count));

        examine_neighbours_in_z_order(points, shift, 1, closest_pair);
    }

    return closest_pair;
}

struct ApproximateBestFirstKdTreeParams {
    double epsilon = 0.1;
};

template <>
struct std::formatter<ApproximateBestFirstKdTreeParams> : std::formatter<std::string> {
    auto format(const ApproximateBestFirstKdTreeParams &params, auto &ctx) const {
        return std::format_to(ctx.out(), "epsilon={}", params.epsilon);
    }
};

template <size_t dimensions>
ClosestPair<Point<dimensions>>
approximate_best_first_kd_tree(std::vector<Point<dimensions>> points, ApproximateBestFirstKdTreeParams params) {
    return best_first_kd_tree_search(std::move(points), std::numeric_limits<size_t>::max(), params.epsilon);
}

struct LocalitySensitiveHashingParams {
    size_t hashes_per_table = 4;
    size_t table_count      = 8;
};

template <>
struct std::formatter<LocalitySensitiveHashingParams> : std::formatter<std::string> {
    auto format(const LocalitySensitiveHashingParams &params, auto &ctx) const {
        return std::format_to(
            ctx.out(), "hashes_per_table={}, table_count={}", params.hashes_per_table, params.table_count);
    }
};

inline constexpr ExamineNeighboursAlongZOrderCurveParams LOCALITY_SENSITIVE_HASHING_SEED_PARAMS{
    .shift_count          = 2,
    .neighbours_per_point = 2,
};

inline constexpr double BUCKET_WIDTH_PER_TARGET_DISTANCE = 4.0;

template <size_t dimensions>
void for_each_shared_bucket(
    const std::vector<Point<dimensions>> &points, size_t hashes_per_table, double bucket_width,
    std::normal_distribution<double> &component_distribution, auto &&examine_bucket) {
    auto n = points.size();

    std::uniform_real_distribution<double> offset_distribution(0.0, bucket_width);

    std::vector<int64_t> buckets(n * hashes_per_table);
    std::vector<size_t> order(n);

    auto buckets_of = [&](size_t index) { return std::span(buckets).subspan(index * hashes_per_table, hashes_per_table); };

    for (auto hash_index : std::views::iota(0uz, hashes_per_table)) {
        std::array<double, dimensions> direction;
        for (auto &component : direction) component = component_distribution(solver_randomiser);
        auto offset = offset_distribution(solver_randomiser);

        for (auto i : std::views::iota(0uz, n)) {
            auto position = (projection_of(points[i], direction) + offset) / bucket_width;
            buckets[i * hashes_per_table + hash_index] = static_cast<int64_t>(std::floor(position));
        }
    }

    std::iota(begin(order), end(order), 0uz);
    std::ranges::sort(order, [&](size_t index_a, size_t index_b) {
        return std::ranges::lexicographical_compare(buckets_of(index_a), buckets_of(index_b));
    });

    for (auto bucket_start = 0uz; bucket_start < n;) {
        auto bucket_end = bucket_start + 1;
        while (bucket_end < n && std::ranges::equal(buckets_of(order[bucket_start]), buckets_of(order[bucket_end]))) {
            bucket_end++;
        }

        examine_bucket(std::span<const size_t>(order).subspan(bucket_start, bucket_end - bucket_start));

        bucket_start = bucket_end;
    }
}

template <size_t dimensions>
ClosestPair<Point<dimensions>>
locality_sensitive_hashing(std::vector<Point<dimensions>> points, LocalitySensitiveHashingParams params) {
    auto closest_pair = examine_neighbours_along_z_order_curve(points, LOCALITY_SENSITIVE_HASHING_SEED_PARAMS);

    if (closest_pair.gap == 0) return closest_pair;

    auto bucket_width = BUCKET_WIDTH_PER_TARGET_DISTANCE * std::sqrt(static_cast<double>(closest_pair.gap));

    std::normal_distribution<double> component_distribution;

    for (auto _ : std::views::iota(0uz, params.table_count)) {
        for_each_shared_bucket(
            points, params.hashes_per_table, bucket_width, component_distribution,
            [&](std::span<const size_t> bucket) {
                for (auto i : std::views::iota(0uz, bucket.size())) {
                    for (auto j : std::views::iota(i + 1, bucket.size())) {
                        attempt_to_improve(closest_pair, points[bucket[i]], points[bucket[j]]);
                    }
                }
            });
    }

    return closest_pair;
}

struct ApproximateLocalitySensitiveHashingParams {
    double approximation_factor  = 2.0;
    size_t attempts_per_distance = 1;
};

template <>
struct std::formatter<ApproximateLocalitySensitiveHashingParams> : std::formatter<std::string> {
    auto format(const ApproximateLocalitySensitiveHashingParams &params, auto &ctx) const {
        return std::format_to(
            ctx.out(),
            "approximation_factor={}, attempts_per_distance={}",
            params.approximation_factor,
            params.attempts_per_distance);
    }
};

inline double p_stable_collision_chance(double bucket_width_per_distance) {
    auto bell_curve_height = [](double x) { return std::exp(-x * x / 2) / std::sqrt(2 * std::numbers::pi); };
    auto chance_projected_gap_fits = std::erf(bucket_width_per_distance / std::numbers::sqrt2);
    return chance_projected_gap_fits
           - (2 / bucket_width_per_distance) * (bell_curve_height(0) - bell_curve_height(bucket_width_per_distance));
}

struct LocalitySensitiveHashingTables {
    size_t hashes_per_table;
    size_t table_count;
    size_t candidates_per_point;
};

inline LocalitySensitiveHashingTables tables_for(size_t point_count, double approximation_factor) {
    auto near_collision_chance = p_stable_collision_chance(BUCKET_WIDTH_PER_TARGET_DISTANCE);
    auto far_collision_chance  = p_stable_collision_chance(BUCKET_WIDTH_PER_TARGET_DISTANCE / approximation_factor);

    auto log_point_count = std::log(static_cast<double>(point_count));
    auto exponent        = std::log(1 / near_collision_chance) / std::log(1 / far_collision_chance);
    auto table_count     = static_cast<size_t>(std::ceil(std::exp(exponent * log_point_count)));

    return {
        .hashes_per_table     = static_cast<size_t>(std::ceil(log_point_count / std::log(1 / far_collision_chance))),
        .table_count          = table_count,
        .candidates_per_point = 3 * table_count,
    };
}

template <size_t dimensions>
ClosestPair<Point<dimensions>> approximate_locality_sensitive_hashing(
    std::vector<Point<dimensions>> points, ApproximateLocalitySensitiveHashingParams params) {
    auto n            = points.size();
    auto closest_pair = examine_neighbours_along_z_order_curve(points, LOCALITY_SENSITIVE_HASHING_SEED_PARAMS);

    auto factor_per_distance = std::sqrt(params.approximation_factor);
    auto tables              = tables_for(n, factor_per_distance);

    std::normal_distribution<double> component_distribution;
    std::vector<size_t> candidates_checked(n);
    std::vector<bool> query_finished(n);

    for (auto target_distance = std::sqrt(static_cast<double>(closest_pair.gap)) / factor_per_distance;
         closest_pair.gap > 0;
         target_distance /= factor_per_distance) {
        auto reach              = factor_per_distance * target_distance;
        auto found_within_reach = false;

        for (auto _ : std::views::iota(0uz, params.attempts_per_distance)) {
            std::ranges::fill(candidates_checked, 0uz);
            std::ranges::fill(query_finished, false);

            for (auto _ : std::views::iota(0uz, tables.table_count)) {
                for_each_shared_bucket(
                    points, tables.hashes_per_table, BUCKET_WIDTH_PER_TARGET_DISTANCE * target_distance,
                    component_distribution, [&](std::span<const size_t> bucket) {
                        for (auto query : bucket) {
                            for (auto candidate : bucket) {
                                if (query_finished[query]) break;
                                if (candidate == query) continue;

                                auto gap = squared_euclidean_distance_between(points[query], points[candidate]);
                                if (gap < closest_pair.gap) closest_pair = { points[query], points[candidate], gap };

                                if (static_cast<double>(gap) <= reach * reach) {
                                    found_within_reach    = true;
                                    query_finished[query] = true;
                                } else if (++candidates_checked[query] == tables.candidates_per_point) {
                                    query_finished[query] = true;
                                }
                            }
                        }
                    });
            }

            if (found_within_reach) break;
        }

        if (!found_within_reach) break;
    }

    return closest_pair;
}
