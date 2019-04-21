clearvars

%n = size of each sample
n = 10;

%L = number of samples
L = 10000;

%Generate L samples of size n from a beta distribution with parameters A, B
A = 0.5;
B = 0.5;
X = betarnd(A, B, n, L);
Xbar = mean(X);

Nbins = 21;

%Theoretical beta moments
betMean = A/(A+B);
betVar = A*B/((A+B)^2*(A+B+1));

%Plot
subplot(2,1,1)
histogram(X, linspace(0,1,Nbins+1), 'Normalization', 'pdf')
set(gca, 'xtick', [0 0.5 1])
title('Beta distribution')

subplot(2,1,2)
histogram(Xbar, Nbins, 'Normalization', 'pdf')
hold on

x = linspace(0,1,100);
norm = normpdf(x, betMean, sqrt(betVar/n));
plot(x, norm)
set(gca, 'xtick', [0 0.5 1])
title('Sampling distribution of the mean')
hold off