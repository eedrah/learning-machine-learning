%% Import data
filename = 'C:\Users\passih\MATLAB\Sandbox\Complexity\00_Datasets\SyntheticClustering\S_sets\s1.txt';
delimiter = '\t';
formatSpec = '%f%f%[^\n]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

s1 = [dataArray{:, 1} dataArray{:, 2}];

clearvars filename delimiter formatSpec fileID dataArray ans;

%% Cluster
clearvars -except s1 MaxSoFar GMMClusts; clc

[GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = expmax(s1, 15, 'scaledata', true, 'maxiters', 200);
disp(LogLike(end))
[~, HardClust] = max(GMMClusts, [], 2);

ColKey =   [0 0.4470 0.7410 
            0.6350 0.0780 0.1840
            0.4660 0.6740 0.1880
            0.4940 0.1840 0.5560
            0.9290 0.6940 0.1250
            0.8500 0.3250 0.0980
            0.3010 0.7450 0.9330
            0 0 1
            0 0.5 0
            0.75 0.75 0
            0.25 0.25 0.25
            1 0 0
            0 1 0
            0.5 0.5 0
            1 1 0];
            
Colors = nan(length(s1), 3);
for i = 1:length(Colors)
    Colors(i, :) = ColKey(HardClust(i), :);
end

subplot(2,1,1)
scatter(s1(:,1), s1(:,2), [], Colors)
subplot(2,1,2)
plot(LogLike)

