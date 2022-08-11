function nodeCoor = getNodelist(uniNode, dimXNum, dimYNum, dimZNum)
% build matrix for all nodes
% Convert 3d image to voxel-based 8-node mesh
% input uniNode:    Node utilized for element building, (n,1)
% input dimXNum:    Number of voxels in dimension X
% input dimYNum:    Number of voxels in dimension Y
% input dimZNum:    Number of voxels in dimension Z
% output nodeCoor:  Coordinates of node in uniNode, (n,4), (n,x,y,z)

xs = 0.5: dimXNum+0.5;
ys = 0.5: dimYNum+0.5;
zs = 0.5: dimZNum+0.5;
[X, Y, Z] = meshgrid(xs, ys, zs);

% reshape into vector
% can be accessed by X(i), Y(i), Z(i)
X = X(:);
Y = Y(:);
Z = Z(:);

% extract certain nodes
X = X(uniNode);
Y = Y(uniNode);
Z = Z(uniNode);

num_node = length(uniNode);
% temporary list for parfor
temp_list = zeros(num_node, 3);

for i = 1: num_node
    temp_list(i, :) = [X(i), Y(i), Z(i)];
end

% create point list, storing x y z coordinate of all nodes
% nodeCoor(i,:) = [node_number, x, y, z]
nodeCoor = zeros(num_node, 4);
nodeCoor(:, 1) = uniNode;
nodeCoor(:, 2:4) = temp_list;

end





