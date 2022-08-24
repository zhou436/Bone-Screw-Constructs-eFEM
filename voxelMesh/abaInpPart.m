function abaInpPart(fid, Part)
% Print Abaqus .inp material part
% input fid:            File ID
% input Parts.eleType:  Element types, {strings}, size number of parts
% input Parts.partName: Part names, {strings}, size number of parts
% input Parts.partNum:  Number of parts

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');

% format of number
nodeFormat = '%.8f';

% Print Heading of material section

fprintf(fid, '*Instance, name=%s-1, part=%s\n'...
    , Part.partName, Part.partName);

% Node
fprintf(fid, '*Node\n');
% print coordinates of nodes
fprintf(fid, ...
    ['%d,', nodeFormat, ',', ...
    nodeFormat, ',', ...
    nodeFormat, '\n'], ...
    Part.Nodes');

% Element (can update part with different sections, TBD)
fprintf(fid, [...
    '*Element, type=%s, elset=Set-%d'  '\n'...
    ], Part.eleType, Part.setNum);
printEle(fid, Part.Elements, Part.intePnts+1);
fprintf(fid, [...
    '** Section: %s\n'...
    '*Solid Section, elset=Set-%d, controls=EC-%d, material=%s\n'...
    ',\n'...
    '*End Instance\n'...
    ], Part.partName, Part.setNum, Part.setNum, Part.MAT.matName);

% Print Ending of material section
end

function printEle(fid, ele, eleNum)
fprintf(fid, [repmat('%d, ', [1,eleNum]), '\n'], ele');
end