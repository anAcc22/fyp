#include <locale>
#include <print>
#include <vector>

#include "grid.hpp"
#include "benchmark.hpp"
#include "approximations.hpp"
#include "generator.hpp"
#include "brute_force.hpp"
#include "kd_tree.hpp"

constexpr auto DIMENSIONS = 12;

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector<size_t> point_counts{ 2'000, 4'000, 6'000, 8'000 };

    GridDecompositionParams grid_params{
        .width_strategy   = GridWidthStrategy::UniformRandomNearestNeighbor,
        .width_multiplier = 2.0,
    };

    ExamineRandomPairsParams random_pairs_params{ .attempts_per_point = 1 };

    auto parallel_grid_with_params = [grid_params](std::vector<Point<DIMENSIONS>> points) {
        return parallel_grid_decomposition(points, grid_params);
    };

    auto random_pairs_with_params = [random_pairs_params](std::vector<Point<DIMENSIONS>> points) {
        return examine_random_pairs(points, random_pairs_params);
    };

    std::println("|> Parallel Brute Force");

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point<DIMENSIONS>>(
            examine_all_pairs_in_parallel<Point<DIMENSIONS>>, n, RelativeCheck::False);
        auto [closest_pair, time_taken, ratio] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Parallel Grid Decomposition (Uniform Random Nearest Neighbor)");

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point<DIMENSIONS>>(parallel_grid_with_params, n, RelativeCheck::False);
        auto [closest_pair, time_taken, ratio] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Parallel K-Dimensional Tree");

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point<DIMENSIONS>>(parallel_kd_tree<DIMENSIONS>, n, RelativeCheck::False);
        auto [closest_pair, time_taken, ratio] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("~> Examine Random Pairs");

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point<DIMENSIONS>>(random_pairs_with_params, n, RelativeCheck::True);
        auto [closest_pair, time_taken, ratio] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Ratio: {:.3f}", n, time_taken.count(), ratio.value());
    }

    return 0;
}
