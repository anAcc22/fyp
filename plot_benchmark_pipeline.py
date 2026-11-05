"""Draws how one benchmark runs, from config.toml to a figure, using the same style as every other figure.

Example:
    .venv/bin/python plot_benchmark_pipeline.py --out paper/diagrams/methodology_benchmark_pipeline.pdf
"""

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch
from matplotlib.path import Path as DrawnPath

from plot import INK_COLOUR, THEMES, use_paper_style

FIGURE_SIZE_IN_INCHES = (7.3, 7.1)
TEXT_FONT_SIZE = 8
ROUNDING = 1
LOOP_CORNER = 3

STEP, SEED, OPTIONAL, FILE = "step", "seed", "optional", "file"

# The same typewriter design as the paper's code command, but heavier, as the regular weight looks thin beside Literata.
CODE_FONT = "Latin Modern Mono Light:bold"


def code(text):
    """Sets text in the code font. Maths mode adds its own space after a comma, and also after a full stop, which gets cancelled out."""
    escaped = text.replace("_", "\\_").replace(", ", ",").replace(" ", "\\ ").replace(".", ".\\!")
    return f"$\\mathtt{{{escaped}}}$"


# The boxes sit on three columns, which keeps the many arrows easy to follow.
LEFT, MIDDLE, RIGHT = 24, 64, 103
MIX_TEXT = "mix(base_seed, d, n, t, {})"

# Each box: name -> (centre x, centre y, width, height, text, kind).
BOXES = {
    "config": (LEFT, 116, 20, 6, code("config.toml"), FILE),
    "check": (MIDDLE, 116, 26, 6, "Check settings", STEP),
    "base_seed": (MIDDLE, 104, 26, 6, code("base_seed = 42"), SEED),
    "trial": (RIGHT, 104, 26, 6, "$d$, $n$, trial $t$", STEP),
    "dataset_seed": (RIGHT, 84, 47, 9, "Dataset seed:\n" + code(MIX_TEXT.format("dataset")), SEED),
    "dataset_randomiser": (MIDDLE, 84, 20, 6, code("mt19937_64"), STEP),
    "points": (LEFT, 84, 28, 9, "$n$ random points,\noverflow-safe", STEP),
    "save": (LEFT, 71, 26, 9, code("save_datasets") + ":\nsave points", OPTIONAL),
    "reference": (MIDDLE, 71, 32, 9, code("relative_check") + ":\n$\\delta$ and mean distance", OPTIONAL),
    "solver": (LEFT, 50, 16, 6, "Solver", STEP),
    "solver_seed": (LEFT, 40, 46, 9, "Solver seed:\n" + code(MIX_TEXT.format("solver")), SEED),
    "copy": (MIDDLE, 40, 22, 6, "Copy points", STEP),
    "solver_randomiser": (LEFT, 25, 32, 9, "Seed " + code("mt19937_64") + "\n" + code("(solver_randomiser)"), STEP),
    "start": (MIDDLE, 25, 18, 6, "Start clock", STEP),
    "run": (88, 25, 18, 6, "Run solver", STEP),
    "stop": (112, 25, 18, 6, "Stop clock", STEP),
    "score": (112, 11, 26, 9, code("relative_check") + ":\nratio, score", OPTIONAL),
    "row": (LEFT, 11, 20, 6, "Keep result", STEP),
    "csv": (LEFT, -9, 28, 6, code("data/runtimes.csv"), FILE),
    "plot": (MIDDLE, -9, 14, 6, code("plot.py"), STEP),
    "figure": (RIGHT, -9, 14, 6, "Figure", FILE),
}

# Each arrow: (from, to, how much it curves).
ARROWS = [
    ("config", "check", 0),
    ("check", "trial", 0),
    ("base_seed", "trial", 0),
    ("trial", "dataset_seed", 0),
    ("dataset_seed", "dataset_randomiser", 0),
    ("dataset_randomiser", "points", 0),
    ("points", "save", 0),
    ("save", "reference", 0),
    ("reference", "solver", 0),
    ("solver", "solver_seed", 0),
    ("solver_seed", "solver_randomiser", 0),
    ("solver_seed", "copy", 0),
    ("copy", "start", 0),
    ("solver_randomiser", "start", 0),
    ("start", "run", 0),
    ("run", "stop", 0),
    ("stop", "score", 0),
    ("score", "row", 0),
    ("row", "csv", 0),
    ("csv", "plot", 0),
    ("plot", "figure", 0),
]

# The stages, each drawn around its boxes: (left, bottom, width, height, label, label x, edge colour key, fill colour key).
STAGES = [
    (-8, 60, 138, 37, "Data generation", -5, "data_edge_colour", "data_fill_colour"),
    (-8, 2, 138, 54, "Solvers", -5, "solver_edge_colour", "solver_fill_colour"),
    (51, 19, 74, 15, "", 0, "timed_edge_colour", "timed_fill_colour"),
]

