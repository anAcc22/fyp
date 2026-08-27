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
#include <set>
#include <unordered_map>
#include <vector>
#include <string>
#include <map>

template <typename T>
T ceiling_square_root(T x) {
    T low = 0, high = sqrt(x), ans = -1;
    while (low <= high) {
        auto mid = std::midpoint(low, high);
        if (mid * mid < x) ans = mid, low = mid + 1;
        else high = mid - 1;
    }
    return ans + 1;
}

constexpr auto SEED = 42;

std::mt19937_64 point_generator_randomiser(SEED);
std::mt19937_64 point_selector_randomiser(SEED);

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
        x = coord_generator(point_generator_randomiser);
        y = coord_generator(point_generator_randomiser);
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

ClosestPair sweepline(std::vector<Point> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<long long>::max();

    auto temporary_storage(points);
    std::ranges::sort(points);

    struct y_comparator {
        bool operator()(Point point_a, Point point_b) const { return point_a.y < point_b.y; }
    };

    std::set<Point, y_comparator> candidates;

    for (auto i = 0uz; auto j : std::views::iota(0uz, n)) {
        auto cur_point = points[j];

        while (i < j && squared_distance(cur_point, points[i], Axis::X) >= closest_pair.gap) {
            candidates.erase(points[i++]);
        }

        int y_difference = ceiling_square_root(closest_pair.gap);
        auto iter_start  = candidates.lower_bound(Point{ 0, cur_point.y - y_difference });
        auto iter_end    = candidates.upper_bound(Point{ 0, cur_point.y + y_difference });

        for (auto iter = iter_start; iter != iter_end; iter++) {
            attempt_to_improve(closest_pair, cur_point, *iter);
        }

        candidates.insert(cur_point);
    }

    return closest_pair;
}

struct GridSquare {
    long long x, y;
    friend auto operator<=>(GridSquare, GridSquare) = default;
};

template <>
struct std::hash<GridSquare> {
    size_t operator()(GridSquare square) const noexcept {
        auto mix = [](unsigned long long x) {
            x += 0x9e3779b97f4a7c15;
            x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
            x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
            return x ^ (x >> 31);
        };
        return mix(square.x) ^ (mix(square.y) << 1);
    }
};

ClosestPair grid_decomposition(std::vector<Point> points) {
    auto n = points.size();
    ClosestPair closest_pair{};
    closest_pair.gap = std::numeric_limits<long long>::max();

    long long grid_width_squared = std::numeric_limits<long long>::max();
    std::uniform_int_distribution index_generator(0uz, n - 1);

    for (auto _ : std::views::iota(0uz, n)) {
        auto i = index_generator(point_selector_randomiser);
        auto j = index_generator(point_selector_randomiser);

        if (i == j) continue;

        auto point_a = points[i], point_b = points[j];

        grid_width_squared = std::min(grid_width_squared, squared_euclidean_distance_between(point_a, point_b));
    }

    auto grid_width = ceiling_square_root(grid_width_squared);

    std::unordered_map<GridSquare, std::vector<Point>> points_by_square;
    points_by_square.reserve(n);

    for (auto point : points) {
        auto square_x = point.x / grid_width, square_y = point.y / grid_width;
        points_by_square[{ square_x, square_y }].push_back(point);
    }

    for (const auto &[square, inner_points] : points_by_square) {
        auto cnt = inner_points.size();

        for (auto i : std::views::iota(0uz, cnt)) {
            for (auto j : std::views::iota(i + 1, cnt)) {
                attempt_to_improve(closest_pair, inner_points[i], inner_points[j]);
            }
        }

        for (auto [offset_x, offset_y] : { std::pair{ 1, -1 }, { 1, 0 }, { 1, 1 }, { 0, 1 } }) {

            auto outer_square_x = square.x + offset_x, outer_square_y = square.y + offset_y;
            GridSquare outer_square{ outer_square_x, outer_square_y };

            auto iter = points_by_square.find(outer_square);
            if (iter == end(points_by_square)) continue;

            const auto &outer_points = iter->second;

            for (auto [point_a, point_b] : std::views::cartesian_product(inner_points, outer_points)) {
                attempt_to_improve(closest_pair, point_a, point_b);
            }
        }
    }

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

    std::vector point_counts{ 200'000, 400'000, 600'000, 800'000 };

    // for (auto n : point_counts) {
    //     auto stats                      = time_taken_by(examine_all_pairs, generator_for(n, Dimensions{ 2 }));
    //     auto [closest_pair, time_taken] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }

    // std::println();

    for (auto n : point_counts) {
        auto stats                      = time_taken_by(divide_and_conquer, generator_for(n, Dimensions{ 2 }));
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    std::println();

    for (auto n : point_counts) {
        auto stats                      = time_taken_by(sweepline, generator_for(n, Dimensions{ 2 }));
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    // std::println();

    // for (auto n : point_counts) {
    //     auto stats                      = time_taken_by(grid_decomposition, generator_for(n, Dimensions{ 2 }));
    //     auto [closest_pair, time_taken] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }

    return 0;
}
