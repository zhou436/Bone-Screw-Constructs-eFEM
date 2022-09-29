clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'printInpTemp010Ben.inp';
data = abaqusInpRead(fileName);
%% plot nodes
scatter3(data.Nodes{1,1}(:,2),data.Nodes{1,1}(:,3),data.Nodes{1,1}(:,4));
axis equal
hold on
scatter3(data.Nodes{1,2}(:,2),data.Nodes{1,2}(:,3),data.Nodes{1,2}(:,4));
axis equal