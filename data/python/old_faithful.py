import numpy as np
import matplotlib.pyplot as plt

data = np.genfromtxt('../raw/old_faithful/OldFaithful.csv', delimiter=',', names=('duration', 'delay'), usecols=(1,2), skip_header=1)

def main():
    plt.scatter(data['duration'], data['delay'])
    plt.show()

if __name__ == '__main__':
    main()
