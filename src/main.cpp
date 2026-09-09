#include <locale>
#include <print>
#include <vector>

#include "benchmark.hpp"
#include "generator.hpp"
#include "solvers.hpp"

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    std::vector point_counts{ 200'000, 400'000, 600'000, 800'000 };

    // for (auto n : point_counts) {
    //     auto stats                      = time_taken_by(examine_all_pairs, generator_for(n, Dimensions{ 2 }));
    //     auto [closest_pair, time_taken] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    //
    // std::println();
    //
    // for (auto n : point_counts) {
    //     auto stats                      = time_taken_by(divide_and_conquer, generator_for(n, Dimensions{ 2 }));
    //     auto [closest_pair, time_taken] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    //
    // std::println();
    //
    // for (auto n : point_counts) {
    //     auto stats                      = time_taken_by(sweepline, generator_for(n, Dimensions{ 2 }));
    //     auto [closest_pair, time_taken] = stats;
    //     std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    // }
    //
    // std::println();

    for (auto n : point_counts) {
        auto stats                      = time_taken_by<Point2D>(grid_decomposition, generator_for(n, Dimensions{ 2 }));
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    std::println();

    for (auto n : point_counts) {
        auto stats = time_taken_by<Point2D>(parallel_grid_decomposition, generator_for(n, Dimensions{ 2 }));
        auto [closest_pair, time_taken] = stats;
        std::println("Point Count: {:L}, Elapsed Time: {:.3f}s, Closest Pair: {}", n, time_taken.count(), closest_pair);
    }

    return 0;
}
