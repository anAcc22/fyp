"""Draws every figure in the paper, so that they all share one style.

Example:
    .venv/bin/python plot.py \
        --data data/heuristics_random_pairs.csv \
        --x attempts_per_point --y ratio \
        --x-label 'Budget ($a$)' --y-label 'Ratio' --y-min 1 \
        --form swarm --theme heuristics \
        --out paper/diagrams/heuristics_random_pairs.pdf
"""

import argparse
import math
import sys
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib import font_manager
from matplotlib.collections import LineCollection
from matplotlib.colors import LinearSegmentedColormap, Normalize
from matplotlib.patches import Rectangle
from matplotlib.ticker import MultipleLocator, NullLocator, ScalarFormatter
import seaborn as sns

# Each chapter has its own key colour.
THEMES = {
    "heuristics": {
        "key_colour": "#7E9C54",
        "deep_colour": "#4A6128",
        "label_colour": "#E6C384",
        "value_band_colour": "#D5DFC2",
        "outline_colour": "#E6C384",
    },
}

INK_COLOUR = "#333333"

# Each line on a comparison plot: (name, colour, marker). The chapter's green shading towards lime and yellow.
SOLVER_LINES = {
    "examine_neighbours_along_z_order_curve": ("Z-order curve", "#4A6128", "o"),
    "best_first_kd_tree": ("Best-first search", "#7FA23C", "s"),
    "examine_neighbours_along_random_directions": ("Random directions", "#B5C242", "^"),
    "examine_random_pairs": ("Random pairs", "#DDA93C", "v"),
}

# Literata at medium weight, kept in the repo so that figures come out the same on any machine.
FONT_FOLDER = Path(__file__).parent / "fonts"
FIGURE_FONT = "Literata Figures"

# The paper includes every figure at 85% of this size (see main.tex).
FIGURE_SIZE_IN_INCHES = (5.2, 2.95)

MAX_LABELLED_X_VALUES = 12
MEAN_LABEL_OFFSET_IN_POINTS = 6
MEAN_LABEL_ROOM = 0.13
MEAN_LABEL_ALPHA = 0.5
MEAN_LABEL_FONT_SIZE = 8
HEATMAP_LABEL_FONT_SIZE = 8
HEATMAP_PALE_COLOUR = "#F3F5EA"
HEATMAP_OUTLINE_WIDTH = 2
# As fractions of a cell's (width, height). Cells are wider than tall, so the band's thickness needs both.
HEATMAP_BAND_OUTER_INSET = (0.025, 0.04)
HEATMAP_BAND_INNER_INSET = (0.085, 0.145)
EXACT_VALUE_TOLERANCE = 1e-12
SAMPLE_ALPHA = 0.5
SAMPLE_DIAMETER_IN_POINTS = 3.5
MEAN_BAND_AREA_IN_POINTS = 140
DUMBBELL_MARKER_AREA_IN_POINTS = 64
DOUBLING_X_AXIS_ROOM = 1.25
LINE_MARKER_SIZE_IN_POINTS = 6
CONFIDENCE_BAND_ALPHA = 0.2
CONFIDENCE_BAND_CAP_WIDTH_IN_DOUBLINGS = 0.38
CONFIDENCE_BAND_CAP_STEPS = 24
CONFIDENCE_LEVEL = 95


