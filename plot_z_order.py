"""Draws the Z-order curve on a small lattice, using the same style as every other figure.

Example:
    .venv/bin/python plot_z_order.py --out paper/diagrams/heuristics_z_order.pdf
"""

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import seaborn as sns

from plot import INK_COLOUR, THEMES, use_paper_style

BITS_PER_AXIS = 2
SIDE = 2**BITS_PER_AXIS

FIGURE_SIZE_IN_INCHES = (2.6, 2.6)
GRID_COLOUR = "#DDE1D2"
NODE_COLOUR = "#F3F5EA"
NODE_SIZE = 260
NODE_FONT_SIZE = 9
# Close on the grid, far apart on the curve.
HIGHLIGHTED_CELLS = ((0, 1), (0, 2))
HIGHLIGHT_BAND_SIZE = 480


def position_on_curve(x, y):
    """Interleaves the bits with y's on top, so that the path traces a Z when y runs downwards."""
    position = 0

    for bit in range(BITS_PER_AXIS):
        position |= ((x >> bit) & 1) << (2 * bit)
        position |= ((y >> bit) & 1) << (2 * bit + 1)

    return position


def main():
    parser = argparse.ArgumentParser(description="Draw the Z-order curve.")
    parser.add_argument("--out", type=Path, required=True, help="output file, e.g. paper/diagrams/name.pdf")
    out = parser.parse_args().out

    use_paper_style()
    key_colour = THEMES["heuristics"]["key_colour"]
    band_colour = THEMES["heuristics"]["label_colour"]

    fig, ax = plt.subplots(figsize=FIGURE_SIZE_IN_INCHES)

    cells_in_order = sorted(
        ((x, y) for x in range(SIDE) for y in range(SIDE)), key=lambda cell: position_on_curve(*cell)
    )
    xs, ys = zip(*cells_in_order)

    ax.plot(xs, ys, color=key_colour, linewidth=1.5, solid_joinstyle="round", zorder=1)
    ax.scatter(*zip(*HIGHLIGHTED_CELLS), s=HIGHLIGHT_BAND_SIZE, color=band_colour, linewidth=0, zorder=2)
    ax.scatter(xs, ys, s=NODE_SIZE, color=NODE_COLOUR, edgecolor=key_colour, linewidth=1.2, zorder=3)

    for position, (x, y) in enumerate(cells_in_order):
        ax.text(x, y, str(position), ha="center", va="center", fontsize=NODE_FONT_SIZE, color=INK_COLOUR, zorder=4)

    ax.set_xlim(-0.5, SIDE - 0.5)
    ax.set_ylim(SIDE - 0.5, -0.5)
    ax.set_aspect("equal")

    ax.set_xticks(range(SIDE))
    ax.set_yticks(range(SIDE))
    ax.set_xlabel("$x$")
    ax.set_ylabel("$y$", rotation=0, labelpad=10)

    ax.grid(color=GRID_COLOUR, linewidth=0.9, zorder=0)
    ax.set_axisbelow(True)

    sns.despine(ax=ax, offset=6, trim=True)

    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out, bbox_inches="tight")


if __name__ == "__main__":
    main()
