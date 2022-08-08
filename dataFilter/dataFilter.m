clear all
close all
clc
%% load virtual numerical data and filter
dispFCurve = readmatrix('dataOutput_74.csv');
windowSize = 19; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
dispFFil = filter(b,a,dispFCurve(:,2));
figure(1);
plot(dispFCurve(:,1),dispFCurve(:,2));
hold on
plot(dispFCurve(:,1),dispFFil);
dispFCurve(:,2) = dispFFil;
%% read experimental data
experimentalData = readmatrix('ExperimentalData.xlsx');
experimentalData(1:3,:) = [];
%% change the data points number
numDispMax = max(dispFCurve(:,1));
dataNum = size(dispFCurve,1);
dataPointDisp = linspace(0,numDispMax,dataNum)';
dataPointExpForce = interp1(experimentalData(:,1),experimentalData(:,2),dataPointDisp);
dataPointNumForce = interp1(dispFCurve(:,1),dispFCurve(:,2),dataPointDisp);
% plot
figObjDiff = figure(2);
plot(dataPointDisp, dataPointExpForce);
hold on
plot(dataPointDisp, dataPointNumForce);
hold off
%% project numerical data to experimental data
fun = @(x)(sum((dataPointExpForce(floor(x):end)-dataPointNumForce(1:dataNum-floor(x)+1)).^2))^0.5/numDispMax;
x1 = 5;
x2 = 50;
options = optimset('Display','iter','PlotFcns',@optimplotfval,'TolX',0.5);
[x,fval] = fminbnd(fun,x1,x2,options);
%%
figure(3);
plot(dataPointDisp(1:dataNum-floor(x)+1), dataPointExpForce(floor(x):end));
hold on
plot(dataPointDisp, dataPointNumForce);
hold off
%% calculate the mean squate error
expNumDiff = (sum((dataPointExpForce-dataPointNumForce).^2))^0.5/numDispMax;