Ntrain = size(X, 1);
YhatTrain = nan(Ntrain, 10);

for j = 1:Ntrain
    nn1 = fprop(nn, X(j,:)');
    YhatTrain(j,:) = nn1(end).outputs';
end

[~, temp] = max(YhatTrain, [], 2);
temp(temp==10) = 0;
[(1:Ntrain)' t temp (temp==t)]

sum(temp==t)/Ntrain

%% Load and prep test set

% Load
testData = csvread('MNIST_data_test.csv', 1, 0);
testTarget = csvread('MNIST_target_test.csv', 1, 0);
testData = [testTarget testData];

% Shuffle
testData = testData(randperm(size(testData,1)), :);
classTest = testData(:,1); Xtest = testData(:,2:end);
Ntest = size(testData, 1);

% Scale
Xtest = Xtest - repmat(mean(Xtest), Ntest, 1);
Xtest = Xtest./repmat(std(Xtest), Ntest, 1);
Xtest(isnan(Xtest)) = 0;

%% Evaluate test set

Ntest = size(Xtest, 1);
YhatTest = nan(Ntest, 10);

for j = 1:Ntest
    nn1 = fprop(nn, Xtest(j,:)');
    YhatTest(j,:) = nn1(end).outputs';
end

[~, YhatClass] = max(YhatTest, [], 2);
YhatClass(YhatClass==10) = 0;

[(1:Ntest)' classTest YhatClass (YhatClass==classTest)]

sum(YhatClass==classTest)/Ntest
