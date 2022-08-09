function [ nodecoor_list, ele_cell ] = voxelMesh( im, intensity, ...
                                                num_col, num_row, num_sli )
% convert 3d image to voxel-based 8-node mesh
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, May 2020

% get numbering of 8 nodes in each element, corresponding to intensity
% ele_cell{i}(j,:) = [ element_number, phase_number, node_number_of_8_nodes ]
ele_cell = getElement( im, intensity, num_col, num_row, num_sli );

% get unique index of nodes
node_ind_cell = cellfun( @(A) unique(A(:,3:10)), ele_cell, 'UniformOutput', 0 );
unique_node_ind_v = unique( cell2mat( node_ind_cell ) );    % column vector

% get list of node coordinates, corresponding to unique_node_ind_v
% nodecoor_list(i,:) = [ node_number, x, y, z ]
nodecoor_list = getNodelist( unique_node_ind_v, num_col, num_row, num_sli );

end

