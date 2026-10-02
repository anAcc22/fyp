#pragma once

#include "harness_settings.hpp"

#include <expected>
#include <filesystem>
#include <vector>

std::expected<HarnessSettings, std::vector<ErrorMessage>> read_harness_settings(const std::filesystem::path &path);
