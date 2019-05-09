function Xscaled = scale(X)

%SCALE  Scale data to mean 0 and standard deviation 1
%   Xscaled = scale(X) returns the z-score of the data in X with centre 0
%   and standard deviation 1.
%
%       - If X is a vector, then SCALE operates on the entire vector
%       - If X is a matrix, then SCALE operates on each column separately
%       - If the standard deviation of any column is zero, SCALE replaces
%       NaNs with zeros

N = size(X, 1);

Xscaled = X - repmat(mean(X), N, 1);
Xscaled = Xscaled./repmat(std(X), N, 1);

if sum(isnan(Xscaled(:))) ~= 0
    warning('One or more variables have zero standard deviation. NaNs converted to zeros during scaling.')
    Xscaled(isnan(Xscaled)) = 0;
end