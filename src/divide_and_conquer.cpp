#include "solvers.hpp"

#include <algorithm>
#include <limits>
#include <numeric>
#include <ranges>

ClosestPair<Point2D> divide_and_conquer(std::vector<Point2D> points) {
    auto n = points.size();
    ClosestPair<Point2D> closest_pair{};
    closest_pair.gap = std::numeric_limits<int64_t>::max();

    auto temporary_storage(points);
    std::ranges::sort(points);

    auto y_comparator = [](Point2D point_a, Point2D point_b) { return point_a.y < point_b.y; };

    auto dfs = [&](this auto &&self, int l, int r) {
        if (r - l <= 3) {
            for (auto i : std::views::iota(l, r)) {
                for (auto j : std::views::iota(i + 1, r)) {
                    attempt_to_improve(closest_pair, points[i], points[j]);
                }
            }
            sort(begin(points) + l, begin(points) + r, y_comparator);
            return;
        }

        auto m = std::midpoint(l, r);

        int middle_x = points[m].x;

        self(l, m);
        self(m, r);

        merge(
            begin(points) + l,
            begin(points) + m,
            begin(points) + m,
            begin(points) + r,
            begin(temporary_storage),
            y_comparator);
        copy(begin(temporary_storage), begin(temporary_storage) + (r - l), begin(points) + l);

        for (int32_t temp_idx{}; auto i : std::views::iota(l, r)) {
            if (squared_distance(points[i], Point2D{ middle_x, 0 }, Axis::X) >= closest_pair.gap) continue;
            for (int32_t j = temp_idx - 1;
                 j >= 0 && squared_distance(points[i], temporary_storage[j], Axis::Y) < closest_pair.gap;
                 j--) {
                attempt_to_improve(closest_pair, points[i], temporary_storage[j]);
            }
            temporary_storage[temp_idx++] = points[i];
        };
    };
    dfs(0, n);

    return closest_pair;
}
