#include <chrono>
#include <ranges>
#include <format>
#include <print>
#include <random>
#include <vector>
#include <string>

constexpr auto SEED = 42;
std::mt19937_64 randomiser(SEED);

struct Generator {
    int point_count = 0;
    int min_value = 0, max_value = 10;
};

struct Point {
    int x, y;
};

template <>
struct std::formatter<Point> : std::formatter<std::string> {
    auto format(const Point &p, auto &ctx) const { return std::format_to(ctx.out(), "({}, {})", p.x, p.y); }
};

struct ClosestPair {
    Point point_a, point_b;
    long long gap;
};

template <>
struct std::formatter<ClosestPair> : std::formatter<std::string> {
    auto format(const ClosestPair &pair, auto &ctx) const {
        auto [point_a, point_b, gap] = pair;
        return std::format_to(ctx.out(), "Closest Pair: {} <-> {} (gap: {})", point_a, point_b, gap);
    }
};

std::vector<Point> generate_points(Generator params) {
    std::vector<Point> points(params.point_count);
    std::uniform_int_distribution coord_generator(params.min_value, params.max_value);
    for (auto &[x, y] : points) {
        x = coord_generator(randomiser);
        y = coord_generator(randomiser);
    }
    return points;
}

long long squared_euclidean_distance_between(Point point_a, Point point_b) {
    long long x_gap = abs(point_a.x - point_b.x);
    long long y_gap = abs(point_a.y - point_b.y);
    return x_gap * x_gap + y_gap * y_gap;
}

ClosestPair closest_pair_from(std::vector<Point> points) {
    auto smallest_gap = std::numeric_limits<long long>::max();
    auto n            = points.size();

    ClosestPair closest_pair{};

    for (auto i : std::views::iota(0uz, n)) {
        for (auto j : std::views::iota(i + 1, n)) {
            auto point_a = points[i], point_b = points[j];
            if (auto gap = squared_euclidean_distance_between(point_a, point_b); gap < smallest_gap) {
                smallest_gap = gap;
                closest_pair = { point_a, point_b, gap };
            }
        }
    }

    return closest_pair;
}

std::chrono::duration<double> time_taken_by(auto solver, Generator params) {
    auto start_time = std::chrono::steady_clock::now();

    auto points = generate_points(params);
    auto _      = solver(points);

    auto end_time = std::chrono::steady_clock::now();

    return end_time - start_time;
}

int main() {
    auto time_taken = time_taken_by(closest_pair_from, Generator{ .point_count = 60'000 });

    std::println("Elapsed Time: {:.3}", time_taken);

    return 0;
}
