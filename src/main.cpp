#include <cstdio>
#include <cstdlib>
#include <locale>
#include <print>

#include "harness.hpp"

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    HarnessSettings settings{
        .dimensions     = { 6 },
        .point_counts   = { 2'000, 4'000, 6'000, 8'000 },
        .trial_count    = 5,
        .relative_check = RelativeCheck::True,
        .solvers        = {
            { .name = SolverName::ExamineAllPairsInParallel },
            {
                .name   = SolverName::ParallelGridDecomposition,
                .params = GridDecompositionParams{
                    .width_strategy   = GridWidthStrategy::UniformRandomNearestNeighbor,
                    .width_multiplier = 2.0,
                },
            },
            { .name = SolverName::ParallelKdTree },
            { .name = SolverName::ExamineRandomPairs, .params = ExamineRandomPairsParams{ .attempts_per_point = 1 } },
        },
    };

    auto results = run_harness(settings);

    if (!results) {
        for (const auto &error_message : results.error()) std::println(stderr, "~> {}", error_message);
        return EXIT_FAILURE;
    }

    print_summary(settings, *results);
    save_results_to_disk(settings, *results, "data/runtimes.csv");

    return EXIT_SUCCESS;
}
