clear all
close all
clc
%% Example 01
% figure(1)

% fileName = 'printInpTemp.inp';
% fileName = 'Job-Boolean.inp';
% data = abaqusInpRead(fileName);
%% plot nodes
load boneMesh.mat
load screwMesh.mat
%% plot hex mesh
screwMove = [-1, 1, -3];
screwData.Nodes(:,2) = screwData.Nodes(:,2)+screwMove(1);
screwData.Nodes(:,3) = screwData.Nodes(:,3)+screwMove(2);
screwData.Nodes(:,4) = screwData.Nodes(:,4)+screwMove(3);
screwBoneMeshVox = figure();
plotMesh(boneData.Elements(:,2:9), boneData.allNodes, 0.5, '-');
hold on
plotMesh(screwData.Elements(:,2:11), screwData.Nodes, 0.5, 'none');
xlim([-1, inf]);
view(240,30);
% saveas(screwBoneMeshVox, 'screwBoneMeshVox.png');
%%
outerRadius = 2.0; % Outter Radius 2.0 mm
innerRadius = 0.95; % Inner Radius 0.95 mm
toDelEles = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove);

boneData.Elements(toDelEles,:) = [];
%%
screwBoneMeshVoxBoolean = figure();
plotMesh(boneData.Elements(:,2:9), boneData.allNodes, 1, '-');
hold on
plotMesh(screwData.Elements(:,2:11), screwData.Nodes, 1, 'none');

xlabel('x');
ylabel('y');
zlabel('z');

xlim([-1, inf]);
% ylim([1, inf]);
view(240,30);

saveas(screwBoneMeshVoxBoolean, 'screwBoneMeshVoxBoolean.png');







