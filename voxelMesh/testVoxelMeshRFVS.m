clear all
close all
clc
%%
% Part source code and ideas based on Jiexian Ma (2022). voxelMesh (voxel-based mesh)
% (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh)
% MATLAB Central File Exchange. Last Access 202207
tic
%% load bone micro-CT
folder_name = 'RF_21_L_VOI';
pixelSize = 11.95/1000; % unit: mm, same as Abaqus unit
scaleFac = 0.05; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
im = importImSeqs(folder_name);

%% rescale image size, for low resolution models
imSca = imresize3(im, scaleFac);
imSca(imSca<=27)=0;
imSca(imSca>=27 & imSca<=100)=1;
imSca(imSca>=100)=255;
imSca(imSca==1)=125;
pixelSizeSca = pixelSize/scaleFac;
imSca = permute(imSca,[1,2,3]);
% volshow(imSca);
%% image size
dx = pixelSizeSca;
dy = pixelSizeSca;
dz = pixelSizeSca;  % Scaled pixel size in x, y, z direction, usually same
% dx - column direction, dy - row direction,
% dz - vertical direction (slice)

% preprocess
imSca = flip(imSca, 1);

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
nodeCoorUniBone = nodeCoor(unique(reshape(eleCell{2,1}(:,3:10),[],1)),:);
nodeCoorUniScrew = nodeCoor(unique(reshape(eleCell{3,1}(:,3:10),[],1)),:);
%%
abaData.Bone.Nodes = nodeCoorUniBone;
abaData.Screw.Nodes = nodeCoorUniScrew;
abaData.Bone.Elements = eleCell{2,1}(:,[1 3:10]);
abaData.Screw.Elements = eleCell{3,1}(:,[1 3:10]);
clear eleCell nodeCoorUniBone nodeCoorUniScrew
toc

%% Output Abaqus files
abaData = abaInpData(abaData); % basic abaqus settings
fileName = 'printInpTemp';     
nodeS = abaInp(fileName, abaData); % generate inp file
toc
%% plot mesh
screwBoneMesh = figure(2);
plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
% volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on;
scatter3(nodeCoor(nodeS{1},2), nodeCoor(nodeS{1},3), nodeCoor(nodeS{1},4));
hold on
scatter3(nodeCoor(nodeS{2},2), nodeCoor(nodeS{2},3), nodeCoor(nodeS{2},4));
hold on
% plot screw

plotMesh(abaData.Screw.Elements(:,2:9), nodeCoor, 1, 'none'); % 'none' for no edges
% volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on;

% plot labels
xlabel('x');
ylabel('y');
zlabel('z');

xlim([0, inf]);
% ylim([0, inf]);
view(240,30);

% axis equal
saveas(screwBoneMesh, 'screwBoneMeshVox.png');
% zlim([0, inf]);

% toc
%% run abaqus simulation
a = "abaqus job=printInpTemp double cpus=24";

