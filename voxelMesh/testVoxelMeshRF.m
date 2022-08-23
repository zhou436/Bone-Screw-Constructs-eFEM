clear all
close all
clc
%%
% Part source code and ideas based on Jiexian Ma (2022). voxelMesh (voxel-based mesh) 
% (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh)
% MATLAB Central File Exchange. Last Access 202207
tic
%% based information
folder_name = 'RF_20_R_VOI';
pixelSize = 11.953001/1000; % unit: mm, same as Abaqus unit
scaleFac = 0.1; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
im = importImSeqs(folder_name);

%% rescale image size, for low resolution models
imSca = imresize3(im, scaleFac);
imSca(imSca<=100)=0;
imSca(imSca>=100)=255;
pixelSizeSca = pixelSize/scaleFac;
imSca = permute(imSca,[3,1,2]);
abaData.Parts = {{'screw'},{'Bone'}};
% volshow(imSca);
%% image size
dx = pixelSizeSca; 
dy = pixelSizeSca; 
dz = pixelSizeSca;  % Scaled pixel size in x, y, z direction, usually same
                    % dx - column direction, dy - row direction,
                    % dz - vertical direction (slice)
nodePreci = 8;      % precision of node coordinates, for output

% preprocess
imSca = flip(flip(imSca, 1), 3);

dimYNum = size(imSca, 1);
dimXNum = size(imSca, 2);
dimZNum = size(imSca, 3);    % slice

% get unique intensities from image
intensity = unique(imSca);     % column vector
% intensity = 255;            % user defined intensity
% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% eleCell{i}(j,:) = [element_number, phase_number, node_number_of_8_nodes]
% nodeCoor(i,:) = [node_number, x, y, z]
% toc
%%
[nodeCoor, eleCell] = voxelMesh(imSca, intensity, dimXNum, dimYNum, dimZNum);

% export
% scale nodeCoor using dx, dy, dz
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
toc
%% Output Abaqus files
abaData = abaInpData(abaData); % basic abaqus settings
% % generate inp file
% fileName = 'printInpTemp';     
% abaInp(nodeCoor, eleCell{2,1}, nodePreci, fileName, abaData);
% toc
%% plot mesh
% plotMesh(eleCell{2,1}(:,3:10), nodeCoor, 1, '-'); % 'none' for no edges
volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on
% Load screw data and plot
load ScrewCube.mat
plotMesh(screwCubeData.Elements{1,2}, screwCubeData.Nodes{1,2}, 1, 'none');
xlabel('x');
ylabel('y');
zlabel('z');

xlim([0, inf]);
ylim([0, inf]);
zlim([0, inf]);

% toc

