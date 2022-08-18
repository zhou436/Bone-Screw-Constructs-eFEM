function demo1()
% demo1 of voxelMesh
% import 2D image sequences in a folder, and then convert to mesh
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, May 2020

% ---------------------------------------------------------------------
% import image sequences in a folder, e.g. a001.tif, a002.tif, ...
tic
folder_name = 'RF_26_L_Rec';
im = importImSeqs(folder_name);
toc

% ---------------------------------------------------------------------
% parameters
dx = 1; dy = 1; dz = 1; % scale of original 3d image 
                        % dx - column direction, dy - row direction,
                        % dz - vertical direction (slice)

eleType = 'C3D8R';     % element type, for printInp_multiSect
nodePreci = 8; % precision of node coordinates, for output

% ---------------------------------------------------------------------
% preprocess
im = flip(flip(im, 1), 3);

dimYNum = size(im, 1);
dimXNum = size(im, 2);
dimZNum = size(im, 3);    % slice

% get unique intensities from image
intensity = unique(im);     % column vector
toc
% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% eleCell{i}(j,:) = [element_number, phase_number, node_number_of_8_nodes]
% nodeCoor(i,:) = [node_number, x, y, z]

[nodeCoor, eleCell] = voxelMesh(im, intensity, dimXNum, dimYNum, dimZNum);
toc
% ---------------------------------------------------------------------
% export
% scale nodeCoor using dx, dy, dz
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
toc
% generate inp file
% export multi-phases in image as multi-sections in inp file
printInp_multiSect(nodeCoor, eleCell, eleType, nodePreci);

% generate bdf file
printBdf(nodeCoor, eleCell, nodePreci);
toc

end





