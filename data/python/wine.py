from pathlib import Path
import numpy as np
import pandas
from pandas import plotting
import matplotlib.pyplot as plt

data_file = Path(__file__).parent / ".." / "raw" / "wine" / "Wine.csv"
data = pandas.read_csv(
    data_file,
    names=(
        "Alcohol",
        "Malic acid",
        "Ash",
        "Alcalinity of ash",
        "Magnesium",
        "Total phenols",
        "Flavanoids",
        "Nonflavanoid phenols",
        "Proanthocyanins",
        "Color intensity",
        "Hue",
        "OD280/OD315 of diluted wines",
        "Proline",
    ),
)


def main():
    plt.rcParams["figure.figsize"] = (
        np.array(plt.rcParams["figure.figsize"]) * len(data.columns)
    ).tolist()

    plotting.scatter_matrix(data)
    plt.show()


if __name__ == "__main__":
    main()
