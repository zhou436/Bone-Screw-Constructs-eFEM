function [nodeCoor, eleCell] = voxelMesh(im, intensity, dimXNum, dimYNum, dimZNum)
% Convert 3d image to voxel-based 8-node mesh
% input im:         micro-CT image, (dimXNum,dimYNum,dimZNum)
% input intensity:  A matrix (n,1), n intensity numbers
% input dimXNum:    Number of voxels in dimension X
% input dimYNum:    Number of voxels in dimension Y
% input dimZNum:    Number of voxels in dimension Z
% output nodeCoor:  node list combined the nodes number and coordinates (x,y,z)
% output eleCell:   element cell, (n,10) [element number, intensity, nodes(8)]

% get numbering of 8 nodes in each element, corresponding to intensity
eleCell = getElement(im, intensity, dimXNum, dimYNum, dimZNum);

% get unique index of nodes
node_ind_cell = cellfun(@(A) unique(A(:,3:10)), eleCell, 'UniformOutput', false);
unique_node_ind_v = unique(cell2mat(node_ind_cell));    % column vector

% get list of node coordinates, corresponding to unique_node_ind_v
% nodecoor_list(i,:) = [node_number, x, y, z]
nodeCoor = getNodelist(unique_node_ind_v, dimXNum, dimYNum, dimZNum);

end

