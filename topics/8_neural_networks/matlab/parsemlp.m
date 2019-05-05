function [X, t, N_neurons, learningRate, gradientTol, actFunction, ...
                scaleData, includeBiases] = parsemlp(X, t, N_neurons, varargin)

%PARSEMLP   Validate inputs for multilayer perceptron.
%
%   See also...

% Defaults for optional parameters
    ActFunctions = {'logistic','tanh','ReLU'};
    defaultActFn = 'logistic';
    defaultLearnRate = 0.01;
    defaultGradientTol = 1e-5;
    defaultScale = true;
    defaultBiases = true;
    %MaxIters/Time

% Parse inputs
p = inputParser;
    addRequired(p, 'X', @isnumeric);
    addRequired(p, 't', @isnumeric);
    addRequired(p, 'N_neurons', @isnumeric);
    addParameter(p, 'learningRate', defaultLearnRate, @isnumeric)
    addParameter(p, 'gradientTol', defaultGradientTol, @isnumeric)
    addParameter(p, 'actFunction', defaultActFn, @(x) any(validatestring(x, ActFunctions))); 
    addParameter(p, 'scaleData', defaultScale, @islogical);
    addParameter(p, 'includeBiases', defaultBiases, @islogical);
    
parse(p, X, t, N_neurons, varargin{:});
    X = p.Results.X;
    t = p.Results.t;
    N_neurons = p.Results.N_neurons;
    learningRate = p.Results.learningRate;
    gradientTol = p.Results.gradientTol;
    actFunction = p.Results.actFunction;
    scaleData = p.Results.scaleData;
    includeBiases = p.Results.includeBiases;
    
% Other checks
    % Check model complexity < degrees of freedom
    % Check input and output arrays are the same length
    
end