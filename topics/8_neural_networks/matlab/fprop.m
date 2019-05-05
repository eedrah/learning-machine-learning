function nn = fprop(nn, x)

%FPROP Propagate an observation forward through a multilayer perceptron
%
% See also...

%% Parse inputs

%% Forward propagate

N_layers = size(nn, 2);

nn(1).activations = nn(1).weights*x + nn(1).biases;
nn(1).outputs = nn(1).actfn(nn(1).activations);

for layer = 2:N_layers
    nn(layer).activations = nn(layer).weights*nn(layer-1).outputs + nn(layer).biases;
    nn(layer).outputs = nn(layer).actfn(nn(layer).activations);
end

end