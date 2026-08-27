import math
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.ticker import FixedLocator, FuncFormatter

sns.set_theme(style="ticks")

POINT_COUNT = 200_000
SAMPLE_RATE = 0.1
ZOOM_GAP_MULTIPLE = 2048
ZOOM_TICK_TARGET = 8

POINT_COLOUR = "#bcef23"
PAIR_COLOUR = "#33cc33"
HIGHLIGHT_COLOUR = "#009900"

df = pd.read_csv(f"data/points_{POINT_COUNT}.csv")
n = len(df)

pair = df[df.is_part_of_shortest_pair == 1]
rest = df[df.is_part_of_shortest_pair == 0]

first_point, second_point = pair.iloc[0], pair.iloc[1]
gap = math.dist((first_point.x, first_point.y), (second_point.x, second_point.y))
centre_x, centre_y = pair.x.mean(), pair.y.mean()


def draw_panel(ax, background, point_size, pair_size, highlight_width, line_colour):
    sns.scatterplot(
        data=background,
        x="x",
        y="y",
        s=point_size,
        color=POINT_COLOUR,
        linewidth=0,
        alpha=0.5,
        ax=ax,
    )
    ax.plot(pair.x, pair.y, color=line_colour, lw=1.5, zorder=3)
    ax.scatter(
        pair.x,
        pair.y,
        s=pair_size,
        color=PAIR_COLOUR,
        edgecolor=HIGHLIGHT_COLOUR,
        linewidth=highlight_width,
        zorder=4,
    )
    ax.set_aspect("equal")


def tick_step_in_gaps():
    rough = 2 * ZOOM_GAP_MULTIPLE / ZOOM_TICK_TARGET
    magnitude = 10 ** math.floor(math.log10(rough))
    return next(magnitude * m for m in (1, 2, 5, 10) if magnitude * m >= rough)


def zoom_reach_in_gaps():
    step = tick_step_in_gaps()
    return math.ceil(ZOOM_GAP_MULTIPLE / step) * step


def label_in_gaps(centre, axis):
    step = tick_step_in_gaps()
    count = round(zoom_reach_in_gaps() / step)
    offsets = [k * step for k in range(-count, count + 1)]
    axis.set_major_locator(FixedLocator([centre + k * gap for k in offsets]))
    axis.set_major_formatter(FuncFormatter(lambda v, _: f"{(v - centre) / gap:g}"))


fig, (full_ax, zoom_ax) = plt.subplots(1, 2, figsize=(14, 7))

sample = rest.sample(math.floor(n * SAMPLE_RATE), random_state=0)

draw_panel(
    full_ax,
    sample,
    point_size=4,
    pair_size=60,
    highlight_width=1.5,
    line_colour=PAIR_COLOUR,
)

full_ax.set_title(f"{n:,} Points ({SAMPLE_RATE:.0%} shown)")
full_ax.set_xlabel("x")
full_ax.set_ylabel("y")

radius = gap * zoom_reach_in_gaps()

neighbours = rest[
    rest.x.between(centre_x - radius, centre_x + radius)
    & rest.y.between(centre_y - radius, centre_y + radius)
]
draw_panel(
    zoom_ax,
    neighbours,
    point_size=40,
    pair_size=200,
    highlight_width=2,
    line_colour=HIGHLIGHT_COLOUR,
)

zoom_ax.set_xlim(centre_x - radius, centre_x + radius)
zoom_ax.set_ylim(centre_y - radius, centre_y + radius)

zoom_ax.set_title("Closest Points (Zoomed)")

zoom_ax.set_xlabel("x (gaps)")
zoom_ax.set_ylabel("y (gaps)")

label_in_gaps(centre_x, zoom_ax.xaxis)
label_in_gaps(centre_y, zoom_ax.yaxis)

sns.despine(fig=fig, offset=10, trim=True)

fig.savefig(f"visualisations/points_{POINT_COUNT}.png", dpi=200, bbox_inches="tight")
