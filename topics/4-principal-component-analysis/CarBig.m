%% Data prep
clearvars
clc

load carbig
X = [Cylinders, MPG,Acceleration,Displacement,Weight,Horsepower];
X(any(isnan(X), 2), :) = [];
Cylinders = X(:,1); X = X(:,2:end);
varNames = {'MPG'; 'Acceleration'; 'Displacement'; 'Weight'; 'Horsepower'};
clearvars -except X Cylinders varNames

%% Plot

figure
gplotmatrix(X,[],Cylinders,['c' 'b' 'm' 'g' 'r'],[],[],false);
text([.08 .24 .43 .66 .83], repmat(-.1,1,5), varNames, 'FontSize',8);
text(repmat(-.12,1,5), [.86 .62 .41 .25 .02], varNames, 'FontSize',8, 'Rotation',90);

%% Scale data

N = size(X, 1);
D = size(X, 2);
Xscaled = X - repmat(mean(X), N, 1);
Xscaled = X./repmat(std(X), N, 1);

%% PCA

S = cov(Xscaled);
[U, lambda] = eig(S);

U = sortrows([diag(lambda) U'], -1);
lambda = diag(U(:,1));
U = U(:,2:end)';

Xpca = Xscaled*U;

%% Plot

figure
scatter(Xpca(:,1), Xpca(:,2)) 