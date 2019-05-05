function [nn, gd] = initmlp(D, hiddenUnits, K, actFunction)

%INITMLP Initialise network for multilayer perceptron
%
%   See also...

%% Parse inputs

%% Initialise network

N_units = [D hiddenUnits(:)' K];
N_layers = length(N_units) - 1;

nn = struct();
gd = struct();

a = -1; b = 1;

for layer = 1:N_layers
    nn(layer).weights = a+(b-a)*rand(N_units(layer+1), N_units(layer));
    nn(layer).biases = a+(b-a)*rand(N_units(layer+1), 1);
    nn(layer).activations = nan(N_units(layer+1), 1);
    nn(layer).outputs = nan(N_units(layer+1), 1);
    [nn(layer).actfn, nn(layer).dactfn] = setactfn(actFunction);    % dactfn calls 'activate', but this seems to work. Why?!
    
    gd(layer).weightgradients = zeros(N_units(layer+1), N_units(layer));
    gd(layer).biasgradients = zeros(N_units(layer+1), 1);
    gd(layer).deltas = nan(N_units(layer+1), 1);
    gd(layer).predeltas = nan(N_units(layer+1), 1);
end