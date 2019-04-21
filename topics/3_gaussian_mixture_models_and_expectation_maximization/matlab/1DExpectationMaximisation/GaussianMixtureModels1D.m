clearvars
clc

%% 1. Gaussian Mixture Model
K = 7;
ActMixCoeffs = rand(K,1); ActMixCoeffs = ActMixCoeffs/sum(ActMixCoeffs);
ActMeans = linspace(0,20,K)';
ActStdDevs = rand(K,1)*2;

xs = linspace(-10, 30, 1000)';

Densities = [];
for i = 1:K
    Densities(:,i) = normpdf(xs, ActMeans(i), ActStdDevs(i));
end

subplot(2,1,1)
plot(xs, Densities); title('Component distributions')
subplot(2,1,2)
plot(xs, Densities*ActMixCoeffs); title('Gaussian mixture model')

%% 2. Sample from mixing coefficients

N = 1E5;
ProbInterval = [0; cumsum(ActMixCoeffs)];
LB = ProbInterval(1:end-1);
UB = ProbInterval(2:end);

RandDraws1 = rand(N,1);
WhichGaussian = nan(N,1);
for i = 1:N
    WhichGaussian(i) = find((LB < RandDraws1(i)).*(RandDraws1(i) <= UB));
end

figure
subplot(2,1,1)
bar(ActMixCoeffs); title('Mixing coefficients')
subplot(2,1,2)
histogram(WhichGaussian, 'normalization', 'probability'); title('Sampling frequency for each component')

%% 3. Sample from component distributions

RandDraws2 = rand(N,1);
x = nan(N,1);
for i = 1:N
    x(i) = norminv(RandDraws2(i), ActMeans(WhichGaussian(i)), ActStdDevs(WhichGaussian(i)));
end

figure
plot(xs, Densities*ActMixCoeffs)
hold on
histogram(x,50,'Normalization','pdf')
title('Sample distribution vs actual')