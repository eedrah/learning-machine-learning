%% Load and shuffle data

addpath('C:\Users\passih\git\learning-machine-learning\data\raw\mnist_digits\')

data = csvread('MNIST_data_train.csv', 1, 0);
target = csvread('MNIST_target_train.csv', 1, 0);
data = [target data]; clearvars target;

data = data(randperm(size(data,1)), :);
t = data(:,1); X = data(:,2:end);

%% Prep input and output data for training

X = scale(X);

t_dummy = t; t_dummy(t==0) = 10; t_dummy = dummyvar(t_dummy);

%% Train multilayer perceptron

tic
nn = trainmlp(X, t_dummy, [16 16], 'actfunction', 'logistic',...
                                'learningrate', 0.01, 'gradienttol', 1e-5);
toc/60
                            
%% Evaluate training set 

N_train = size(data, 1);
yhat_train = nan(N_train, 10);

for i = 1:N_train
    nn = fprop(nn, X(i,:)');
    yhat_train(i,:) = nn(end).outputs';
end

[~, train_class] = max(yhat_train, [], 2);
train_class(train_class==10) = 0;

disp([(1:N_train)' t train_class (train_class==t)])

train_accuracy = sum(train_class==t)/N_train;
disp(train_accuracy)

%% Load and prep test set

% Load
test_data = csvread('MNIST_data_test.csv', 1, 0);
test_target = csvread('MNIST_target_test.csv', 1, 0);
test_data = [test_target test_data]; clearvars test_target;

% Shuffle
test_data = test_data(randperm(size(test_data,1)), :);
t_test = test_data(:,1); X_test = test_data(:,2:end);

% Scale
X_test = scale(X_test);

%% Evaluate test set

N_test = size(test_data, 1);
yhat_test = nan(N_test, 10);

for i = 1:N_test
    nn = fprop(nn, X_test(i,:)');
    yhat_test(i,:) = nn(end).outputs';
end

[~, test_class] = max(yhat_test, [], 2);
test_class(test_class==10) = 0;

disp([(1:N_test)' t_test test_class (test_class==t_test)])

test_accuracy = sum(test_class==t_test)/N_test;
disp(test_accuracy)

%% Plot a given observation, i

i = 9980;
X_plot = test_data(i, 2:end)';
X_plot = reshape(X_plot, 28, 28); image(X_plot');
axis square; axis off;
colormap(gray(256));
disp([t_test(i) test_class(i)])
