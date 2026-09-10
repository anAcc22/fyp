#include <locale>
#include <print>
#include <vector>

#include "grid.hpp"
#include "benchmark.hpp"
#include "generator.hpp"
#include "brute_force.hpp"

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector point_counts{ 10'000, 20'000, 30'000, 40'000 };

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<3>>(examine_all_pairs_in_parallel, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    std::println();

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<3>>(grid_decomposition, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    std::println();

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point<3>>(parallel_grid_decomposition, n);
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    return 0;
}
