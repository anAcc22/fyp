#pragma once

#include "generator.hpp"
#include "harness_settings.hpp"

#include <array>
#include <cstddef>
#include <expected>
#include <filesystem>
#include <numeric>
#include <optional>
#include <string>
#include <vector>

inline constexpr Dimensions MAX_SUPPORTED_DIMENSIONS = 128;

inline constexpr auto SUPPORTED_DIMENSIONS = [] {
    std::array<Dimensions, MAX_SUPPORTED_DIMENSIONS> dimensions{};
    std::iota(begin(dimensions), end(dimensions), Dimensions{ 1 });
    return dimensions;
}();

inline constexpr Dimensions MAX_GRID_DIMENSIONS = 12;

struct TrialResult {
    size_t solver_index;
    Trial trial;
    Seconds runtime;
    std::optional<double> ratio = std::nullopt;
};

std::expected<std::vector<TrialResult>, std::vector<ErrorMessage>> run_harness(const HarnessSettings &settings);

void print_summary(const HarnessSettings &settings, const std::vector<TrialResult> &results);

void save_results_to_disk(
    const HarnessSettings &settings, const std::vector<TrialResult> &results, const std::filesystem::path &path);
