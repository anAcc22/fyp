#pragma once

#include <vector>

#include "geometry.hpp"

ClosestPair examine_all_pairs(std::vector<Point2D> points);

ClosestPair divide_and_conquer(std::vector<Point2D> points);

ClosestPair sweepline(std::vector<Point2D> points);

ClosestPair grid_decomposition(std::vector<Point2D> points);

ClosestPair parallel_grid_decomposition(std::vector<Point2D> points);
