%% BishopFish curve-fitting data
%Recovering training data from the 9th order polynomial in Bishop
clearvars

b = [0.35; 232.37; -5321.83; 48568.31; -231639.30; 640042.26; -1061800.52; 1042400.18; -557682.99; 125201.43];

n = 10;
x = linspace(0,1,n)';

M = 9;
X = repmat(x,1,M+1).^repmat(0:M,n,1);
y = X*b;

%Test data
rng(4);
n1 = 100;
sigma = 0.3;

x1 = linspace(0,1,n1)';
y1 = sin(2*pi*x1) + sigma*randn(n1,1);

%Plot Figure 1.2
subplot(2,1,1)
plot(x,y,'bo')
hold on
plot(linspace(0,1,100), sin(2*pi*linspace(0,1,100)), 'g-')
xlim([-0.05 1.05]); set(gca, 'Xtick', [0 1]);
ylim([-1.5 1.5]); set(gca, 'Ytick', [-1 0 1]);

%% Least Squares
%Fit an Mth order polynomial using LS
M = 8;
X = repmat(x, 1, M+1).^repmat(0:M,n,1);

b = (X'*X)\(X'*y);

X1 = repmat(x1,1,M+1).^repmat(0:M,n1,1);
yhat = X1*b;
plot(x1, yhat, 'r')
hold off

%% RMSE of training and test set for all polynomials up to order M
M = 8;
tr_rmse = nan(M+1,1);
te_rmse = tr_rmse;

for i=0:M
    %Training data
    X = repmat(x, 1, i+1).^repmat(0:i,n,1);
    b = (X'*X)\(X'*y);
    tr_rmse(i+1) = sqrt((y-X*b)'*(y-X*b)/n);
    %Test data
    X1 = repmat(x1,1,i+1).^repmat(0:i,n1,1);
    te_rmse(i+1) = sqrt((y1-X1*b)'*(y1-X1*b)/n1);
end

%Plot Figure 1.5
subplot(2,1,2)
plot(0:M,tr_rmse, 'bo-')
hold on
plot(0:M,te_rmse, 'ro-')
legend('Training','Test','Location','NorthWest');
xlim([-0.5 9.5]); set(gca, 'xtick', [0 3 6 9], 'ytick', [0 0.5 1 1.5]);
hold off