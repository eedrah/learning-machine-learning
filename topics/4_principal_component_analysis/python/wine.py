import sys
import numpy as np
import matplotlib.pyplot as plt

sys.path.append("../../..")
from data.python.wine import data

normalized_data = (data - data.mean()) / data.std()
covariance = normalized_data.cov()

[eigenvalues, eigenvectors] = np.linalg.eig(covariance)
descending_indices = eigenvalues.argsort()[::-1]
eigenvalues = eigenvalues[descending_indices]
eigenvectors = eigenvectors[descending_indices]

principal_components = normalized_data @ eigenvectors


def main():
    num_cols = len(data.columns)
    plt.rcParams["figure.figsize"] = (
        np.array(plt.rcParams["figure.figsize"]) * num_cols / 2
    ).tolist()

    for y_index in range(num_cols):
        for x_index in range(num_cols):
            plot_number = y_index * num_cols + x_index + 1
            plt.subplot(num_cols, num_cols, plot_number)

            if y_index == x_index:
                plt.hist(data.iloc[:, x_index], bins=20)
            else:
                plt.scatter(data.iloc[:, x_index], data.iloc[:, y_index])

            if y_index == num_cols - 1:
                # if in the last row, print the x labels
                plt.xlabel(data.iloc[:, x_index].name)
            if x_index == 0:
                # if in the first column, print the y labels
                plt.ylabel(data.iloc[:, y_index].name)

    plt.savefig("wine.png", bbox_inches="tight")
    print("Figure saved to wine.png")


if __name__ == "__main__":
    main()
