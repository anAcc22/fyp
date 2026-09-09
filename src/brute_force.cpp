#include "solvers.hpp"

#include <limits>
#include <ranges>

ClosestPair<Point2D> examine_all_pairs(std::vector<Point2D> points) {
    auto n = points.size();
    ClosestPair<Point2D> closest_pair{};
    closest_pair.gap = std::numeric_limits<int64_t>::max();

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, n)) {
            attempt_to_improve(closest_pair, points[i], points[j]);
        }
    }

    return closest_pair;
}
