import numpy as np
import matplotlib.pyplot as plt

data = np.genfromtxt('../../../data/old-faithful/OldFaithful.csv', delimiter=',', names=True, usecols=(1,2))

plt.scatter(data['eruptions'], data['waiting'])
plt.show()

