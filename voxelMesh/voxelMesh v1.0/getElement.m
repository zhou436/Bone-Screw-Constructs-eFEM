function ele_cell = getElement( im, intensity, num_col, num_row, num_sli )
% getElement()
% get 8-node number of each element
% ele_cell is a cell, size: num_phase*1
% ele_cell{i} is a matrix, size: num_element*9
% ele_cell{i}(j,:) = [ global_element_number, phase_number, node_number_of_8_nodes ]
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, Nov 2019

    num_phase = length( intensity );
    
    % initialize ele_cell
    ele_cell = cell( num_phase, 1 );
    integer_type = getIntType( num_col, num_row, num_sli );
    
    for i = 1: num_phase
        ele_ind_vector = find( im == intensity(i) );
        num_ele = size( ele_ind_vector, 1 );
        % allocate certain integer type, to save memory space
        ele_temp = zeros( num_ele, 10, integer_type );
        
        for j = 1: num_ele
            % subscript of element in im
            [ row, col, sli ] = ind2sub( [num_row, num_col, num_sli], ele_ind_vector(j) );
            
            % get linear index of eight corner of voxel(row,col,sli) in 
            % nodecoor_list
            Lind_8corner = [ 
                             (col-1)*(num_row+1) + row + (num_row+1)*(num_col+1)*(sli-1), ...
                             col*(num_row+1) + row + (num_row+1)*(num_col+1)*(sli-1), ...
                             col*(num_row+1) + row + 1 + (num_row+1)*(num_col+1)*(sli-1), ...
                             (col-1)*(num_row+1) + row + 1 + (num_row+1)*(num_col+1)*(sli-1), ...
                             (col-1)*(num_row+1) + row + (num_row+1)*(num_col+1)*sli, ...
                             col*(num_row+1) + row + (num_row+1)*(num_col+1)*sli, ...
                             col*(num_row+1) + row + 1 + (num_row+1)*(num_col+1)*sli, ...
                             (col-1)*(num_row+1) + row + 1 + (num_row+1)*(num_col+1)*sli
                             ];

            % put Lind_8corner into
            ele_temp( j, : ) = [ ele_ind_vector(j), i, Lind_8corner ];
        end
        
        ele_cell{i} = ele_temp;
    end
    
end

function integer_type = getIntType( num_col, num_row, num_sli )
% get the suitable integer type for storing node number

    total_num_node = (num_row+1)*(num_col+1)*(num_sli+1);
    if total_num_node >0 && total_num_node < 2^64
        
        if total_num_node < 2^8
           integer_type = 'uint8';
        elseif total_num_node < 2^16
           integer_type = 'uint16';
        elseif total_num_node < 2^32
           integer_type = 'uint32';
        else
           integer_type = 'uint64';
        end
    else
        error('unexpected number of nodes');
    end
end
