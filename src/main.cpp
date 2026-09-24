#include <locale>
#include <print>
#include <vector>

#include "grid.hpp"
#include "benchmark.hpp"
#include "approximations.hpp"
#include "generator.hpp"
#include "brute_force.hpp"
#include "kd_tree.hpp"

// constexpr auto URNN       = GridWidthStrategy::UniformRandomNearestNeighbor;
constexpr auto DIMENSIONS = 16;

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector<size_t> point_counts{ 2'000, 4'000, 6'000, 8'000 };

    // std::println("|> Parallel Brute Force");
    //
    // for (auto n : point_counts) {
    //     auto stats = time_taken_by<Point<DIMENSIONS>>(examine_all_pairs_in_parallel, n, RelativeCheck::False);
    //     auto [closest_pair, time_taken, ratio] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    // std::println();
    //
    // std::println("|> Parallel Grid Decomposition (Uniform Random Nearest Neighbor)");
    //
    // for (auto n : point_counts) {
    //     auto stats = time_taken_by(parallel_grid_decomposition<DIMENSIONS, URNN>, n, RelativeCheck::False);
    //     auto [closest_pair, time_taken, ratio] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    // std::println();
    //
    // std::println("|> Parallel K-Dimensional Tree");
    //
    // for (auto n : point_counts) {
    //     auto stats = time_taken_by<Point<DIMENSIONS>>(parallel_kd_tree, n, RelativeCheck::False);
    //     auto [closest_pair, time_taken, ratio] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    // std::println();

    std::println("~> Examine Random Pairs");

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point<DIMENSIONS>>(examine_random_pairs, n, RelativeCheck::True);
        auto [closest_pair, time_taken, ratio] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Ratio: {:.3f}", n, time_taken.count(), ratio.value());
    }

    return 0;
}