# Dashed routes around the outside, each through its corners: (corners, label, label x, label y, label rotation).
LOOPS = [
    (((14, 11), (-3, 11), (-3, 50), (16, 50)), "next solver", -5.5, 30, 90),
    (((30, 8), (30, -2), (133, -2), (133, 104), (116, 104)), "next trial, $n$ or $d$", 136, 53, 90),
]


def draw_stages(ax, theme):
    for left, bottom, width, height, label, label_x, edge_colour_key, fill_colour_key in STAGES:
        ax.add_patch(
            FancyBboxPatch(
                (left, bottom),
                width,
                height,
                boxstyle=f"round,pad=0,rounding_size={ROUNDING * 2}",
                facecolor=theme[fill_colour_key],
                edgecolor=theme[edge_colour_key],
                linewidth=1.2,
                zorder=0,
            )
        )
        ax.text(label_x, bottom + height - 3.5, label, ha="left", va="center", fontsize=TEXT_FONT_SIZE, color=theme[edge_colour_key])


def draw_boxes(ax, theme):
    patches = {}
    fills = {STEP: "white", SEED: theme["label_colour"], OPTIONAL: "white", FILE: theme["value_band_colour"]}

    for name, (x, y, width, height, text, kind) in BOXES.items():
        patch = FancyBboxPatch(
            (x - width / 2, y - height / 2),
            width,
            height,
            boxstyle=f"round,pad=0,rounding_size={ROUNDING}",
            facecolor=fills[kind],
            edgecolor=theme["key_colour"],
            linewidth=1,
            linestyle="--" if kind == OPTIONAL else "-",
            zorder=2,
        )
        ax.add_patch(patch)
        ax.text(x, y, text, ha="center", va="center", fontsize=TEXT_FONT_SIZE, color=INK_COLOUR, zorder=3)
        patches[name] = patch

    return patches


def draw_arrow(ax, patches, start, end, curve, colour):
    ax.annotate(
        "",
        xy=BOXES[end][:2],
        xytext=BOXES[start][:2],
        arrowprops={
            "arrowstyle": "-|>",
            "color": colour,
            "linewidth": 1,
            "connectionstyle": f"arc3,rad={curve}",
            "patchA": patches[start],
            "patchB": patches[end],
            "shrinkA": 1,
            "shrinkB": 1,
        },
        zorder=1,
    )


def draw_loop(ax, corners, colour):
    """Straight runs joined by rounded corners, so that the route stays clear of every box."""
    vertices = [corners[0]]
    codes = [DrawnPath.MOVETO]

    for before, corner, after in zip(corners, corners[1:], corners[2:]):
        for neighbour, code in ((before, DrawnPath.LINETO), (after, DrawnPath.CURVE3)):
            sign_x = (neighbour[0] > corner[0]) - (neighbour[0] < corner[0])
            sign_y = (neighbour[1] > corner[1]) - (neighbour[1] < corner[1])
            point = (corner[0] + sign_x * LOOP_CORNER, corner[1] + sign_y * LOOP_CORNER)

            if code == DrawnPath.LINETO:
                vertices += [point, corner]
                codes += [DrawnPath.LINETO, DrawnPath.CURVE3]
            else:
                vertices.append(point)
                codes.append(DrawnPath.CURVE3)

    vertices.append(corners[-1])
    codes.append(DrawnPath.LINETO)

    ax.add_patch(
        FancyArrowPatch(
            path=DrawnPath(vertices, codes),
            arrowstyle="-|>",
            mutation_scale=9,
            color=colour,
            linewidth=1,
            linestyle="--",
            zorder=1,
        )
    )


def main():
    parser = argparse.ArgumentParser(description="Draw the benchmark pipeline.")
    parser.add_argument("--out", type=Path, required=True, help="output file, e.g. paper/diagrams/name.pdf")
    out = parser.parse_args().out

    use_paper_style()
    plt.rcParams["mathtext.tt"] = CODE_FONT
    theme = THEMES["methodology"]

    fig, ax = plt.subplots(figsize=FIGURE_SIZE_IN_INCHES)
    draw_stages(ax, theme)
    patches = draw_boxes(ax, theme)

    for start, end, curve in ARROWS:
        draw_arrow(ax, patches, start, end, curve, INK_COLOUR)

    for corners, label, label_x, label_y, label_rotation in LOOPS:
        draw_loop(ax, corners, theme["key_colour"])
        ax.text(
            label_x,
            label_y,
            label,
            ha="center",
            va="center",
            rotation=label_rotation,
            fontsize=TEXT_FONT_SIZE,
            color=INK_COLOUR,
        )

    ax.set_xlim(-10, 139)
    ax.set_ylim(-13, 120)
    ax.axis("off")

    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out, bbox_inches="tight")


if __name__ == "__main__":
    main()
