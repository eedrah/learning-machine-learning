clearvars
clc

%% Load data, run EM, Hard cluster
load OldFaithful

N = length(X);
K = 3;

% Scale data
X = X - repmat(mean(X), N, 1);
X = X./repmat(std(X), N, 1);

% Cluster
[GMMClusts, GMMMeans, GMMCovs, GMMCoeffs] = expmax(X, K, 'scaledata', false);

% Hard cluster
[~, HardClust] = max(GMMClusts, [], 2);

% Setup colours (only for K <= 5)
ColKey = [0 0.4470 0.7410; 0.6350 0.0780 0.1840; 0.4660 0.6740 0.1880; 0.4940 0.1840 0.5560; 0.9290 0.6940 0.1250];
Colours = nan(N, 3);
for i = 1:K
    Colours(find(HardClust==i),:) = repmat(ColKey(i,:), sum(HardClust==i), 1);
end

% Scatter plot
scatter(X(:,1), X(:,2), [], Colours)

%% Surface plot (only for K = 3)
x1 = -2.5:0.05:2.5;
x2 = -2.5:0.1:2.5;
[X1,X2] = meshgrid(x1,x2);
XX = [X1(:) X2(:)];

y1 = mvnpdf(XX, GMMMeans(1,:) ,GMMCovs(:,:,1));
y2 = mvnpdf(XX, GMMMeans(2,:) ,GMMCovs(:,:,2));
y3 = mvnpdf(XX, GMMMeans(3,:) ,GMMCovs(:,:,3));
y = [y1 y2 y3]*GMMCoeffs';
y = reshape(y,length(x2),length(x1));

% Subplot
subplot(2,1,1)
scatter(X(:,1), X(:,2), [], Colours)
subplot(2,1,2)
surf(x1, x2, y)
xlim([-2.5 2.5]); ylim([-2.5 2.5])