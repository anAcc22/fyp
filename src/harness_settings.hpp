#pragma once

#include "approximations.hpp"
#include "benchmark.hpp"
#include "grid.hpp"

#include <cstddef>
#include <cstdint>
#include <variant>
#include <vector>

enum class SolverName {
    ExamineAllPairs,
    ExamineAllPairsInParallel,
    KdTree,
    ParallelKdTree,
    GridDecomposition,
    ParallelGridDecomposition,
    ExamineRandomPairs,
    Sweepline,
    DivideAndConquer,
};

using SolverParams = std::variant<std::monostate, ExamineRandomPairsParams, GridDecompositionParams>;

struct SolverSettings {
    SolverName name;
    SolverParams params;
};

struct HarnessSettings {
    std::vector<size_t> dimensions;
    std::vector<size_t> point_counts;
    size_t trial_count           = 1;
    uint64_t base_seed           = DEFAULT_BASE_SEED;
    RelativeCheck relative_check = RelativeCheck::False;
    bool save_datasets           = false;
    std::vector<SolverSettings> solvers;
};
