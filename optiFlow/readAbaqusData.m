function [expNumDiff] = readAbaqusData(counteval)
%%
% counteval = 1;
% clear all
% close all
% clc
% counteval = 1;
%%
system('DEL /Q Displacement.csv');
system('DEL /Q Rotation.csv');
system('DEL /Q Force.csv');
system('abaqus cae noGUI=dataExport.py');
%% basic info
% displacement = 5; %5 mm

%% Numerical data
% abaqusDisp(1,:) = [];

abaqusDisp = readmatrix('Displacement.csv');
abaqusRot = readmatrix('Rotation.csv');
abaqusForce = readmatrix('Force.csv');

numDispMax = max(abaqusDisp(:,2));
% plot(abaqusDisp(:,2),abaqusForce(:,2));
% hold on
%% solve the displacement output precision problem
[~, ia, ~] = unique(abaqusDisp(:,2),'stable');
abaqusDisp = abaqusDisp(ia,:);
abaqusRot = abaqusRot(ia,:);
abaqusForce = abaqusForce(ia,:);
dataNum = size(abaqusDisp,1);
%% read experimental data
experimentalData = readmatrix('ExperimentalData.xlsx');
experimentalData(1:3,:) = [];
% plot(experimentalData(:,1),experimentalData(:,2));
% plot
%% change the data points number
dataPointDisp = linspace(0,numDispMax,dataNum)';
dataPointExpForce = interp1(experimentalData(:,1),experimentalData(:,2),dataPointDisp);
dataPointNumForce = interp1(abaqusDisp(:,2),abaqusForce(:,2),dataPointDisp);
dataPointNumRot = interp1(abaqusDisp(:,2),abaqusRot(:,2),dataPointDisp);
% plot
figObjDiff = figure();
plot(dataPointDisp, dataPointExpForce);
hold on
plot(dataPointDisp, dataPointNumForce);
hold off
saveas(figObjDiff,sprintf('./figures/figObjDiff_%d.png',counteval));
close all
%% Calculate the square difference between numerical data and experimental data
expNumDiff = (sum((dataPointExpForce-dataPointNumForce).^2))^0.5/numDispMax;
disp('Objective value:');
disp(expNumDiff);
%% copy output to subfolder dataOutput
dataMatrixSum = [dataPointDisp,dataPointNumForce,dataPointNumRot];
writematrix(dataMatrixSum,sprintf('./dataOutput/dataOutput_%d.csv',counteval));
%% delete all files
system('DEL /Q Displacement.csv');
system('DEL /Q Rotation.csv');
system('DEL /Q Force.csv');
end