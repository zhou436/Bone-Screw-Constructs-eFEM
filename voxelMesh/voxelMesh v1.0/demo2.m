function demo2()
% demo2 of voxelMesh
% import a 3D image stack, and then convert to mesh
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, May 2020

% ---------------------------------------------------------------------
% import 3D image stack cotaining all image sequences
file_name = 'b.tif';
im = importImStack(file_name);

% ---------------------------------------------------------------------
% parameters
dx = 1; dy = 1; dz = 1; % scale of original 3d image 
                        % dx - column direction, dy - row direction,
                        % dz - vertical direction (slice)

ele_type = 'C3D8R';     % element type, for printInp_multiSect
precision_nodecoor = 8; % precision of node coordinates, for output

% ---------------------------------------------------------------------
% preprocess
im = flip(flip(im, 1), 3);

dimYNum = size(im, 1);
dimXNum = size(im, 2);
dimZNum = size(im, 3);    % slice

% get unique intensities from image
intensity = unique(im);     % column vector

% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% ele_cell{i}(j,:) = [element_number, phase_number, node_number_of_8_nodes]
% nodecoor_list(i,:) = [node_number, x, y, z]

[nodecoor_list, ele_cell] = voxelMesh(im, intensity, dimXNum, dimYNum, dimZNum);

% ---------------------------------------------------------------------
% export
% scale nodecoor_list using dx, dy, dz
nodecoor_list(:, 2) = nodecoor_list(:, 2) * dx;
nodecoor_list(:, 3) = nodecoor_list(:, 3) * dy;
nodecoor_list(:, 4) = nodecoor_list(:, 4) * dz;

% generate inp file
% export multi-phases in image as multi-sections in inp file
printInp_multiSect(nodecoor_list, ele_cell, ele_type, precision_nodecoor);

% generate bdf file
printBdf(nodecoor_list, ele_cell, precision_nodecoor);


end





