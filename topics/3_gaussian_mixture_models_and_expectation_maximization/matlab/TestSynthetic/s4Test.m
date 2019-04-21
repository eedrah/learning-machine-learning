%% Import data
filename = 'C:\Users\passih\MATLAB\Sandbox\Complexity\Gaussian Mixture Models and EM\TestSynthetic\s4.txt';
delimiter = '\t';
formatSpec = '%f%f%[^\n]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

s4 = [dataArray{:, 1} dataArray{:, 2}];

clearvars filename delimiter formatSpec fileID dataArray ans;

%% Cluster
clearvars -except s4; clc

[GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = expmax(s4, 15);
disp(LogLike(end))
[~, HardClust] = max(GMMClusts, [], 2);

subplot(2,1,1)
scatter(s4(:,1), s4(:,2), [], HardClust, '.')
subplot(2,1,2)
plot(LogLike)