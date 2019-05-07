function normW = gnorm(gd)

%GNORM
%
%   See also...

N_layers = size(gd, 2);

W = [];

for layer = 1:N_layers
    W = [W; gd(layer).biasgradients; gd(layer).weightgradients(:)];
end

normW = norm(W);

end