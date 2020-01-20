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
import numpy as np
from scipy.stats import multivariate_normal


class ExpectationMaximization:
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

    def __init__(data, number_of_clusters):
        max_iterations = 1e7
        tolerance = 1e-2

        soft_cluster_assignments = initialize_clusters(
            data.shape[0], number_of_clusters
        )
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
