#! /usr/bin/env python3
import math
import unittest
from random import Random
from functools import reduce

random = Random()

def add_square(sum, next):
    return sum + next**2

def euclidian_distance(vector):
    sum_of_squares = reduce(add_square, vector, 0)
    return math.sqrt(sum_of_squares)

def euclidian_distance_between(vector1, vector2):
    vector_difference = [x - y for x, y in zip(vector1, vector2)]
    return euclidian_distance(vector_difference)

def vectors_add(vectors):
    return [sum(x) for x in zip(*vectors)]

def vector_divide(vector, divisor):
    return [x / divisor for x in vector]

def vectors_mean(vectors):
    return vector_divide(vectors_add(vectors), len(vectors))

def initialize_clusters(number_of_clusters, number_of_vectors):
    return [random.randint(0, number_of_clusters - 1) for _ in range(number_of_vectors)]

def calculate_centroids(vectors, clusters, number_of_clusters):
    centroids = []
    for cluster_number in range(number_of_clusters):
        vectors_in_cluster = [vector for vector, cluster in zip(vectors, clusters) if cluster == cluster_number]
        centroid = vectors_mean(vectors_in_cluster)
        centroids.append(centroid)
    return centroids

def calculate_clusters(vectors, centroids):
    clusters = []
    for vector in vectors:
        distances = [euclidian_distance_between(vector, centroid) for centroid in centroids]
        min_distance = min(enumerate(distances), key=lambda x:x[1])[1]
        possible_clusters = [cluster for cluster, distance in enumerate(distances) if distance == min_distance]
        clusters.append(random.choice(possible_clusters))
    return clusters

def k_means(vectors, number_of_clusters):
    clusters = initialize_clusters(number_of_clusters, len(vectors))
    while True:
        centroids = calculate_centroids(vectors, clusters, number_of_clusters)
        old_clusters = clusters
        clusters = calculate_clusters(vectors, centroids)
        if old_clusters == clusters:
            break
    return {'clusters': clusters, 'centroids': centroids}


class Test(unittest.TestCase):
    def setUp(self):
        global random
        random = Random(9573) # Fixed seed for testing

    def test_add_square(self):
        self.assertEqual(add_square(0, 2), 4)
        self.assertEqual(add_square(3, 2), 7)
        self.assertEqual(add_square(3, -2), 7)

    def test_euclidian_distance(self):
        self.assertEqual(euclidian_distance([3, 4]), 5)
        self.assertEqual(euclidian_distance([2, 3, 6]), 7)
        self.assertEqual(euclidian_distance([2, 3, -6]), 7)
        self.assertEqual(euclidian_distance([-2, 3, -6]), 7)
        self.assertEqual(euclidian_distance([1, 0, 0]), 1)

    def test_euclidian_distance_between(self):
        self.assertEqual(euclidian_distance_between([13, 14], [10, 10]), 5)
        self.assertEqual(euclidian_distance_between([12, 13, 16], [10, 10, 10]), 7)

    def test_vectors_add(self):
        self.assertEqual(vectors_add([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), [12, 15, 18])

    def test_vector_divide(self):
        self.assertEqual(vector_divide([1, 2, 3], 5), [0.2, 0.4, 0.6])

    def test_vector_mean(self):
        self.assertEqual(vectors_mean([[1, 2, 3], [2, 4, 6], [3, 6, 9]]), [2, 4, 6])

    def test_initialize_clusters(self):
        self.assertEqual(initialize_clusters(6, 10), [0, 5, 2, 0, 4, 5, 2, 2, 4, 2])

    def test_calcuate_centroids(self):
        self.assertEqual(calculate_centroids([[1, 1], [11, 11], [3, 3], [13, 13]], [1, 0, 1, 0], 2), [[12, 12], [2, 2]])

    def test_calculate_clusters(self):
        self.assertEqual(calculate_clusters([[1, 1], [11, 11], [3, 3], [13, 13]], [[12, 12], [2, 2]]), [1, 0, 1, 0])

    def test_k_means(self):
        self.assertEqual(k_means([[1, 1], [11, 11], [3, 3], [13, 13]], 2), {'clusters': [0, 1, 0, 1], 'centroids': [[2, 2], [12, 12]]})

if __name__ == '__main__':
    unittest.main()
