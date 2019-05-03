from pathlib import Path
import pandas
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
    pass


if __name__ == "__main__":
    main()
