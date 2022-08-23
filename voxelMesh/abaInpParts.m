function abaInpParts(fid, nodeCoor, eleCell, nodePreci, Parts)
% Print Abaqus .inp material part
% input fid:            File ID
% input Parts.eleType:  Element types, {strings}, size number of parts
% input Parts.partName: Part names, {strings}, size number of parts
% input Parts.partNum:  Number of parts

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');

% format of number
% '%.(precision)f'
nodeFormat = ['%.', num2str(nodePreci), 'f'];

% Print Heading of material section
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '**\n');
fprintf(fid, '** PARTS\n');
fprintf(fid, '**\n');
for ii = 1: Parts.partNum
    fprintf(fid, [...
        '**\n'...
        '*Part, name=%s\n'...
        '*End Part\n'...
        '**\n'...
        ], Parts.partName(ii));
end

fprintf(fid, [...
    '**\n'...
    '** ASSEMBLY\n'...
    '**\n'...
    '*Assembly, name=Assembly\n'...
    '**\n'...
    '*Instance, name=%s-1, part=%s\n'...
    ],  Parts.partName(ii),  Parts.partName(ii));

% Node
fprintf(fid, '*Node\n');
% print coordinates of nodes
fprintf(fid, ...
    ['%d,', nodeFormat, ',', ...
    nodeFormat, ',', ...
    nodeFormat, '\n'], ...
    nodeCoor');

% Element
for ii = 1: Parts.partNum
    fprintf(fid, [...
        '*Element, type=%s, elset=Set-%d'  '\n'...
        ], Parts.eleType(ii), ii);
    printEle(fid, eleCell(:,[1 3:10]), 9);
    fprintf(fid, [...
        '** Section: Screw\n'...
        '*Solid Section, elset=Set-%d, controls=EC-%d, material=Bone\n'...
        ',\n'...
        '*End Instance\n'...
        '*End Assembly\n'...
        ],ii,ii);      
end

% Print BC sets (top and bot surfaces of the bone sample)
topCoor = max(nodeCoor(:,4));
botCoor = min(nodeCoor(:,4));
[nodeTop,~] = find(nodeCoor(:,4)==topCoor);
[nodeBot,~] = find(nodeCoor(:,4)==botCoor);

fprintf(fid, '*Nset, nset=BoneTop, instance=Bone-1\n');
nodeTopNum = numel(nodeTop);
nodeTopNumF = floor(nodeTopNum/16)*16;
nodeTopInt = reshape(nodeTop(1:nodeTopNumF),16,[])';
printEle(fid, nodeTopInt, 16);
printEle(fid, nodeTop(end-nodeTopNum+nodeTopNumF+1:end), nodeTopNum-nodeTopNumF);
fprintf(fid, '*Nset, nset=BoneBot, instance=Bone-1\n');
nodeBotNum = numel(nodeBot);
nodeBotNumF = floor(nodeBotNum/16)*16;
nodeBotInt = reshape(nodeBot(1:nodeBotNumF),16,[])';
printEle(fid, nodeBotInt, 16);
printEle(fid, nodeBot(end-nodeBotNum+nodeBotNumF+1:end), nodeBotNum-nodeBotNumF);

% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end

function printEle(fid, ele, eleNum)
fprintf(fid, [repmat('%d, ', [1,eleNum]), '\n'], ele');
end