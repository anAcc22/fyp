#include <algorithm>
#include <cassert>
#include <numeric>
#include <limits>
#include <cmath>
#include <chrono>
#include <ranges>
#include <format>
#include <print>
#include <random>
#include <vector>
#include <string>
#include <map>

constexpr auto SEED = 42;
std::mt19937_64 randomiser(SEED);

using Dimensions = int;

struct Generator {
    int point_count = 0;
    int min_value = 0, max_value = 0;
    friend auto operator<=>(Generator, Generator) = default;
};

int safe_max_coordinate_at(Dimensions dimensions) {
    constexpr static long long LIMIT = 1'000'000'000'000'000'000LL;
    return static_cast<int>(std::sqrt(static_cast<double>(LIMIT) / dimensions));
}

Generator generator_for(int point_count, Dimensions dimensions) {
    return Generator{ .point_count = point_count, .min_value = 0, .max_value = safe_max_coordinate_at(dimensions) };
}

struct Point {
    int x, y;
    friend auto operator<=>(Point, Point) = default;
};

template <>
struct std::formatter<Point> : std::formatter<std::string> {
    auto format(const Point &p, auto &ctx) const { return std::format_to(ctx.out(), "({:L}, {:L})", p.x, p.y); }
};

struct ClosestPair {
    Point point_a, point_b;
    long long gap;
};

template <>
struct std::formatter<ClosestPair> : std::formatter<std::string> {
    auto format(const ClosestPair &pair, auto &ctx) const {
        auto [point_a, point_b, gap] = pair;
        return std::format_to(ctx.out(), "{} <-> {} (gap: {:L})", point_a, point_b, gap);
    }
};

std::vector<Point> generate_points(Generator params) {
    assert(params.point_count >= 2);
    static std::map<Generator, std::vector<Point>> cached_points;
    if (cached_points.contains(params)) return cached_points[params];
    std::vector<Point> points(params.point_count);
    std::uniform_int_distribution coord_generator(params.min_value, params.max_value);
    for (auto &[x, y] : points) {
        x = coord_generator(randomiser);
        y = coord_generator(randomiser);
    }
    return cached_points[params] = points;
}

enum class Axis {
    X,
    Y,
};

long long squared_distance(Point point_a, Point point_b, Axis axis) {
    long long gap = (axis == Axis::X ? point_a.x - point_b.x : point_a.y - point_b.y);
    return gap * gap;
}

long long squared_euclidean_distance_between(Point point_a, Point point_b) {
    return squared_distance(point_a, point_b, Axis::X) + squared_distance(point_a, point_b, Axis::Y);
}

void attempt_to_improve(ClosestPair &closest_pair, Point point_a, Point point_b) {
    if (auto gap = squared_euclidean_distance_between(point_a, point_b); gap < closest_pair.gap) {
        closest_pair = { point_a, point_b, gap };
    }
}

ClosestPair examine_all_pairs(std::vector<Point> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<long long>::max();

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, n)) {
            attempt_to_improve(closest_pair, points[i], points[j]);
        }
    }

    return closest_pair;
}

ClosestPair divide_and_conquer(std::vector<Point> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<long long>::max();

    auto temporary_storage(points);
    std::ranges::sort(points);

    auto y_comparator = [](Point point_a, Point point_b) { return point_a.y < point_b.y; };

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

        for (int temp_idx = 0; auto i : std::views::iota(l, r)) {
            if (squared_distance(points[i], Point{ middle_x, 0 }, Axis::X) >= closest_pair.gap) continue;
            for (int j = temp_idx - 1;
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

struct RunStatistics {
    ClosestPair closest_pair;
    std::chrono::duration<double> time_taken;
};

RunStatistics time_taken_by(auto solver, Generator params) {
    auto points       = generate_points(params);
    auto start_time   = std::chrono::steady_clock::now();
    auto closest_pair = solver(points);
    auto end_time     = std::chrono::steady_clock::now();
    return { .closest_pair = closest_pair, .time_taken = end_time - start_time };
}

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector point_counts{ 20'000, 40'000, 60'000, 80'000 };

    for (auto n : point_counts) {
        auto stats = time_taken_by(examine_all_pairs, generator_for(n, Dimensions{ 2 }));

        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    std::println();

    for (auto n : point_counts) {
        auto stats = time_taken_by(divide_and_conquer, generator_for(n, Dimensions{ 2 }));

        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    return 0;
}
