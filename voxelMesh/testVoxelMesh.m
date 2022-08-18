clear all
close all
clc
%%
% Part source code and ideas based on Jiexian Ma (2022). voxelMesh (voxel-based mesh) 
% (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh)
% MATLAB Central File Exchange. Last Access 202207
tic
% ---------------------------------------------------------------------
% import image sequences in a folder, e.g. a001.tif, a002.tif, ...
folder_name = 'RF_26_L_Rec';
im = importImSeqs(folder_name);
im = imresize3(im, 0.2);
%%
% im(im<=50)=0;
% im(im>=50)=255;
%%
% ---------------------------------------------------------------------
% parameters % to be modified
dx = 1; dy = 1; dz = 1; % scale of original 3d image 
                        % dx - column direction, dy - row direction,
                        % dz - vertical direction (slice)
fileName = 'trabBone';
eleType = 'C3D8';     % element type, for printInp_multiSect % C3D8R reduced integration point
nodePreci = 8; % precision of node coordinates, for output

% ---------------------------------------------------------------------
% preprocess
im = flip(flip(im, 1), 3);

dimYNum = size(im, 1);
dimXNum = size(im, 2);
dimZNum = size(im, 3);    % slice

% get unique intensities from image
intensity = unique(im);     % column vector
% intensity = 255;            % user defined intensity
% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% eleCell{i}(j,:) = [element_number, phase_number, node_number_of_8_nodes]
% nodeCoor(i,:) = [node_number, x, y, z]
% toc
[nodeCoor, eleCell] = voxelMesh(im, intensity, dimXNum, dimYNum, dimZNum);

% ---------------------------------------------------------------------
% export
% scale nodeCoor using dx, dy, dz
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
toc
% generate inp file
% export multi-phases in image as multi-sections in inp file
printInp(nodeCoor, eleCell, eleType, nodePreci, fileName);
toc
%% plot mesh

plotMesh(eleCell{2,1}(:,3:10), nodeCoor);
axis equal
% toc







