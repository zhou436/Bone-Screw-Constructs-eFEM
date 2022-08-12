function printInp(nodeCoor, eleCell, eleType, nodePreci, fileName)
% build Abaqus inp file
% Convert 3d image to voxel-based 8-node mesh
% input nodeCoor:  node list combined the nodes number and coordinates (x,y,z)
% input eleCell:   element cell, (n,10) [element number, intensity, nodes(8)]
% input eleType:   element types (e.g. C3D8, C3D8R)
% input precision: precision of node coordinates
% input fileName:  filename of the output inp file

% format of Inp file
% ------------------------------------------------------------------------
% Heading
%
% Node
%
% Element
%
% Section
% ------------------------------------------------------------------------

partNum = length(eleCell);
sect_ascii = 65: (65 + partNum - 1);
sect_char = char(sect_ascii);     % 'ABCD...'

% format of number
% '%.(precision)f'
nodeFormat = ['%.', num2str(nodePreci), 'f'];

% ------------------------------------------------------------------------
fid=fopen(sprintf('%s.inp',fileName),'wW');
% ------------------------------------------------------------------------
% Heading
fprintf(fid, [...
    '*Heading'                                              '\n'...
    '*Preprint, echo=NO, model=NO, history=NO, contact=NO'  '\n'...
    '**'                                                    '\n'...
    ]);

% ------------------------------------------------------------------------
% Node
fprintf(fid, '*Node\n');

% print coordinates of nodes
% '%d,%.4f,%.4f,%.4f\n'
fprintf(fid, ...
    ['%d,', nodeFormat, ',', ...
    nodeFormat, ',', ...
    nodeFormat, '\n'], ...
    nodeCoor');

% ------------------------------------------------------------------------
% Element
for i = 1: partNum
    fprintf(fid, [...
        '*Element, type=%s, elset=Set-%c'  '\n'...
        ], eleType, sect_char(i));

    % fprintf(fid, '%d,%d,%d,%d,%d,%d,%d,%d,%d\n', eleCell{i}');
    printEle(fid, eleCell{i}(:,[1 3:10]));
end

% ------------------------------------------------------------------------
% Section
for i = 1: partNum
    fprintf(fid, [...
        '** Section: Section-%c'            '\n'...
        '*Solid Section, elset=Set-%c, material=Material-%c'  '\n'...
        ','                                 '\n'...
        ], ...
        sect_char(i), ...
        sect_char(i), sect_char(i));
end

fprintf(fid, '**');

% ------------------------------------------------------------------------
fclose(fid);

disp('printInp Done! Check the inp file!');
end


function printEle(fid, ele)
fprintf(fid, ...
    [repmat('%d,', [1,8]), '%d', '\n'], ...
    ele');
end