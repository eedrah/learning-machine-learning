function nn = gdescend(nn, gd, learningRate)

%GDESCEND Gradient descent step for multilayer perceptron training.
%   Updates the weights and biases of a multilayer perceptron, based on the
%   gradients computed by backpropogation.
%   
%   See also TRAINMLP, BPROP, FPROP

%% Parse inputs

%% Gradient descent

N_layers = size(nn, 2);

for layer = 1:N_layers
    nn(layer).weights = nn(layer).weights - learningRate*gd(layer).weightgradients;
    nn(layer).biases = nn(layer).biases - learningRate*gd(layer).biasgradients;
end