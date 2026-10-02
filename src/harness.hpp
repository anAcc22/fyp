#pragma once

#include "generator.hpp"
#include "harness_settings.hpp"

#include <array>
#include <cstddef>
#include <expected>
#include <filesystem>
#include <optional>
#include <string>
#include <vector>

inline constexpr auto SUPPORTED_DIMENSIONS = std::to_array<Dimensions>({ 2, 3, 4, 6, 8, 10, 12, 16, 24, 32 });

inline constexpr Dimensions MAX_GRID_DIMENSIONS = 12;

using ErrorMessage = std::string;

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
