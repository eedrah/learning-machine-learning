%% 4. Expectation Maximisation

N = length(X);
K = 7;
MaxIters = 1000;

% Initialise cluster assignments

Clusters = rand(N, K);
Clusters = Clusters./repmat(sum(Clusters, 2), 1, K);

for j = 1:MaxIters


%% M-step

% M-step for means
Means = (X'*Clusters)./sum(Clusters);

% M-step for variances
Variances = sum(Clusters.*(repmat(X, 1, K) - repmat(Means, N, 1)).^2)./sum(Clusters);

% M-step for mixing coefficients
MixCoeffs = sum(Clusters)/N;

%% E-step: Soft cluster assignments

Densities = normpdf(repmat(X, 1, K), repmat(Means, N, 1), repmat(sqrt(Variances), N, 1));
SumDensities = Densities*MixCoeffs';
Clusters = (repmat(MixCoeffs, N, 1).*Densities)./repmat(SumDensities, 1, K);

%% Evaluate and store Likelihood

Likelihood = prod(SumDensities);

end
