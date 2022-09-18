clear all
close all
clc
%%
% Part source code and ideas based on Jiexian Ma (2022). voxelMesh (voxel-based mesh)
% (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh)
% MATLAB Central File Exchange. Last Access 202207
tic
%% load bone micro-CT
folder_name = 'RF_20_R_VOIs';
pixelSize = 11.953001/1000; % unit: mm, same as Abaqus unit
scaleFac = 0.25; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
im = importImSeqs(folder_name);
%% load Screw mesh
load screwMesh.mat
abaData.Screw.Elements = screwData.Elements;
abaData.Screw.Nodes = screwData.Nodes;
% move the screw a bit [-2,2,-4]
screwMove = [-1, 1, -3];
abaData.Screw.Nodes(:,2) = abaData.Screw.Nodes(:,2)+screwMove(1);
abaData.Screw.Nodes(:,3) = abaData.Screw.Nodes(:,3)+screwMove(2);
abaData.Screw.Nodes(:,4) = abaData.Screw.Nodes(:,4)+screwMove(3);
clear screwData;
%% rescale image size, for low resolution models
imSca = imresize3(im, scaleFac);
imSca(imSca<=100)=0;
imSca(imSca>=100)=255;
pixelSizeSca = pixelSize/scaleFac;
imSca = permute(imSca,[3,1,2]);
% volshow(imSca);
%% image size
dx = pixelSizeSca;
dy = pixelSizeSca;
dz = pixelSizeSca;  % Scaled pixel size in x, y, z direction, usually same
% dx - column direction, dy - row direction,
% dz - vertical direction (slice)

% preprocess
imSca = flip(flip(imSca, 1), 3);

dimYNum = size(imSca, 1);
dimXNum = size(imSca, 2);
dimZNum = size(imSca, 3);    % slice

% get unique intensities from image
intensity = unique(imSca);     % column vector
% intensity = 255;            % user defined intensity
% toc
%% Generate voxel mesh from micro-CT images
[nodeCoor, eleCell] = voxelMesh(imSca, intensity, dimXNum, dimYNum, dimZNum);
% scale nodeCoor using dx, dy, dz (from 1,1,1 to pixel size)
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
%% clean nodes
% nodes are double, memory consumed!
nodeCoorUni = nodeCoor(unique(reshape(eleCell{2,1}(:,3:10),[],1)),:);
abaData.Bone.Nodes = nodeCoorUni;
abaData.Bone.Elements = eleCell{2,1}(:,[1 3:10]);
clear eleCell nodeCoorUni
toc

%% do boolean operation!
addpath('C:\Users\zyj19\Desktop\Git\pullOutSimulation\meshBoolean');
boneData = abaData.Bone;
boneData.allNodes = nodeCoor;
screwData = abaData.Screw;
outerRadius = 2.0; % Outter Radius 2.0 mm
innerRadius = 0.95; % Inner Radius 0.95 mm
toDelEles = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove);
boneData.Elements(toDelEles,:) = [];
% toc

%%
% screwBoneMeshVoxBoolean = figure();
% plotMesh(boneData.Elements(:,2:9), boneData.allNodes, 1, '-');
% hold on
% plotMesh(screwData.Elements(:,2:11), screwData.Nodes, 1, 'none');
% 
% xlabel('x');
% ylabel('y');
% zlabel('z');
% 
% xlim([-1, inf]);
% % ylim([1, inf]);
% view(240,30);
% 
% % saveas(screwBoneMeshVoxBoolean, 'screwBoneMeshVoxBoolean.png');
%% Output Abaqus files
abaData.Bone.Elements(toDelEles,:) = [];
abaData = abaInpData(abaData); % basic abaqus settings
fileName = 'printInpTemp';     
nodeS = abaInp(fileName, abaData); % generate inp file
toc
%% plot mesh
screwBoneMesh = figure(1);
plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
% volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on;
scatter3(nodeCoor(nodeS,2), nodeCoor(nodeS,3), nodeCoor(nodeS,4));
hold on
% Load screw data and plot

plotMesh(abaData.Screw.Elements(:,2:11), abaData.Screw.Nodes, 0.5, 'none');

% plot labels
xlabel('x');
ylabel('y');
zlabel('z');

xlim([-1, inf]);
% ylim([0, inf]);
view(240,30);

% saveas(screwBoneMesh, 'screwBoneMesh.png');
%% run abaqus simulation
a = "abaqus job=printInpTemp double cpus=24";

