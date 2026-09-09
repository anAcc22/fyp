#pragma once

#include <vector>

#include "geometry.hpp"

ClosestPair<Point2D> examine_all_pairs(std::vector<Point2D> points);

ClosestPair<Point2D> divide_and_conquer(std::vector<Point2D> points);

ClosestPair<Point2D> sweepline(std::vector<Point2D> points);

ClosestPair<Point2D> grid_decomposition(std::vector<Point2D> points);

ClosestPair<Point2D> parallel_grid_decomposition(std::vector<Point2D> points);
