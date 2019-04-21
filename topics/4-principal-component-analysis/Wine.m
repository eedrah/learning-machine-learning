%% Data prep

clearvars
clc

X = csvread('Wine.csv');
class = X(:,1); X = X(:,2:end);
varNames = {'Alcohol','Malic acid','Ash','Alcalinity of ash','Magnesium', ...
            'Total phenols','Flavanoids','Nonflavanoid phenols', ...
            'Proanthocyanins','Color intensity','Hue', ...
            'OD280/OD315 of diluted wines','Proline'};

%% Scale data

N = size(X, 1);
D = size(X, 2);
Xscaled = X - repmat(mean(X), N, 1);
Xscaled = Xscaled./repmat(std(X), N, 1);

%% PCA

S = cov(Xscaled);
[U, lambda] = eig(S);

U = sortrows([diag(lambda) U'], -1);
lambda = diag(U(:,1));
U = U(:,2:end)';

Xpca = Xscaled*U;

%% Plot

scatter(-Xpca(:,1), Xpca(:,2), 'filled')