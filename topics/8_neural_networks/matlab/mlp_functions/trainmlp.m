function nn = trainmlp(X, t, hiddenUnits, varargin)

%TRAINMLP Train a multilayer perceptron using stochastic gradient descent.
%
%   See also...

%% Parse inputs

[X, t, hiddenUnits, learningRate, gradientTol, actFunction, ...
    includeBiases] = parsemlp(X, t, hiddenUnits, varargin{:});

%% Train multilayer perceptron

N = size(X, 1);
D = size(X, 2);
K = size(t, 2);

[nn, gd] = initmlp(D, hiddenUnits, K, actFunction) ;

format short g
normW = gradientTol + 1;
counter = 1;

while normW > gradientTol
    nn = gdescend(nn, gd, learningRate);
    i = randi(N);
    nn = fprop(nn, X(i,:)');
    Error = sum((nn(end).outputs - t(i,:)').^2)/2;
    gd = bprop(nn, gd, t(i,:)', X(i,:)');
    normW = gnorm(gd);
    if mod(counter, 10000) == 0; disp([counter normW Error]); end
    counter = counter + 1;
end

load train; sound(y, Fs);
end