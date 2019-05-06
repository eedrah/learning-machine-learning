import sys
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import multivariate_normal

sys.path.append("../../..")
from data.python.wine import data

normalized_data = (data - data.mean()) / data.std()
covariance = normalized_data.cov()

[eigenvalues, eigenvectors] = np.linalg.eig(covariance)
descending_indices = eigenvalues.argsort()[::-1]
eigenvalues = eigenvalues[descending_indices]
eigenvectors = eigenvectors[descending_indices]

principal_components = normalized_data @ eigenvectors


def expectation_maximization(data, number_of_clusters):
    def initialize_clusters(number_of_observations, number_of_clusters):
        random_numbers = np.random.rand(number_of_observations, number_of_clusters)
        return random_numbers / random_numbers.sum(0)

    def compute_mean_cov_mixture_coefficients(data, soft_cluster_assignments):
        means = data.T @ soft_cluster_assignments
        covariances = [
            (data - mean).T @ (cluster_assignment * (data - mean))
            for mean, cluster_assignment in zip(
                means.columns, soft_cluster_assignments.columns
            )
        ]
        mixture_coefficients = soft_cluster_assignments.sum(0) / data.shape[0]
        return (means, covariances, mixture_coefficients)

    def calculate_soft_cluster_assignments(
        data, means, covariances, mixture_coefficients
    ):
        pdfs = np.array(
            [
                [
                    multivariate_normal.pdf(row, mean, covariance) * mixture_coefficient
                    for mean, covariance, mixture_coefficient in zip(
                        means.columns, covariances, mixture_coefficients
                    )
                ]
                for row in data
            ]
        )
        log_likelihood = np.product(pdfs)
        soft_cluster_assignments = pdfs / pdfs.sum(0)
        return soft_cluster_assignments, log_likelihood

    max_iterations = 1e7
    tolerance = 1e-2

    soft_cluster_assignments = initialize_clusters(data.shape[0], number_of_clusters)
    did_converge = False
    for _ in range(max_iterations):
        means, covariances, mixture_coefficients = compute_mean_cov_mixture_coefficients(
            data, soft_cluster_assignments
        )

        previous_log_likelihood = log_likelihood
        soft_cluster_assignments, log_likelihood = calculate_soft_cluster_assignments(
            data, means, covariances, mixture_coefficients
        )
        if log_likelihood - previous_log_likelihood < tolerance:
            did_converge = True
            break
    return (
        did_converge,
        (means, covariances, mixture_coefficients),
        soft_cluster_assignments,
        log_likelihood,
    )


"""
(data, number of clusters, init=(optional soft cluster assignments), return-goodness-of-fit-for-each-iteration?) -> (k gaussian distributions (mean dx1, cov dxd, mixture coefficient), n x k matrix of soft cluster assignments, goodness of fit)
    initialize clusters by randomly assigning soft cluster assignments
    compute mean, cov for each cluster, weighted on soft cluster assignment
    sum soft cluster assignments, divide by N for mixture coefficients

    for every datapoint and cluster, calculate pdf at the data point, weight, divide through by sum, to get soft cluster assignments

    calculate sum squared likelihood for each cluster, each datapoint proportional to the pdf
        sum across clusters
        = goodness of fit -> maximize this

    end when mean and std are stable
"""


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
