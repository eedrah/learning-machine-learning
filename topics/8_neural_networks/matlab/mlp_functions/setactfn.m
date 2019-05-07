function [activate, dactivate] = setactfn(actFunction)

%SETACTFN  Set activation function
%   [activate, dactivate] = setactfn(ActFunction)
%   See also...

%% Parse inputs
actFunctions = {'logistic','tanh','ReLU'};

p = inputParser;
    addRequired(p, 'actFunction', @(x) any(validatestring(x, actFunctions)))
parse(p, actFunction)
    actFunction = p.Results.actFunction;

%% Set activation function

switch lower(actFunction)
    case {'logistic'}
        activate = @(x) 1./(1 + exp(1).^(-x));
        dactivate = @(x) activate(x).*(1 - activate(x));
    case {'tanh'}
        activate = @tanh;
        dactivate = @(x) 1 - activate(x).^2;
    case {'relu'}
        activate = @(x) max(0, x);
        dactivate = @(x) x > 0;
end