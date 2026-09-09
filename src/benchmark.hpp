#pragma once

#include <chrono>

#include "generator.hpp"
#include "geometry.hpp"

template <typename PointType>
struct RunStatistics {
    ClosestPair<PointType> closest_pair;
    std::chrono::duration<double> time_taken;
};

template <typename PointType>
RunStatistics<PointType> time_taken_by(ClosestPair<PointType> (*solver)(std::vector<PointType>), size_t point_count) {
    auto params       = generator_for(point_count, PointType::dimension_count);
    auto points       = generate_points<PointType>(params);
    auto start_time   = std::chrono::steady_clock::now();
    auto closest_pair = solver(points);
    auto end_time     = std::chrono::steady_clock::now();
    return { .closest_pair = closest_pair, .time_taken = end_time - start_time };
}
