#pragma once

#include "generator.hpp"
#include "harness_settings.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <expected>
#include <filesystem>
#include <numeric>
#include <optional>
#include <string>
#include <vector>

inline constexpr Dimensions MAX_CONSECUTIVE_DIMENSIONS = 32;

inline constexpr auto LARGE_DIMENSIONS = std::to_array<Dimensions>({ 64, 128, 256 });

inline constexpr auto SUPPORTED_DIMENSIONS = [] {
    std::array<Dimensions, MAX_CONSECUTIVE_DIMENSIONS + LARGE_DIMENSIONS.size()> dimensions{};
    std::iota(begin(dimensions), begin(dimensions) + MAX_CONSECUTIVE_DIMENSIONS, Dimensions{ 1 });
    std::ranges::copy(LARGE_DIMENSIONS, begin(dimensions) + MAX_CONSECUTIVE_DIMENSIONS);
    return dimensions;
}();

inline constexpr Dimensions MAX_GRID_DIMENSIONS = 12;

struct TrialResult {
    size_t solver_index;
    Trial trial;
    Seconds runtime;
    std::optional<double> ratio            = std::nullopt;
    std::optional<double> normalised_score = std::nullopt;
};

std::expected<std::vector<TrialResult>, std::vector<ErrorMessage>> run_harness(const HarnessSettings &settings);

void print_summary(const HarnessSettings &settings, const std::vector<TrialResult> &results);

void save_results_to_disk(
    const HarnessSettings &settings, const std::vector<TrialResult> &results, const std::filesystem::path &path);
