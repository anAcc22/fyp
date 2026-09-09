#include "solvers.hpp"

#include <algorithm>
#include <limits>
#include <ranges>
#include <set>
#include <utility>

#include "utilities.hpp"

ClosestPair sweepline(std::vector<Point2D> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<long long>::max();

    std::ranges::sort(points);

    struct y_comparator {
        bool operator()(Point2D point_a, Point2D point_b) const {
            return std::pair{ point_a.y, point_a.x } < std::pair{ point_b.y, point_b.x };
        }
    };

    std::set<Point2D, y_comparator> candidates;

    for (auto i = 0uz; auto j : std::views::iota(0uz, n)) {
        auto cur_point = points[j];

        while (i < j && squared_distance(cur_point, points[i], Axis::X) >= closest_pair.gap) {
            candidates.erase(points[i++]);
        }

        auto iter_start = begin(candidates);
        auto iter_end   = end(candidates);

        if (closest_pair.gap != std::numeric_limits<long long>::max()) {
            auto y_difference = static_cast<int>(ceiling_square_root(closest_pair.gap));

            iter_start = candidates.lower_bound(Point2D{ 0, cur_point.y - y_difference });
            iter_end   = candidates.upper_bound(Point2D{ 0, cur_point.y + y_difference });
        }

        for (auto iter = iter_start; iter != iter_end; iter++) {
            attempt_to_improve(closest_pair, cur_point, *iter);
        }

        candidates.insert(cur_point);
    }

    return closest_pair;
}
