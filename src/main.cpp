#include <locale>
#include <print>
#include <vector>

#include "grid.hpp"
#include "benchmark.hpp"
#include "generator.hpp"
#include "brute_force.hpp"
#include "kd_tree.hpp"

constexpr auto URNN = GridWidthStrategy::UniformRandomNearestNeighbor;

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector point_counts{ 10'000, 20'000, 30'000, 40'000 };

    std::println("|> Brute Force");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<6>>(examine_all_pairs_in_parallel, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Grid Decomposition");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<6>>(grid_decomposition, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Parallel Grid Decomposition");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<6>>(parallel_grid_decomposition, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Grid Decomposition (Uniform Random Nearest Neighbor)");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by(grid_decomposition<6, URNN>, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Parallel Grid Decomposition (Uniform Random Nearest Neighbor)");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by(parallel_grid_decomposition<6, URNN>, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> K-Dimensional tree");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<6>>(kd_tree, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }
    std::println();

    std::println("|> Parallel K-Dimensional tree");

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<6>>(parallel_kd_tree, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    return 0;
}
