#pragma once

#include <compare>
#include <cstddef>
#include <cstdint>
#include <functional>

using ThreadCount = int;

struct GridSquare {
    int64_t x, y;
    friend auto operator<=>(GridSquare, GridSquare) = default;
};

template <>
struct std::hash<GridSquare> {
    size_t operator()(GridSquare square) const noexcept {
        auto mix = [](uint64_t x) {
            x += 0x9e3779b97f4a7c15;
            x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
            x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
            return x ^ (x >> 31);
        };
        return mix(square.x) ^ (mix(square.y) << 1);
    }
};