def read_arguments():
    parser = argparse.ArgumentParser(description="Plot every trial of a measure, with the mean on top.")
    parser.add_argument("--data", type=Path, required=True, help="CSV file written by the harness")
    parser.add_argument("--x", required=True, help="CSV column or solver param for the x-axis")
    parser.add_argument("--y", required=True, help="CSV column for the y-axis")
    parser.add_argument("--x-label", required=True, help="may contain LaTeX")
    parser.add_argument("--y-label", required=True, help="may contain LaTeX")
    parser.add_argument("--y-min", type=float, help="where the y-axis starts, if not left to the data")
    parser.add_argument("--y-step", type=float, help="gap between y-axis ticks, if not left to the data")
    parser.add_argument("--form", required=True, choices=("swarm", "violin", "heatmap", "dumbbell", "lines"), help="how to show the trials")
    parser.add_argument("--row", help="for a heatmap: CSV column or solver param for the rows")
    parser.add_argument("--mark-value", type=float, help="put a double border on heatmap cells with this value, or on means whose trials all have it")
    parser.add_argument("--outline-product", type=float, help="for a heatmap: outline the cells where row x column is at most this")
    parser.add_argument("--ends", help="for a dumbbell: CSV column or solver param with the two values to join")
    parser.add_argument("--ends-label", help="for a dumbbell: name shown in the legend, e.g. a gives a = 6")
    parser.add_argument("--theme", required=True, choices=THEMES)
    parser.add_argument("--out", type=Path, required=True, help="output file, e.g. paper/diagrams/name.pdf")
    return parser.parse_args()


def as_numbers_if_possible(column):
    numbers = pd.to_numeric(column, errors="coerce")
    return numbers if numbers.notna().eq(column.notna()).all() else column


def read_results(path):
    """Splits the params column, e.g. "direction_count=4, neighbours_per_point=32", into one column each."""
    results = pd.read_csv(path)
    params = results["params"].fillna("").map(
        lambda text: dict(pair.split("=") for pair in text.split(", ") if pair)
    )
    params = pd.DataFrame(params.tolist(), index=results.index).apply(as_numbers_if_possible)
    return results.drop(columns="params").join(params)


def fail_if_mixing_settings(results, plotted_columns):
    """A trial appearing twice at one spot means different settings would be averaged together."""
    if results.duplicated([*plotted_columns, "trial_number"]).any():
        sys.exit(f"~> the data has several settings per value of {plotted_columns}: split it before plotting")


def use_paper_style():
    for font_file in FONT_FOLDER.glob("*.ttf"):
        font_manager.fontManager.addfont(font_file)

    sns.set_theme(
        style="ticks",
        font=FIGURE_FONT,
        font_scale=0.9,
        rc={
            "pdf.fonttype": 42,
            "mathtext.fontset": "custom",
            "mathtext.rm": FIGURE_FONT,
            "mathtext.it": f"{FIGURE_FONT}:italic",
            "mathtext.bf": FIGURE_FONT,
            "mathtext.cal": FIGURE_FONT,
            "text.color": INK_COLOUR,
            "axes.edgecolor": INK_COLOUR,
            "axes.labelcolor": INK_COLOUR,
            "xtick.color": INK_COLOUR,
            "ytick.color": INK_COLOUR,
        },
    )


def equals_marked_value(values, marked_value):
    if marked_value is None:
        return np.zeros(np.shape(values), dtype=bool)

    return np.isclose(values, marked_value, rtol=0, atol=EXACT_VALUE_TOLERANCE)


def x_values_where_all_trials_are_marked(results, x, y, marked_value):
    is_marked = pd.Series(equals_marked_value(results[y], marked_value), index=results.index)
    all_marked = is_marked.groupby(results[x]).all()
    return all_marked.index[all_marked]


def draw_samples(ax, results, x, y, form, colour, marked_value):
    if form == "swarm":
        # Trials tied on the marked value would only smear sideways, so they share one spot instead.
        is_marked = equals_marked_value(results[y], marked_value)
        ax.scatter(
            results.loc[is_marked, x],
            results.loc[is_marked, y],
            s=SAMPLE_DIAMETER_IN_POINTS**2,
            color=colour,
            alpha=SAMPLE_ALPHA,
            linewidth=0,
            clip_on=False,
        )
        sns.swarmplot(
            data=results[~is_marked],
            x=x,
            y=y,
            native_scale=True,
            color=colour,
            alpha=SAMPLE_ALPHA,
            size=SAMPLE_DIAMETER_IN_POINTS,
            ax=ax,
        )
    else:
        sns.violinplot(
            data=results,
            x=x,
            y=y,
            native_scale=True,
            color=colour,
            saturation=1,
            alpha=SAMPLE_ALPHA,
            inner=None,
            cut=0,
            density_norm="width",
            linewidth=0,
            ax=ax,
        )


