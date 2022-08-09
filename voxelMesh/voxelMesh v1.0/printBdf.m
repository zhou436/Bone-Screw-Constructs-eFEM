function printBdf( nodecoor_list, ele_cell, precision )
% printBdf: print the nodes and elements into Inp file 'test.bdf'
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, Nov 2019
    
    num_node = size( nodecoor_list, 1 );
    
    % ------------------------------------------------------------------------
    % format of number
    % field width of node numbering
    width_node_num = 1 + floor( log10( num_node ) );         % 18964 -> 5
    if width_node_num > 16
        error('more than 16 digits')
    end
    
    num_digits_of_int_part = 1 + floor( log10( max(nodecoor_list(end,2:4)) ) );
                                                             % 182.9 -> 3
    if num_digits_of_int_part + precision + 1 > 16
        error('more than 16 digits')
    end
    format_node_coor = [ '%.', num2str( precision ), 'f' ];
                                                             % '%.(precision)f'
    
    % ------------------------------------------------------------------------
	fid=fopen('test.bdf','wW');
    % ------------------------------------------------------------------------
    fprintf( fid, 'BEGIN BULK\n');
    
    % print node
    % GRID*,3,,0.5000,2.5000,*
    % *,0.5000
    fprintf( fid, ...
            [ 'GRID*,%d,,', format_node_coor, ',', format_node_coor, ',*\n', ...
            '*,', format_node_coor, '\n'], ...
            nodecoor_list' );

    % ------------------------------------------------------------------------
    % renumber global element numbering in ele_cell{i}(:,1)
    count = 0;
    for i = 1: size( ele_cell, 1 )
        ele_cell{i}(:,1) = (1:size(ele_cell{i},1))' + count;
        count = count + size(ele_cell{i},1);
    end

    % print element
    % CHEXA*,5,1,40,46,*
    % *,47,41,10,16,*
    % *,17,11
    for i = 1: size( ele_cell, 1 )
        fprintf( fid, ...
            ['CHEXA*,%d,%d,%d,%d', ',*\n', ...
             '*,', '%d,%d,%d,%d', ',*\n', ...
             '*,', '%d,%d\n'], ...
            ele_cell{i}' );
    end
    
    % ------------------------------------------------------------------------
	fprintf( fid, 'ENDDATA' );
    
    % ------------------------------------------------------------------------
    fclose(fid);
	
	disp('printBdf Done! Check the bdf file!');
end
