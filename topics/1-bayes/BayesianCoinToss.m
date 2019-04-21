clearvars

%----------Bayesian Coin Toss----------------------------------------------
% A simple example of Bayesian updating using beta conjugate priors
% 1. Formulate a prior belief (beta distribution) over the probability of heads, theta
% 2. Generate a dataset by peforming n coin flips using a fair (or biased) coin and record outcomes.
% 3. Use the data to update the prior by Bayes' Rule (see lec notes). Beta is conjugate to the Bernoulli, so the posterior is also Beta
% 4. Calculate the MAP estimate for theta, using both the analytical formula in this easy case, and numerical methods
%--------------------------------------------------------------------------

% 1.Prior
theta = linspace(0,1,1001)';
a = 2;
b = 2;

prior = betapdf(theta, a, b);

subplot(2,1,1)
plot(theta, prior)
title('Prior')
xlabel('theta')

% 2.Data
n = 3;
x = rand(n,1)<0.5;  % x = ones(n,1)
n1 = sum(x);
n0 = n - n1;

% 3.Posterior
posterior = betapdf(theta, n1+a, n0+b);

subplot(2,1,2)
plot(theta, posterior)
title('Posterior')
xlabel('theta')

% 4.MAP estimator
theta_map = (n1+a-1)/(n0+n1+a+b-2)
theta_mle = n1/n

% fun = @(x)-1*betapdf(x, n1+a, n0+b);
% fmincon(fun, 0.7)