function [expNumDiff1, expNumDiff2] = dataFilter(fileName)
%% load virtual numerical data and filter
dispFCurve = readmatrix(sprintf('./outputCSV/%s',fileName));
x1 = 5;
x2 = 40;
options = optimset('TolX',0.1);
func = @(k) funDataFilterObj(k,dispFCurve);
[windowSize,~] = fminbnd(func,x1,x2,options);
[dispFFil] = funDataFilter(floor(windowSize),dispFCurve);
fig1 = figure(1);
plot(dispFCurve(:,1),dispFCurve(:,2));
hold on
plot(dispFCurve(:,1),dispFFil);
% dispFCurve(:,2) = dispFFil;
hold on

%% read experimental data
experimentalData = readmatrix('ExperimentalData.xlsx');
experimentalData(1:3,:) = [];
%% change the data points number
numDispMax = max(dispFCurve(:,1));
dataNum = size(dispFCurve,1);
dataPointDisp = linspace(0,numDispMax,dataNum)';
dataPointExpForce = interp1(experimentalData(:,1),experimentalData(:,2),dataPointDisp);
dataPointNumForce = interp1(dispFCurve(:,1),dispFFil,dataPointDisp);
% plot
% fig2 = figure(2);
% plot(dataPointDisp, dataPointExpForce);
% hold on
% plot(dataPointDisp, dataPointNumForce);
% hold off
% saveas(fig2,sprintf('./figures/%s_2.png',fileName(1:end-4)));
%% project numerical data to experimental data
fun = @(x)(sum((dataPointExpForce(floor(x):end)-dataPointNumForce(1:dataNum-floor(x)+1)).^2))^0.5/numDispMax;
x1 = 0;
x2 = 20;
options = optimset('TolX',0.5);
[x,fval] = fminbnd(fun,x1,x2,options);
%%
% fig3 = figure(3);
plot(dataPointDisp(1:dataNum-floor(x)+1), dataPointExpForce(floor(x):end));
hold on
% plot(dataPointDisp, dataPointNumForce);
hold off
saveas(fig1,sprintf('./figures/%s_1.png',fileName(1:end-4)));
%% calculate the mean squate error
dataPointNumForce = interp1(dispFCurve(:,1),dispFCurve(:,2),dataPointDisp);
expNumDiff1 = (sum((dataPointExpForce-dataPointNumForce).^2))^0.5/numDispMax;
dataPointNumForce = interp1(dispFCurve(:,1),dispFFil,dataPointDisp);
expNumDiff2 = (sum((dataPointExpForce(floor(x):end)-dataPointNumForce(1:dataNum-floor(x)+1)).^2))^0.5/numDispMax;
end
%% numerical data filter
function [dispFFil] = funDataFilter(windowSize,dispFCurve)
b = (1/windowSize)*ones(1,windowSize);
a = 1;
dispFFil = filter(b,a,dispFCurve(:,2));
end
%% data filter objective
function [obj] = funDataFilterObj(windowSize,dispFCurve)
windowSize = floor(windowSize);
b = (1/windowSize)*ones(1,windowSize);
a = 1;
dispFFil = filter(b,a,dispFCurve(:,2));
obj = sum(abs(dispFFil));
end

