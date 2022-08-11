function nodecoor_list = getNodelist(unique_node_ind_v, dimXNum, dimYNum, dimZNum)
% getNodelist()
% get list of all nodes
% nodecoor_list(i,:) = [node_number, x, y, z]
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, Nov 2019

    % generate x y z coordinate of all nodes
    % can be accessed by X(row, col, sli), Y(row, col, sli), 
    % Z(row, col, sli)
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
    X = X(unique_node_ind_v);
    Y = Y(unique_node_ind_v);
    Z = Z(unique_node_ind_v);
    
    num_node = length(unique_node_ind_v);
    % temporary list for parfor
    temp_list = zeros(num_node, 3);
    
    for i = 1: num_node
        temp_list(i, :) = [X(i), Y(i), Z(i)];
    end
    
    % create point list, storing x y z coordinate of all nodes
    % nodecoor_list(i,:) = [node_number, x, y, z]
    nodecoor_list = zeros(num_node, 4);
    nodecoor_list(:, 1) = unique_node_ind_v;
    nodecoor_list(:, 2:4) = temp_list;

end