def draw_mean_with_error_bars(ax, results, x, y, colour):
    sns.pointplot(
        data=results,
        x=x,
        y=y,
        native_scale=True,
        color=colour,
        errorbar=("ci", CONFIDENCE_LEVEL),
        seed=0,
        capsize=0.15,
        linewidth=1.5,
        markersize=8,
        markeredgecolor="white",
        markeredgewidth=1,
        ax=ax,
    )

    # A mean sitting on the edge of the plot should still show its whole marker.
    for line in ax.lines:
        line.set_clip_on(False)


def draw_band_around_means(ax, x_values, y_value, colour):
    ax.scatter(x_values, [y_value] * len(x_values), s=MEAN_BAND_AREA_IN_POINTS, color=colour, linewidth=0, clip_on=False)


def draw_double_border(ax, column_index, row_index, band_colour, centre_colour):
    """A band of fill around the cell's own colour, with the white gap between cells left intact."""
    for (inset_x, inset_y), colour in (
        (HEATMAP_BAND_OUTER_INSET, band_colour),
        (HEATMAP_BAND_INNER_INSET, centre_colour),
    ):
        ax.add_patch(
            Rectangle(
                (column_index + inset_x, row_index + inset_y),
                1 - 2 * inset_x,
                1 - 2 * inset_y,
                facecolor=colour,
                edgecolor="none",
            )
        )


def draw_outline(ax, is_inside, colour):
    """Traces the edges where a cell inside the region meets a cell outside it, or the heatmap's edge."""
    padded = np.pad(is_inside, 1)
    edges = []

    for row_index, column_index in np.argwhere(is_inside):
        padded_row, padded_column = row_index + 1, column_index + 1
        left, right = column_index, column_index + 1
        bottom, top = row_index, row_index + 1

        if not padded[padded_row - 1, padded_column]:
            edges.append([(left, bottom), (right, bottom)])
        if not padded[padded_row + 1, padded_column]:
            edges.append([(left, top), (right, top)])
        if not padded[padded_row, padded_column - 1]:
            edges.append([(left, bottom), (left, top)])
        if not padded[padded_row, padded_column + 1]:
            edges.append([(right, bottom), (right, top)])

    ax.add_collection(
        LineCollection(edges, colors=colour, linewidths=HEATMAP_OUTLINE_WIDTH, capstyle="projecting", clip_on=False)
    )


def draw_heatmap(ax, results, x, row, y, theme, marked_value, outlined_product):
    """Lighter cells have lower values, and rows run upwards like any other y-axis."""
    means = results.pivot_table(index=row, columns=x, values=y, aggfunc="mean")
    colours = LinearSegmentedColormap.from_list("theme", [HEATMAP_PALE_COLOUR, theme["key_colour"]])

    labels = means.map(lambda value: f"{value:.2f}")
    has_marked_value = equals_marked_value(means.to_numpy(), marked_value)

    if marked_value is not None:
        labels = labels.mask(has_marked_value, f"{marked_value:g}")

    sns.heatmap(
        means,
        annot=labels.to_numpy(),
        fmt="",
        annot_kws={"size": HEATMAP_LABEL_FONT_SIZE, "color": INK_COLOUR},
        cmap=colours,
        cbar=False,
        linewidths=1.5,
        linecolor="white",
        ax=ax,
    )
    ax.tick_params(length=0)
    ax.tick_params(axis="y", rotation=0)
    ax.invert_yaxis()

    scale = Normalize(means.min().min(), means.max().max())

    for row_index, column_index in np.argwhere(has_marked_value):
        centre_colour = colours(scale(means.iloc[row_index, column_index]))
        draw_double_border(ax, column_index, row_index, theme["value_band_colour"], centre_colour)

    if outlined_product is not None:
        draw_outline(ax, np.outer(means.index, means.columns) <= outlined_product, theme["outline_colour"])


