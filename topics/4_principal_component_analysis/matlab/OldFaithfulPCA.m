load OldFaithful

%% Scale data

N = size(X, 1);
D = size(X, 2);
Xscaled = X - repmat(mean(X), N, 1);
Xscaled = Xscaled./repmat(std(Xscaled), N, 1);

%% Maximum variance PCA

S = cov(Xscaled);
[U, lambda] = eig(S);

%% Sort eigenvalues/vectors (dominant first)

U = sortrows([diag(lambda) U'], -1);
lambda = diag(U(:,1));
U = U(:,2:end)';

%% Compute principal components

Xpca1 = Xscaled*U(:,1);
Xpca2 = Xscaled*U(:,2);

Xpca1vec = repmat(U(:,1)', N, 1).*repmat(Xpca1, 1, D);
Xpca2vec = repmat(U(:,2)', N, 1).*repmat(Xpca2, 1, D);

%% Plot

axisLims = [-2.5 2.5];
x1 = linspace(axisLims(1), axisLims(2), 100);
y1 = U(2,1)/U(1,1)*x1;
y2 = U(2,2)/U(1,2)*x1;

% Scatter raw data (scaled)
scatter(Xscaled(:,1), Xscaled(:,2), '.')
xlim(axisLims); ylim(axisLims)
axis square
hold on

% First principal component
plot(x1, y1, 'r')
plot(Xpca1vec(:,1), Xpca1vec(:,2), 'k.')

% Second principal component
plot(x1, y2, 'r')
plot(Xpca2vec(:,1), Xpca2vec(:,2), 'k.')

figure
scatter(-Xpca1, -Xpca2, '.')
hold on
plot([0 0], axisLims, 'r'); plot(axisLims, [0 0], 'r')
scatter(-Xpca1, zeros(N, 1), 'k.'); scatter(zeros(N, 1), -Xpca2, 'k.');
xlim(axisLims); ylim([-1 1])