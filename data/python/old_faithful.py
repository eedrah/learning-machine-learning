from pathlib import Path
import pandas
import matplotlib.pyplot as plt

data_file = Path(__file__).parent / '..' / 'raw' / 'old_faithful' / 'OldFaithful.csv'
data = pandas.read_csv(
            '../../../data/raw/old_faithful/OldFaithful.csv',
            usecols=(1, 2),
            header=0,
            names=('duration', 'delay'),
        )

def main():
    plt.scatter(data['duration'], data['delay'])
    plt.show()

if __name__ == '__main__':
    main()
