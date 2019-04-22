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

projection_0 = principal_components[0].values.reshape(-1, 1) \
               @ eigenvectors[:, 0].reshape(1, -1)
projection_1 = principal_components[1].values.reshape(-1, 1) \
               @ eigenvectors[:, 1].reshape(1, -1)

def main():
    plt.scatter(normalized_data['duration'], normalized_data['delay'])
    plt.scatter(projection_0[:, 0], projection_0[:, 1])
    plt.scatter(projection_1[:, 0], projection_1[:, 1])

    plt.show()

if __name__ == '__main__':
    main()

