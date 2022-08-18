function printBdf(nodeCoor, eleCell, precision)
% printBdf: print the nodes and elements into Inp file 'test.bdf'
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, Nov 2019
    
    num_node = size(nodeCoor, 1);
    
    % ------------------------------------------------------------------------
    % format of number
    % field width of node numbering
    width_node_num = 1 + floor(log10(num_node));         % 18964 -> 5
    if width_node_num > 16
        error('more than 16 digits')
    end
    
    num_digits_of_int_part = 1 + floor(log10(max(nodeCoor(end,2:4))));
                                                             % 182.9 -> 3
    if num_digits_of_int_part + precision + 1 > 16
        error('more than 16 digits')
    end
    format_node_coor = ['%.', num2str(precision), 'f'];
                                                             % '%.(precision)f'
    
    % ------------------------------------------------------------------------
	fid=fopen('test.bdf','wW');
    % ------------------------------------------------------------------------
    fprintf(fid, 'BEGIN BULK\n');
    
    % print node
    % GRID*,3,,0.5000,2.5000,*
    % *,0.5000
    fprintf(fid, ...
            ['GRID*,%d,,', format_node_coor, ',', format_node_coor, ',*\n', ...
            '*,', format_node_coor, '\n'], ...
            nodeCoor');

    % ------------------------------------------------------------------------
    % renumber global element numbering in eleCell{i}(:,1)
    count = 0;
    for i = 1: size(eleCell, 1)
        eleCell{i}(:,1) = (1:size(eleCell{i},1))' + count;
        count = count + size(eleCell{i},1);
    end

    % print element
    % CHEXA*,5,1,40,46,*
    % *,47,41,10,16,*
    % *,17,11
    for i = 1: size(eleCell, 1)
        fprintf(fid, ...
            ['CHEXA*,%d,%d,%d,%d', ',*\n', ...
             '*,', '%d,%d,%d,%d', ',*\n', ...
             '*,', '%d,%d\n'], ...
            eleCell{i}');
    end
    
    % ------------------------------------------------------------------------
	fprintf(fid, 'ENDDATA');
    
    % ------------------------------------------------------------------------
    fclose(fid);
	
	disp('printBdf Done! Check the bdf file!');
end