def label_first_and_last_means(ax, results, x, y, colour, unlabelled_x_values):
    means = results.groupby(x)[y].mean().sort_index()

    x_span = means.index[-1] - means.index[0]
    ax.set_xlim(means.index[0] - MEAN_LABEL_ROOM * x_span, means.index[-1] + MEAN_LABEL_ROOM * x_span)

    for position, sign, alignment in ((0, -1, "right"), (-1, 1, "left")):
        if means.index[position] in unlabelled_x_values:
            continue

        ax.annotate(
            f"{means.iloc[position]:.2f}",
            xy=(means.index[position], means.iloc[position]),
            xytext=(sign * MEAN_LABEL_OFFSET_IN_POINTS, -MEAN_LABEL_OFFSET_IN_POINTS),
            textcoords="offset points",
            ha=alignment,
            va="top",
            fontsize=MEAN_LABEL_FONT_SIZE,
            annotation_clip=False,
            bbox={"boxstyle": "round,pad=0.25", "facecolor": colour, "edgecolor": "none", "alpha": MEAN_LABEL_ALPHA},
        )


def keep_trials_within_y_axis(ax, values, y_min):
    """Despine trims the axis to its outermost ticks, so those ticks must lie beyond the data."""
    ticks = ax.get_yticks()
    tick_step = ticks[1] - ticks[0]

    bottom = y_min if y_min is not None else math.floor(values.min() / tick_step) * tick_step
    ax.set_ylim(bottom=bottom, top=math.ceil(values.max() / tick_step) * tick_step)


def use_doubling_x_axis(ax, x_values):
    ax.set_xscale("log", base=2)
    ax.set_xlim(x_values[0] / DOUBLING_X_AXIS_ROOM, x_values[-1] * DOUBLING_X_AXIS_ROOM)
    ax.xaxis.set_major_formatter(ScalarFormatter())
    ax.xaxis.set_minor_locator(NullLocator())
    ax.set_xticks(x_values)


def round_off_right_end_of_band(band):
    """A band otherwise ends in a hard vertical edge, as if chopped off. The cap adds no data: it only softens that edge."""
    vertices = band.get_paths()[0].vertices
    last_x = vertices[:, 0].max()
    end_a, end_b = np.flatnonzero(vertices[:, 0] == last_x)[[0, -1]]

    middle = (vertices[end_a, 1] + vertices[end_b, 1]) / 2
    half_height = (vertices[end_b, 1] - vertices[end_a, 1]) / 2
    angles = np.linspace(-np.pi / 2, np.pi / 2, CONFIDENCE_BAND_CAP_STEPS)

    cap = np.column_stack((
        last_x * 2 ** (CONFIDENCE_BAND_CAP_WIDTH_IN_DOUBLINGS * np.cos(angles)),
        middle + half_height * np.sin(angles),
    ))

    band.set_verts([np.vstack((vertices[: end_a + 1], cap, vertices[end_b:]))])


def draw_solver_lines(ax, results, x, y):
    """One line of means per solver, each in a soft confidence band. x doubles along the axis."""
    solvers = [solver for solver in SOLVER_LINES if solver in set(results["solver"])]

    for solver in solvers:
        name, colour, marker = SOLVER_LINES[solver]

        sns.lineplot(
            data=results[results["solver"] == solver],
            x=x,
            y=y,
            color=colour,
            marker=marker,
            markersize=LINE_MARKER_SIZE_IN_POINTS,
            markeredgecolor="white",
            markeredgewidth=0.8,
            linewidth=1.8,
            errorbar=("ci", CONFIDENCE_LEVEL),
            seed=0,
            err_style="band",
            err_kws={"alpha": CONFIDENCE_BAND_ALPHA, "linewidth": 0, "clip_on": False},
            clip_on=False,
            label=name,
            ax=ax,
        )
        round_off_right_end_of_band(ax.collections[-1])

    use_doubling_x_axis(ax, np.sort(results[x].unique()))
    ax.legend(frameon=False, loc="lower right", bbox_to_anchor=(1, 1.02), ncols=2)

    return results.groupby([x, "solver"])[y].mean().to_numpy()


