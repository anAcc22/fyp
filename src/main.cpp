#include <cstdio>
#include <cstdlib>
#include <locale>
#include <print>

#include "harness.hpp"
#include "harness_settings_reader.hpp"

int main() {
    std::locale::global(std::locale("en_US.UTF-8"));

    auto settings = read_harness_settings("config.toml");

    if (!settings) {
        for (const auto &error_message : settings.error()) std::println(stderr, "~> {}", error_message);
        return EXIT_FAILURE;
    }

    auto results = run_harness(*settings);

    if (!results) {
        for (const auto &error_message : results.error()) std::println(stderr, "~> {}", error_message);
        return EXIT_FAILURE;
    }

    print_summary(*settings, *results);
    save_results_to_disk(*settings, *results, "data/runtimes.csv");

    return EXIT_SUCCESS;
}
