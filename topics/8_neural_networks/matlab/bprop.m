function gd = bprop(nn, gd, t, X)

%BPROP
%
%   See also...

% Parse inputs

% Back propagate

N_layers = size(nn, 2);

gd(end).predeltas = nn(end).outputs - t;
gd(end).deltas = nn(end).dactfn(nn(end).activations).*gd(end).predeltas;
gd(end).weightgradients = gd(end).deltas*nn(end-1).outputs';
gd(end).biasgradients = gd(end).deltas;

for layer = (N_layers-1):-1:2
    gd(layer).predeltas = nn(layer+1).weights'*gd(layer+1).deltas;
    gd(layer).deltas = nn(layer).dactfn(nn(layer).activations).*gd(layer).predeltas;
    gd(layer).weightgradients = gd(layer).deltas*nn(layer-1).outputs';
    gd(layer).biasgradients = gd(layer).deltas;
end

gd(1).predeltas = nn(2).weights'*gd(2).deltas;
gd(1).deltas = nn(1).dactfn(nn(1).activations).*gd(1).predeltas;
gd(1).weightgradients = gd(1).deltas*X';
gd(1).biasgradients = gd(1).deltas;

end