def draw_dumbbells(ax, results, x, y, ends, ends_label, theme):
    """One bar per x value, joining the means at the two ends. x doubles along the axis."""
    means = results.pivot_table(index=x, columns=ends, values=y)
    start, end = means.columns

    ax.vlines(means.index, means[end], means[start], colors=theme["key_colour"], linewidth=2, zorder=1)
    ax.scatter(
        means.index,
        means[start],
        s=DUMBBELL_MARKER_AREA_IN_POINTS,
        facecolor=HEATMAP_PALE_COLOUR,
        edgecolor=theme["key_colour"],
        linewidth=1.5,
        zorder=2,
        clip_on=False,
        label=f"${ends_label} = {start}$",
    )
    ax.scatter(
        means.index,
        means[end],
        s=DUMBBELL_MARKER_AREA_IN_POINTS,
        color=theme["deep_colour"],
        linewidth=0,
        zorder=3,
        clip_on=False,
        label=f"${ends_label} = {end}$",
    )

    use_doubling_x_axis(ax, means.index)
    ax.legend(frameon=False, loc="upper right")

    return means.to_numpy().ravel()


def main():
    arguments = read_arguments()
    results = read_results(arguments.data)

    for column, flag in ((arguments.x, "--x"), (arguments.y, "--y")):
        if column not in results.columns:
            sys.exit(f"~> {flag} {column} is not in {arguments.data}")

    if arguments.form == "heatmap" and arguments.row not in results.columns:
        sys.exit(f"~> --form heatmap needs a --row that is in {arguments.data}")

    if arguments.form == "dumbbell" and (
        arguments.ends not in results.columns or arguments.ends_label is None or results[arguments.ends].nunique() != 2
    ):
        sys.exit(f"~> --form dumbbell needs an --ends with two values in {arguments.data}, and an --ends-label")

    plotted_columns = [arguments.x]
    if arguments.form == "heatmap":
        plotted_columns.append(arguments.row)
    if arguments.form == "dumbbell":
        plotted_columns.append(arguments.ends)
    if arguments.form == "lines":
        plotted_columns.append("solver")

    fail_if_mixing_settings(results, plotted_columns)
    use_paper_style()

    fig, ax = plt.subplots(figsize=FIGURE_SIZE_IN_INCHES)

    theme = THEMES[arguments.theme]

    if arguments.form == "heatmap":
        draw_heatmap(
            ax, results, arguments.x, arguments.row, arguments.y, theme, arguments.mark_value, arguments.outline_product
        )
    elif arguments.form == "lines":
        means = draw_solver_lines(ax, results, arguments.x, arguments.y)

        if arguments.y_step is not None:
            ax.yaxis.set_major_locator(MultipleLocator(arguments.y_step))

        keep_trials_within_y_axis(ax, pd.Series(means).dropna(), arguments.y_min)
        sns.despine(fig=fig, offset=10, trim=True)
    elif arguments.form == "dumbbell":
        means = draw_dumbbells(ax, results, arguments.x, arguments.y, arguments.ends, arguments.ends_label, theme)
        keep_trials_within_y_axis(ax, pd.Series(means), arguments.y_min)
        sns.despine(fig=fig, offset=10, trim=True)
    else:
        marked_x_values = x_values_where_all_trials_are_marked(results, arguments.x, arguments.y, arguments.mark_value)

        draw_samples(ax, results, arguments.x, arguments.y, arguments.form, theme["key_colour"], arguments.mark_value)
        draw_band_around_means(ax, marked_x_values, arguments.mark_value, theme["label_colour"])
        draw_mean_with_error_bars(ax, results, arguments.x, arguments.y, theme["deep_colour"])
        label_first_and_last_means(ax, results, arguments.x, arguments.y, theme["label_colour"], marked_x_values)

        if results[arguments.x].nunique() <= MAX_LABELLED_X_VALUES:
            ax.set_xticks(sorted(results[arguments.x].unique()))

        keep_trials_within_y_axis(ax, results[arguments.y], arguments.y_min)
        sns.despine(fig=fig, offset=10, trim=True)

    ax.set_xlabel(arguments.x_label)
    ax.set_ylabel(arguments.y_label)

    arguments.out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(arguments.out, bbox_inches="tight")


if __name__ == "__main__":
    main()
