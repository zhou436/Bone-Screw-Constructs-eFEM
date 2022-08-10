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
im = importImSeqs( folder_name );
toc

% ---------------------------------------------------------------------
% parameters
dx = 1; dy = 1; dz = 1; % scale of original 3d image 
                        % dx - column direction, dy - row direction,
                        % dz - vertical direction (slice)

ele_type = 'C3D8R';     % element type, for printInp_multiSect
precision_nodecoor = 8; % precision of node coordinates, for output

% ---------------------------------------------------------------------
% preprocess
im = flip( flip( im, 1 ), 3 );

num_row = size( im, 1 );
num_col = size( im, 2 );
num_sli = size( im, 3 );    % slice

% get unique intensities from image
intensity = unique( im );     % column vector
toc
% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% ele_cell{i}(j,:) = [ element_number, phase_number, node_number_of_8_nodes ]
% nodecoor_list(i,:) = [ node_number, x, y, z ]

[ nodecoor_list, ele_cell ] = voxelMesh( im, intensity, num_col, num_row, num_sli );
toc
% ---------------------------------------------------------------------
% export
% scale nodecoor_list using dx, dy, dz
nodecoor_list( :, 2 ) = nodecoor_list( :, 2 ) * dx;
nodecoor_list( :, 3 ) = nodecoor_list( :, 3 ) * dy;
nodecoor_list( :, 4 ) = nodecoor_list( :, 4 ) * dz;
toc
% generate inp file
% export multi-phases in image as multi-sections in inp file
printInp_multiSect( nodecoor_list, ele_cell, ele_type, precision_nodecoor );

% generate bdf file
printBdf( nodecoor_list, ele_cell, precision_nodecoor );
toc

end





