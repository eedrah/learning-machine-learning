import sys
sys.path.append('../../..')
import numpy as np
import matplotlib.pyplot as plt

from data.python.old_faithful import data

normalized_data = (data - data.mean()) / data.std()
covariance = normalized_data.cov()

[eigenvalues, eigenvectors] = np.linalg.eig(covariance)
descending_indices = eigenvalues.argsort()[::-1]
eigenvalues = eigenvalues[descending_indices]
eigenvectors = eigenvectors[descending_indices]

principal_components = normalized_data @ eigenvectors

projections = [np.outer(principal_component, eigenvector)
        for ((_, principal_component), eigenvector)
        in zip(principal_components.iteritems(), eigenvectors.T)]

def main():
    plt.scatter(normalized_data['duration'], normalized_data['delay'])
    for projection in projections:
        plt.scatter(projection[:, 0], projection[:, 1])

    plt.show()

if __name__ == '__main__':
    main()

