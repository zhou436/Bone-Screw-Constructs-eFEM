function nodeCoor = getNodelist(uniNode, dimXNum, dimYNum, dimZNum)
% build matrix for all nodes
% Convert 3d image to voxel-based 8-node mesh
% input uniNode:    Node utilized for element building, (n,1)
% input dimXNum:    Number of voxels in dimension X
% input dimYNum:    Number of voxels in dimension Y
% input dimZNum:    Number of voxels in dimension Z
% output nodeCoor:  Coordinates of node in uniNode, (n,4), (n,x,y,z)

xs = -dimXNum/2: 1: dimXNum/2;
ys = -dimYNum/2: 1: dimYNum/2;
zs = -dimZNum/2: 1: dimZNum/2;
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

nodeNum = length(uniNode);
nodeCoor = zeros(nodeNum, 4);
nodeCoor(:, 1) = uniNode;
nodeCoor(:, 2:4) = [X, Y, Z];
end





