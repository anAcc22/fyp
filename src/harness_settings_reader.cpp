#include "harness_settings_reader.hpp"

#include <toml.hpp>

#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <format>
#include <optional>
#include <ranges>
#include <span>
#include <string>
#include <string_view>
#include <type_traits>

using TomlKey = std::string_view;

template <typename T>
std::string_view description_of() {
    if constexpr (std::is_same_v<T, bool>) return "true or false";
    else if constexpr (std::is_same_v<T, std::string>) return "a string";
    else if constexpr (std::is_floating_point_v<T>) return "a number";
    else return "a non-negative integer";
}

template <typename T>
std::optional<T> scalar_from(const toml::node &node) {
    if constexpr (std::is_same_v<T, bool>) {
        if (!node.is_boolean()) return std::nullopt;
    }
    return node.value<T>();
}

template <typename T>
std::optional<T> single_value_at(
    const toml::table &table, TomlKey key, std::string_view location, std::vector<ErrorMessage> &error_messages) {
    const auto *node = table.get(key);
    if (!node) return std::nullopt;

    auto value = scalar_from<T>(*node);
    if (!value) error_messages.push_back(std::format("{}: {} should be {}", location, key, description_of<T>()));

    return value;
}

template <typename T>
std::optional<std::vector<T>> one_or_more_values_at(
    const toml::table &table, TomlKey key, std::string_view location, std::vector<ErrorMessage> &error_messages) {
    const auto *node = table.get(key);
    if (!node) return std::nullopt;

    std::vector<const toml::node *> nodes;

    if (const auto *array = node->as_array()) {
        for (const auto &element : *array) nodes.push_back(&element);
    } else {
        nodes.push_back(node);
    }

    if (nodes.empty()) error_messages.push_back(std::format("{}: {} should not be empty", location, key));

    std::vector<T> values;

    for (const auto *element : nodes) {
        if (auto value = scalar_from<T>(*element)) {
            values.push_back(*value);
        } else {
            error_messages.push_back(
                std::format("{}: every value in {} should be {}", location, key, description_of<T>()));
            break;
        }
    }

    return values;
}

void check_known_keys(
    const toml::table &table, std::span<const TomlKey> known_keys, std::string_view location,
    std::vector<ErrorMessage> &error_messages) {
    for (const auto &[key, node] : table) {
        if (!std::ranges::contains(known_keys, key.str())) {
            error_messages.push_back(std::format("{}: unknown key {}", location, key.str()));
        }
    }
}

template <typename Enum>
std::optional<Enum> enum_from_text(std::string_view text, std::span<const Enum> all_values) {
    auto match = std::ranges::find_if(all_values, [&](Enum value) { return std::format("{}", value) == text; });
    if (match == end(all_values)) return std::nullopt;
    return *match;
}

template <typename Enum>
std::string text_list_of(std::span<const Enum> all_values) {
    return all_values | std::views::transform([](Enum value) { return std::format("{}", value); })
           | std::views::join_with(std::string_view{ ", " }) | std::ranges::to<std::string>();
}

std::vector<GridWidthStrategy> grid_width_strategies_at(
    const toml::table &table, std::string_view location, std::vector<ErrorMessage> &error_messages) {
    auto texts = one_or_more_values_at<std::string>(table, "width_strategy", location, error_messages);
    if (!texts) return { GridDecompositionParams{}.width_strategy };

    std::vector<GridWidthStrategy> strategies;

    for (const auto &text : *texts) {
        if (auto strategy = enum_from_text<GridWidthStrategy>(text, ALL_GRID_WIDTH_STRATEGIES)) {
            strategies.push_back(*strategy);
        } else {
            error_messages.push_back(
                std::format(
                    "{}: unknown width_strategy {}, expected one of: {}",
                    location,
                    text,
                    text_list_of<GridWidthStrategy>(ALL_GRID_WIDTH_STRATEGIES)));
        }
    }

    return strategies;
}

