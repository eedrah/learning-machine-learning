from pathlib import Path
import pandas
import matplotlib.pyplot as plt

data_file = Path(__file__).parent / "../raw/synthetic_clustering/S_sets/s1.txt"
data = pandas.read_csv(data_file, sep="\s+", header=None)


def main():
    plt.scatter(data[0], data[1])
    plt.show()


if __name__ == "__main__":
    main()
