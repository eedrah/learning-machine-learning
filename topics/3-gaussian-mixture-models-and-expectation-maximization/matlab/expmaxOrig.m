function [GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = expmaxOrig(X, K)

%EXPMAX Expectation Maximisation for GMM clustering
%   GMMClusts = EXPMAX(X, K) fits a K-component Gaussian mixture model using
%   the points in the N-by-D data matrix X. EXPMAX returns the N-by-K array
%   GMMClusts, which contains the soft cluster assignments of each point to
%   each Gaussian component.
%
%   [GMMClusts, GMMMeans] = EXPMAX(X, K) returns the means of the K Gaussian
%   components in the K-by-D matrix GMMMeans.
%
%   [..., GMMCovs] = EXPMAX(X, K) returns the covariance matrices of the K
%   Gaussian components in the D-by-D-by-K matrix GMMCovs.
%
%   [..., GMMCoeffs] = EXPMAX(X, K) returns the mixing coefficients/weights
%   of the K Gaussian components in the 1-by-K vector GMMCoeffs.
%
%   [..., LogLike] = EXPMAX(X, K) returns the log likelihood evaluated at
%   each step of the algorithm in the MaxIters-by-1 vector LogLike.

% Prep variables/parameters
N = size(X, 1);
D = size(X, 2);
MaxIters = 500;

% Scale data
X = X - repmat(mean(X), N, 1);
X = X./repmat(std(X), N, 1);

%% Initialise clusters

GMMClusts = rand(N, K);
GMMClusts = GMMClusts./repmat(sum(GMMClusts, 2), 1, K);

%% Preallocate arrays

GMMMeans = nan(K, D);
GMMCovs = nan(D, D, K);
GMMCoeffs = nan(1, K);
Densities = nan(N, K);
LogLike = nan(MaxIters, 1);

%% Expectation Maximisation

for j = 1:MaxIters
    
    % M-Step: Means
        GMMMeans = (GMMClusts'*X)./repmat(sum(GMMClusts)',1,D);

    % M-Step: Variances
    for k = 1:K
        RepMeans = repmat(GMMMeans(k,:), N, 1);
        GMMCovs(:,:,k) = (X - RepMeans)'*(repmat(GMMClusts(:,k),1,D).*(X - RepMeans))./sum(GMMClusts(:,k));
        GMMCovs(:,:,k) = tril(GMMCovs(:,:,k), -1) + tril(GMMCovs(:,:,k))';
    end

    % M-Step: Mixing coefficients
        GMMCoeffs = sum(GMMClusts)/N;
    
    % E-Step: Soft cluster assignments
    for k = 1:K
        Densities(:,k) = mvnpdf(X, GMMMeans(k,:), GMMCovs(:,:,k));
    end
    
        GMMDensities = Densities*GMMCoeffs';
        GMMClusts = (repmat(GMMCoeffs, N, 1).*Densities)./repmat(GMMDensities, 1, K);
        
    % Calculate and store likelihood
    LogLike(j) = sum(log(GMMDensities));
    
end

end