#pragma once

#include <cmath>
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
