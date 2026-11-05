#!/usr/bin/env bash
# Redraws every figure in the paper. Run from anywhere: ./plots.sh
#
# Each figure has matching names: configs/<name>.toml -> data/<name>.csv -> paper/diagrams/<name>.pdf
#
# data/ is gitignored, so get a missing CSV back by running its config. main only reads config.toml from
# its working directory and writes data/runtimes.csv there, so use a scratch folder to leave the root
# config.toml alone:
#     mkdir -p /tmp/run/data && cp configs/<name>.toml /tmp/run/config.toml
#     (cd /tmp/run && "$OLDPWD/main") && cp /tmp/run/data/runtimes.csv data/<name>.csv
#
# Reruns give the same ratios and scores, as seeds are fixed. Runtimes will differ. The configs with very
# high dimensions take a while, because the score measures all pairs exactly.

set -euo pipefail
cd "$(dirname "$0")"

python=.venv/bin/python

# Chapter 2: Methodology

# Fig 2.1: how one benchmark runs, from config.toml to a figure. A diagram with no config or data, drawn by its own script.
$python plot_benchmark_pipeline.py --out paper/diagrams/methodology_benchmark_pipeline.pdf

# Chapter 3: Low Dimensions

# Fig 3.1: the exact algorithms at d = 2 as n grows from 10,000 to 100,000. Plain runtime on plain axes: grid decomposition
# has the best theory, yet curves away as the slowest. Parallel grid's timings drift between runs, so run all four together.
$python plot.py \
    --data data/low_dimensions_two_dimensional_runtime.csv \
    --x point_count --y runtime_seconds \
    --x-label 'Number of points ($n$)' --y-label 'Runtime (s)' --y-min 0 --y-step 0.02 \
    --linear-x --form lines --theme low_dimensions \
    --out paper/diagrams/low_dimensions_two_dimensional_runtime.pdf

# Fig 3.2: runtime against d at n = 10,000, on a log y-axis. The k-d tree climbs and levels off about 3 times above brute
# force, while grid decomposition blows straight past it. The harness runs every solver at every d, so this CSV joins three
# configs (low_dimensions_runtime_against_dimensions, plus its _grid and _parallel_grid versions), as grid stops early.
# The orange-yellow highlight traces the fastest algorithm at each d. The dotted lines are not data: they continue grid
# decomposition at 3 times per extra dimension, as each square has 3^d neighbours.
$python plot.py \
    --data data/low_dimensions_runtime_against_dimensions.csv \
    --x dimensions --y runtime_seconds \
    --x-label 'Dimensions ($d$)' --y-label 'Runtime (s)' \
    --linear-x --label-first-x --log-y --y-max 100 --trace-fastest \
    --project grid_decomposition parallel_grid_decomposition --projection-growth 3 \
    --form lines --theme low_dimensions \
    --out paper/diagrams/low_dimensions_runtime_against_dimensions.pdf

# Chapter 4: Heuristics

# Fig 4.1: random pairs at d = 6. Every trial's ratio as a dot, with the mean and its 95% confidence interval.
$python plot.py \
    --data data/heuristics_random_pairs.csv \
    --x attempts_per_point --y ratio \
    --x-label 'Budget ($a$)' --y-label 'Ratio' --y-min 1 \
    --form swarm --theme heuristics \
    --out paper/diagrams/heuristics_random_pairs.pdf

# Fig 4.2: random directions at d = 6. Mean ratio for each m and w. A cell marked 1 was exact in every trial,
# and the yellow outline surrounds budgets of at most 60, the most that Fig 4.1 goes up to.
$python plot.py \
    --data data/heuristics_random_directions.csv \
    --x neighbours_per_point --row direction_count --y ratio \
    --x-label 'Neighbours per point ($w$)' --y-label 'Directions ($m$)' \
    --mark-value 1 --outline-product 60 \
    --form heatmap --theme heuristics \
    --out paper/diagrams/heuristics_random_directions.pdf

# Fig 4.3: the Z-order curve on a 4 x 4 grid. A diagram with no config or data, drawn by its own script.
$python plot_z_order.py --out paper/diagrams/heuristics_z_order.pdf

# Fig 4.4: the Z-order curve at d = 6. The same layout as Fig 4.2, with s orders in place of m directions.
$python plot.py \
    --data data/heuristics_z_order_heatmap.csv \
    --x neighbours_per_point --row shift_count --y ratio \
    --x-label 'Neighbours per point ($w$)' --y-label 'Orders ($s$)' \
    --mark-value 1 --outline-product 60 \
    --form heatmap --theme heuristics \
    --out paper/diagrams/heuristics_z_order_heatmap.pdf

# Fig 4.5: best-first search at d = 6. Laid out like Fig 4.1, and a yellow ring marks a bound where every trial was exact.
$python plot.py \
    --data data/heuristics_best_first.csv \
    --x comparisons_per_point --y ratio \
    --x-label 'Bound ($b$)' --y-label 'Ratio' --y-min 1 --mark-value 1 \
    --form swarm --theme heuristics \
    --out paper/diagrams/heuristics_best_first.pdf

# Fig 4.6: random pairs as d grows, from d = 4 to 256. Each bar joins the mean ratios at a = 6 and a = 60, showing
# that high dimensions make the ratio look near perfect. d = 2 is left out, as its ratio of 34 flattens everything else.
$python plot.py \
    --data data/heuristics_high_dimensions.csv \
    --x dimensions --ends attempts_per_point --ends-label a --y ratio \
    --x-label 'Dimensions ($d$)' --y-label 'Ratio' --y-min 1 \
    --form dumbbell --theme heuristics \
    --out paper/diagrams/heuristics_high_dimensions.pdf

# Fig 4.7: the chapter's final figure. Mean normalised score of four heuristics at a budget of 128 as d grows, from
# d = 4 to 2048, with soft 95% confidence bands. They converge at the far right. Along each axis is deliberately left out.
$python plot.py \
    --data data/heuristics_comparison.csv \
    --x dimensions --y normalised_score \
    --x-label 'Dimensions ($d$)' --y-label 'Normalised score' --y-min 0.84 --y-step 0.04 \
    --form lines --theme heuristics \
    --out paper/diagrams/heuristics_comparison.pdf
