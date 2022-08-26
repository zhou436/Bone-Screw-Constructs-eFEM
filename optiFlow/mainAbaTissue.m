function abaControl(abaData)
% clear all
% close all
% clc
%%
addpath('./../voxelMesh');
%% load bone mesh
load boneMesh.mat
abaData.Bone.Nodes = boneData.Nodes;
abaData.Bone.Elements = boneData.Elements;
nodeCoor = boneData.allNodes;
clear boneData

%% load screw mesh
load screwMesh.mat
abaData.Screw.Elements = screwData.Elements;
abaData.Screw.Nodes = screwData.Nodes;
% move the screw a bit [-2,2,-4]
screwMove = [-1, 1, -3];
abaData.Screw.Nodes(:,2) = abaData.Screw.Nodes(:,2)+screwMove(1);
abaData.Screw.Nodes(:,3) = abaData.Screw.Nodes(:,3)+screwMove(2);
abaData.Screw.Nodes(:,4) = abaData.Screw.Nodes(:,4)+screwMove(3);
clear screwData;
%% Set initial parameters for bone material
abaData.Bone.MAT.vaEL = [10000, 0.3]; % Young's modulus and Poisson's ratio
% abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
abaData.Bone.MAT.comp.sigmaY = 100;         % compression yield stress [MPa]
abaData.Bone.MAT.comp.sigmaUYD = 20;        % compression ultimate stress [MPa]
abaData.Bone.MAT.comp.epsilonU = 0.02;      % compression ultimate strain [-]
abaData.Bone.MAT.comp.epsilonF = 0.05;      % compression failure (deletion) strain [-]
abaData.Bone.MAT.tens.sigmaY = 50;          % tension yield stress [MPa]
abaData.Bone.MAT.tens.epsilonF = 0.01;      % tension failure (deletion) strain [-]

%% Output Abaqus files
abaData = abaInpData(abaData); % basic abaqus settings
fileName = 'printInpTemp';     
nodeSide = abaInp(fileName, abaData); % generate inp file
% toc
%% plot mesh
screwBoneMesh = figure(1);
plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
% volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on;
scatter3(nodeCoor(nodeSide,2), nodeCoor(nodeSide,3), nodeCoor(nodeSide,4));
hold on
% Load screw data and plot

plotMesh(abaData.Screw.Elements(:,2:11), abaData.Screw.Nodes, 1, 'none');
xlabel('x');
ylabel('y');
zlabel('z');

saveas(screwBoneMesh, 'screwBoneMesh.png');
% xlim([0, inf]);
% ylim([0, inf]);
% zlim([0, inf]);
%% run abaqus simulation
a = "abaqus job=printInpTemp double cpus=24";
end