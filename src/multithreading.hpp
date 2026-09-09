#pragma once

#include <cstddef>
#include <thread>

using ThreadCount = size_t;

inline ThreadCount THREAD_COUNT = std::thread::hardware_concurrency();
