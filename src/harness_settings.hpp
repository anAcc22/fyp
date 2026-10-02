#pragma once

#include "approximations.hpp"
#include "benchmark.hpp"
#include "grid.hpp"

#include <cstddef>
#include <cstdint>
#include <format>
#include <string>
#include <type_traits>
#include <utility>
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

template <>
struct std::formatter<SolverName> : std::formatter<std::string> {
    auto format(SolverName name, auto &ctx) const {
        switch (name) {
            case SolverName::ExamineAllPairs:
                return std::format_to(ctx.out(), "examine_all_pairs");
            case SolverName::ExamineAllPairsInParallel:
                return std::format_to(ctx.out(), "examine_all_pairs_in_parallel");
            case SolverName::KdTree:
                return std::format_to(ctx.out(), "kd_tree");
            case SolverName::ParallelKdTree:
                return std::format_to(ctx.out(), "parallel_kd_tree");
            case SolverName::GridDecomposition:
                return std::format_to(ctx.out(), "grid_decomposition");
            case SolverName::ParallelGridDecomposition:
                return std::format_to(ctx.out(), "parallel_grid_decomposition");
            case SolverName::ExamineRandomPairs:
                return std::format_to(ctx.out(), "examine_random_pairs");
            case SolverName::Sweepline:
                return std::format_to(ctx.out(), "sweepline");
            case SolverName::DivideAndConquer:
                return std::format_to(ctx.out(), "divide_and_conquer");
        }
        std::unreachable();
    }
};

using SolverParams = std::variant<std::monostate, ExamineRandomPairsParams, GridDecompositionParams>;

template <>
struct std::formatter<SolverParams> : std::formatter<std::string> {
    auto format(const SolverParams &params, auto &ctx) const {
        return std::visit(
            [&](const auto &alternative) {
                if constexpr (std::is_same_v<std::remove_cvref_t<decltype(alternative)>, std::monostate>) {
                    return ctx.out();
                } else {
                    return std::format_to(ctx.out(), "{}", alternative);
                }
            },
            params);
    }
};

struct SolverSettings {
    SolverName name;
    SolverParams params = std::monostate{};
};

struct HarnessSettings {
    std::vector<Dimensions> dimensions;
    std::vector<size_t> point_counts;
    size_t trial_count           = 1;
    uint64_t base_seed           = DEFAULT_BASE_SEED;
    RelativeCheck relative_check = RelativeCheck::False;
    bool save_datasets           = false;
    std::vector<SolverSettings> solvers;
};
