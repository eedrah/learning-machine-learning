%% Data prep
clearvars -except GoldenSeed  
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
disp('Cumulative proportion of variance')
disp([(1:D)' cumsum(diag(lambda))/sum(diag(lambda))])

Xclust = Xpca(:,1:4);   % Hardcoded

%% GMM Cluster

maxK = 8;
reps = 100;
D = size(Xclust, 2);

storeSeed = rng;
storeAIC = nan(reps, maxK);
storeBIC = nan(reps, maxK);

tic
for k = 1:maxK
    c = k*D + k*D*(D+1)/2 + (k-1);    % Model complexity. Is this correct?
    for i = 1:reps
        storeSeed(i, k) = rng;
        try
            [~, ~, ~, ~, LogLike] = expmax(Xclust, k, 'ScaleData', true, 'MaxIters', 200);
            storeAIC(i,k) = 2*c - 2*LogLike(end);
            storeBIC(i,k) = c*log(N) - 2*LogLike(end);
        catch
            storeAIC(i,k) = nan;
            storeBIC(i,k) = nan;
            continue
        end
    end
end
disp(['Loop time was ', num2str(toc), ' seconds.'])

%% Restore best run (using BIC)

[minAIC, minAICloc] = min(storeAIC);
[minBIC, minBICloc] = min(storeBIC);

Koptimal = 3;   % Hardcoded. This is set based on the AIC/BIC plot, which now comes later
rng(storeSeed(minBICloc(Koptimal), Koptimal))

[GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = ...
    expmax(Xclust, Koptimal, 'ScaleData', true, 'MaxIters', 200);

[~, HardClust] = max(GMMClusts, [], 2);

classAccuracy = sum(class==HardClust)/N;    % Need to auto-match cluster codes
disp(['Classification accuracy is ', num2str(round(100*classAccuracy,1)), '%'])

%% The plot thickens

ColKey = [0 0.4470 0.7410; 0.6350 0.0780 0.1840; 0.4660 0.6740 0.1880];
colors = ColKey(HardClust, :);

subplot(3,2,1)
    plot(LogLike)
    title('Log likelihood'); xlabel('EM iterations')

subplot(3,2,2)
    plot(minAIC)
    hold on
    plot(minBIC)
    legend('AIC','BIC', 'location', 'NE')
    title('AIC/BIC'); xlabel('No of components/clusters'); xlim([1 maxK])

subplot(3,2,3)
    scatter(Xpca(:,1), Xpca(:,2), [], colors, 'filled')
    title('PCA biplot');
    xlabel('Principal component 1'); ylabel('Principal component 2')
    
subplot(3,2,4)
    scatter3(Xpca(:,1), Xpca(:,2), Xpca(:,3), [], colors)
    title('PCA triplot')
    
subplot(3,2,5)

subplot(3,2,6)