#pragma once

#include <cmath>
#include <ranges>
#include <numeric>

template <typename T>
T ceiling_square_root(T x) {
    T low = 0, high = sqrt(x), ans = -1;
    while (low <= high) {
        auto mid = std::midpoint(low, high);
        if (mid * mid < x) ans = mid, low = mid + 1;
        else high = mid - 1;
    }
    return ans + 1;
}

template <typename T, typename U>
T fast_exponentiation(T base, U power) {
    T answer{ 1 };
    while (power) {
        if (power & 1) answer *= base;
        base *= base;
        power >>= 1;
    }
    return answer;
}

template <size_t dimensions, typename T>
std::array<int16_t, dimensions> offset_from(T raw_offset) {
    std::array<int16_t, dimensions> offset;
    static constexpr auto BASE = 3;
    for (auto i : std::views::iota(0uz, dimensions)) {
        int16_t state = raw_offset % BASE;
        offset[i]     = state - 1;
        raw_offset /= BASE;
    }
    return offset;
}
