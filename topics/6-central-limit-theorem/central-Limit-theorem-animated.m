clearvars

%n = size of each sample
n = 200;

%L = number of samples
L = 10^6;

%Generate L samples of size n from a beta distribution with parameters A, B
A = 1;
B = 1;
X = betarnd(A, B, n, L);

%the ith row is the sum of i random variables drawn from the distribution specified above
sumX = cumsum(X);

%Plot
Nbins = 50;

for i = 1:n
    histogram(sumX(i,:)/i , Nbins, 'Normalization', 'pdf')
    xlim([0 1])
    i
    pause
end