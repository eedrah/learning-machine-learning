function [X, t, hiddenUnits, learningRate, gradientTol, actFunction, ...
                includeBiases] = parsemlp(X, t, hiddenUnits, varargin)

%PARSEMLP   Validate inputs for multilayer perceptron.
%
%   See also...

% Defaults for optional parameters
    ActFunctions = {'logistic','tanh','ReLU','Unit'};
    defaultActFn = 'logistic';
    defaultLearnRate = 0.01;
    defaultGradientTol = 1e-5;
    defaultBiases = true;
    %MaxIters/Time

% Parse inputs
p = inputParser;
    addRequired(p, 'X', @isnumeric);
    addRequired(p, 't', @isnumeric);
    addRequired(p, 'hiddenUnits', @isnumeric);
    addParameter(p, 'learningRate', defaultLearnRate, @isnumeric)
    addParameter(p, 'gradientTol', defaultGradientTol, @isnumeric)
    addParameter(p, 'actFunction', defaultActFn, @(x) any(validatestring(x, ActFunctions)));
    addParameter(p, 'includeBiases', defaultBiases, @islogical);
    
parse(p, X, t, hiddenUnits, varargin{:});
    X = p.Results.X;
    t = p.Results.t;
    hiddenUnits = p.Results.hiddenUnits;
    learningRate = p.Results.learningRate;
    gradientTol = p.Results.gradientTol;
    actFunction = p.Results.actFunction;
    includeBiases = p.Results.includeBiases;
    
% Other checks
    % Check model complexity < degrees of freedom
    % Check input and output arrays are the same length
    
end