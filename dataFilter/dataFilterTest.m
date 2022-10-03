clear all
close all
clc
%%
dispFCurve = readmatrix('dataOutput_1.csv');

%% 
filterSize = 19;
figure(1);
plot(dispFCurve(:,1),dispFCurve(:,2));
hold on
% figure(2);
% plot(dispFCurve(:,1),dispFCurve(:,3));
dispFMA = movmean(dispFCurve(filterSize:end,2),filterSize);

plot(dispFCurve(:,1),[dispFCurve(1:filterSize-1,2);dispFMA]);
%%
dispFFFT = fft(dispFCurve(:,2));
plot(abs(dispFFFT));
%%
figure()
dispFFFT = abs(fft(dispFCurve(:,2)));
fftpts=length(dispFFFT);
hpts=fftpts/2;
dispFFFT_scaled=dispFFFT/hpts;
plot(dispFFFT_scaled);
hold on
dispFMAFFT = abs(fft(dispFMA));
fftpts=length(dispFMAFFT);
hpts=fftpts/2;
dispFMAFFT_scaled=dispFMAFFT/hpts;
plot(dispFMAFFT_scaled);
%%

% dispFFFT = fft(dispFCurve(:,2));
windowSize = 19; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
y = filter(b,a,dispFCurve(:,2));
figure(2);
plot(dispFCurve(:,1),dispFCurve(:,2));
hold on
plot(dispFCurve(:,1),y);
