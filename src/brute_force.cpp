#include "solvers.hpp"

#include <limits>
#include <ranges>

ClosestPair<Point2D> examine_all_pairs(std::vector<Point2D> points) {
    auto n            = points.size();
    auto closest_pair = ClosestPair<Point2D>::init();

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, n)) {
            attempt_to_improve(closest_pair, points[i], points[j]);
        }
    }

    return closest_pair;
}
