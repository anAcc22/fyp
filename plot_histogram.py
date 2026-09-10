import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style="ticks")

DIMENSIONS = [2, 4, 6, 8, 10]
POINT_COUNT = 1_000
SAMPLE_SIZE = 40_000

VIOLIN_COLOURS = ["#33cc33", "#e6194b", "#ffc61a", "#4363d8", "#911eb4"]
EDGE_COLOUR = "#333333"

randomiser = np.random.default_rng(0)


def pairwise_distances(dimensions):
    coords = pd.read_csv(f"data/general_points_{dimensions}D_{POINT_COUNT}.csv").to_numpy(dtype=float)
    squared = (coords**2).sum(axis=1)
    squared_distances = squared[:, None] + squared[None, :] - 2 * coords @ coords.T
    upper = np.triu_indices(len(coords), k=1)
    return np.sqrt(np.maximum(squared_distances[upper], 0.0))


df = pd.concat(
    pd.DataFrame(
        {
            "dimensions": dimensions,
            "distance": randomiser.choice(pairwise_distances(dimensions), SAMPLE_SIZE, replace=False),
        }
    )
    for dimensions in DIMENSIONS
)

fig, ax = plt.subplots(figsize=(9, 6))

sns.violinplot(
    data=df,
    x="dimensions",
    y="distance",
    hue="dimensions",
    palette=VIOLIN_COLOURS,
    legend=False,
    linecolor=EDGE_COLOUR,
    linewidth=1.2,
    ax=ax,
)

ax.set_xlabel("Dimensions")
ax.set_ylabel("Euclidean Distance")

sns.despine(fig=fig, offset=10, trim=True)

fig.savefig("visualisations/distance_by_dimension.png", dpi=200, bbox_inches="tight")
