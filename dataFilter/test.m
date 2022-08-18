clear all
close all
clc

% filePattern = fullfile(myFolder, '/outputCSV/*.csv'); % Change to whatever pattern you need.
% % filePattern = fullfile(myFolder, '**/*.exe'); % To look in subfolders too, add **/.
theFiles = dir('./outputCSV/*.csv');
parfor ii = 1 : length(theFiles)
    baseFileName = theFiles(ii).name;
    fullFileName = fullfile(theFiles(ii).folder, baseFileName);
    fprintf('Now processing %s\n', fullFileName);
    [expNumDiff1(ii), expNumDiff2(ii)] = dataFilter(theFiles(ii).name);
    name{ii} = theFiles(ii).name(end-6:end-4);
    % Now do whatever you want with this file name,
    % such as running the program with system() or whatever.
end
%%
figure()
plot(expNumDiff1);
hold on
plot(expNumDiff2);
%%
figure()
expNumDiff = [expNumDiff1;expNumDiff2];
scatter(expNumDiff1,expNumDiff2);
hold on
plot([600,2000],[600,2000]);
axis equal