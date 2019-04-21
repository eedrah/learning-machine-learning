function [GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = expmax(X, K, varargin)

%EXPMAX Expectation Maximisation for GMM clustering
%   GMMClusts = EXPMAX(X, K) fits a K-component Gaussian mixture model using
%   the points in the N-by-D data matrix X. EXPMAX returns the N-by-K matrix 
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
%
%   [ ... ] = EXPMAX(..., 'PARAM1',val1, 'PARAM2',val2) specifies
%   optional parameter name/value pairs to control the iterative algorithm
%   used by EXPMAX.  Parameters are:
%
%           'ScaleData' - Scale the data before clustering (default true)
%           'MaxIters'  - Set the maximum number of EM steps (default 200)
%
%   See also KMEANS

%% Validate inputs
defaultScale = true;
defaultIters = 200;

p = inputParser;
    addRequired(p, 'X', @isnumeric);
    addRequired(p, 'K', @isnumeric);
    addParameter(p, 'ScaleData', defaultScale, @islogical);
    addParameter(p, 'MaxIters', defaultIters, @isnumeric);
parse(p, X, K, varargin{:});
    X = p.Results.X;
    K = p.Results.K;
    ScaleData = p.Results.ScaleData;
    MaxIters = p.Results.MaxIters;

%% Prep data/parameters
N = size(X, 1);
D = size(X, 2);

% Scale data
if ScaleData == true
    Data = X;
    X = X - repmat(mean(X), N, 1);
    X = X./repmat(std(X), N, 1);
end

%% Initialise clusters using K-means
kmClusts = kmeans(X, K);
GMMClusts = zeros(N, K);
for i = 1:N
    GMMClusts(i, kmClusts(i)) = 1;
end

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

%% If data was scaled, compute means and covariances using raw data for output
if ScaleData == true
    GMMMeans = (GMMClusts'*Data)./repmat(sum(GMMClusts)',1,D);
    for k = 1:K
        RepMeans = repmat(GMMMeans(k,:), N, 1);
        GMMCovs(:,:,k) = (X - RepMeans)'*(repmat(GMMClusts(:,k),1,D).*(X - RepMeans))./sum(GMMClusts(:,k));
        GMMCovs(:,:,k) = tril(GMMCovs(:,:,k), -1) + tril(GMMCovs(:,:,k))';
    end    
end

end