void read_solver(
    const toml::table &solver_table, size_t solver_number, std::vector<SolverSettings> &solvers,
    std::vector<ErrorMessage> &error_messages) {
    auto location  = std::format("solver {}", solver_number);
    auto name_text = single_value_at<std::string>(solver_table, "name", location, error_messages);

    if (!name_text) {
        if (!solver_table.contains("name")) error_messages.push_back(std::format("{}: missing name", location));
        return;
    }

    auto name = enum_from_text<SolverName>(*name_text, ALL_SOLVER_NAMES);

    if (!name) {
        error_messages.push_back(
            std::format(
                "{}: unknown solver {}, expected one of: {}",
                location,
                *name_text,
                text_list_of<SolverName>(ALL_SOLVER_NAMES)));
        return;
    }

    location = std::format("solver {} ({})", solver_number, *name_text);

    switch (*name) {
        case SolverName::ExamineRandomPairs: {
            constexpr std::array<TomlKey, 2> known_keys{ "name", "attempts_per_point" };
            check_known_keys(solver_table, known_keys, location, error_messages);

            auto attempts_per_point_values
                = one_or_more_values_at<size_t>(solver_table, "attempts_per_point", location, error_messages)
                      .value_or(std::vector{ ExamineRandomPairsParams{}.attempts_per_point });

            for (auto attempts_per_point : attempts_per_point_values) {
                solvers.push_back(
                    {
                        .name   = *name,
                        .params = ExamineRandomPairsParams{ .attempts_per_point = attempts_per_point },
                    });
            }
            return;
        }
        case SolverName::ExamineNeighboursAlongEachAxis: {
            constexpr std::array<TomlKey, 2> known_keys{ "name", "window_size" };
            check_known_keys(solver_table, known_keys, location, error_messages);

            auto window_sizes = one_or_more_values_at<size_t>(solver_table, "window_size", location, error_messages)
                                    .value_or(std::vector{ ExamineNeighboursAlongEachAxisParams{}.window_size });

            for (auto window_size : window_sizes) {
                solvers.push_back(
                    {
                        .name   = *name,
                        .params = ExamineNeighboursAlongEachAxisParams{ .window_size = window_size },
                    });
            }
            return;
        }
        case SolverName::ExamineNeighboursAlongRandomDirections: {
            constexpr std::array<TomlKey, 3> known_keys{ "name", "direction_count", "window_size" };
            check_known_keys(solver_table, known_keys, location, error_messages);

            ExamineNeighboursAlongRandomDirectionsParams defaults;

            auto direction_counts
                = one_or_more_values_at<size_t>(solver_table, "direction_count", location, error_messages)
                      .value_or(std::vector{ defaults.direction_count });
            auto window_sizes = one_or_more_values_at<size_t>(solver_table, "window_size", location, error_messages)
                                    .value_or(std::vector{ defaults.window_size });

            for (auto [direction_count, window_size] : std::views::cartesian_product(direction_counts, window_sizes)) {
                solvers.push_back(
                    {
                        .name   = *name,
                        .params = ExamineNeighboursAlongRandomDirectionsParams{
                            .direction_count = direction_count,
                            .window_size     = window_size,
                        },
                    });
            }
            return;
        }
        case SolverName::GridDecomposition:
        case SolverName::ParallelGridDecomposition: {
            constexpr std::array<TomlKey, 3> known_keys{ "name", "width_strategy", "width_multiplier" };
            check_known_keys(solver_table, known_keys, location, error_messages);

            auto width_strategies = grid_width_strategies_at(solver_table, location, error_messages);
            auto width_multipliers
                = one_or_more_values_at<double>(solver_table, "width_multiplier", location, error_messages)
                      .value_or(std::vector{ GridDecompositionParams{}.width_multiplier });

            for (auto [width_strategy, width_multiplier] :
                 std::views::cartesian_product(width_strategies, width_multipliers)) {
                solvers.push_back({
                .name   = *name,
                .params = GridDecompositionParams{
                    .width_strategy   = width_strategy,
                    .width_multiplier = width_multiplier,
                },
            });
            }
            return;
        }
        default: {
            constexpr std::array<TomlKey, 1> known_keys{ "name" };
            check_known_keys(solver_table, known_keys, location, error_messages);

            solvers.push_back({ .name = *name });
            return;
        }
    }
}

std::expected<HarnessSettings, std::vector<ErrorMessage>> read_harness_settings(const std::filesystem::path &path) {
    if (!std::filesystem::exists(path)) {
        return std::unexpected(
            std::vector{ std::format(
                "{} not found, copy one of the experiments in configs/ to {}", path.string(), path.string()) });
    }

    toml::table table;

    try {
        table = toml::parse_file(path.string());
    } catch (const toml::parse_error &error) {
        return std::unexpected(
            std::vector{ std::format(
                "{}:{}:{}: {}",
                path.string(),
                error.source().begin.line,
                error.source().begin.column,
                error.description()) });
    }

    constexpr std::string_view location = "settings";
    std::vector<ErrorMessage> error_messages;
    HarnessSettings settings;

    constexpr std::array<TomlKey, 7> known_keys{
        "dimensions", "point_counts", "trial_count", "base_seed", "relative_check", "save_datasets", "solvers",
    };
    check_known_keys(table, known_keys, location, error_messages);

    if (auto dimensions = one_or_more_values_at<Dimensions>(table, "dimensions", location, error_messages)) {
        settings.dimensions = *dimensions;
    } else {
        error_messages.push_back(std::format("{}: missing dimensions", location));
    }

    if (auto point_counts = one_or_more_values_at<size_t>(table, "point_counts", location, error_messages)) {
        settings.point_counts = *point_counts;
    } else {
        error_messages.push_back(std::format("{}: missing point_counts", location));
    }

    if (auto trial_count = single_value_at<size_t>(table, "trial_count", location, error_messages)) {
        settings.trial_count = *trial_count;
    }

    if (auto base_seed = single_value_at<uint64_t>(table, "base_seed", location, error_messages)) {
        settings.base_seed = *base_seed;
    }

    if (auto relative_check = single_value_at<bool>(table, "relative_check", location, error_messages)) {
        settings.relative_check = *relative_check ? RelativeCheck::True : RelativeCheck::False;
    }

    if (auto save_datasets = single_value_at<bool>(table, "save_datasets", location, error_messages)) {
        settings.save_datasets = *save_datasets;
    }

    if (const auto *solver_tables = table["solvers"].as_array()) {
        for (auto [solver_index, solver_node] : std::views::enumerate(*solver_tables)) {
            auto solver_number = static_cast<size_t>(solver_index) + 1;

            if (const auto *solver_table = solver_node.as_table()) {
                read_solver(*solver_table, solver_number, settings.solvers, error_messages);
            } else {
                error_messages.push_back(
                    std::format("{}: solver {} should be a [[solvers]] table", location, solver_number));
            }
        }
    } else {
        error_messages.push_back(std::format("{}: missing [[solvers]]", location));
    }

    if (!error_messages.empty()) return std::unexpected(error_messages);

    return settings;
}
