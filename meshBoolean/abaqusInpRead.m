function [data]= abaqusInpRead(fileName)
% read abaqus input file, e.g. fileName = 'myExamInpFile.inp'
% coded by Wan Ji, Wuhan University
% update date 2021/07/15
% last version "readinp", refer to
% https://www.mathworks.com/matlabcentral/fileexchange/95343-read-abaqus-input-file-to-get-the-nodes-and-elements
% something new to this version
% (1) fixed the bug which the function can't read c3d20 element
% (2) offer optional output, that is, the struct output
%%
% If the number of output arguments is only 1, then a structure output is
% activated, the struct includes some important information inside the inp
% file, like "Parts", "Nodes", "Elements", "NodeSets", "ElementSets", "Materials",
% etc.
% Example 01
% fileName = 'myExamInpFile.inp';
% data = abaqusInpRead(fileName);
%%
% If the number of output arguments is 3, then the 1st set of node
% coordinates, the 1st set of elements, and element type will be the output
% data.
% Example 02
% fileName = 'myExamInpFile.inp';
% [node, element, elementType] = abaqusInpRead(fileName);
%% Function body
s = fileread(fileName);
s = lower(s);
s = split(s,'*');
partNum = 0;
Nodes = {};
Elements = {};
for i = 1:1:numel(s)
    [myMatrix, FLS]= getMatrixFromString(s{i}, newline, ',');
    FLS(FLS==char(32)|FLS==char(13)|FLS==newline) = [];
    p = split(FLS,',');
    q = p{1};
    if(isempty(q))
        continue;
    end
    switch lower(q)
        case {'node'}
            partNum = partNum + 1;
            Nodes{partNum} = cell2mat(myMatrix);
        case {'element'}
            eType = split(p{2},'=');
            eType = eType{2};
            eNodeNumber = eType(4:end);
            eNodeNumber(double(eNodeNumber)>double('9')|double(eNodeNumber)<double('0')) = [];
            eNodeNumber = str2double(eNodeNumber);
%             Elements(c,1).ElementType = eType;
            if(numel(myMatrix)>=2 && (numel(myMatrix{1})+numel(myMatrix{2})-1==eNodeNumber))
                myMat = cell(numel(myMatrix)/2,1);
                for j = 1:1:numel(myMat)
                    myMat{j,1} = [myMatrix{2*j-1,1}, myMatrix{2*j,1}];
                end
            elseif(numel(myMatrix)>=3&& ...
                    (numel(myMatrix{1})+numel(myMatrix{2})+numel(myMatrix{3})-1==eNodeNumber))
                myMat = cell(numel(myMatrix)/3,1);
                for j = 1:1:numel(myMat)
                    myMat{j,1} = [myMatrix{3*j-2,1}, myMatrix{3*j-1,1}, myMatrix{3*j,1}];
                end
            else
                myMat = myMatrix;
            end
            elements = cell2mat(myMat);
            Elements{partNum} = elements(:,2:end);
        otherwise
            continue
    end
end
% data.Parts = Parts;
data.Nodes = Nodes;
data.Elements = Elements;
% data.NodeSets = NodeSets;
% data.ElementSets = ElementSets;
% data.Materials = Materials;
% if(nargout>=2)
%     elementOut = data.Elements(1).NodeIDList;
%     data = data.Nodes(1).Coordinates;
%     eType = Elements(1).ElementType;
% end
end

function [myMatrix, firstLineString] = getMatrixFromString(s, sepRow, sepColumn)
% get the matrix from a string
ssep = split(s, sepRow);
myMatrix = cell(numel(ssep),1);
myFlag = true(numel(ssep),1);
columnNumber = zeros(numel(ssep),1);
firstLineString = ssep{1};
for i = 1:1:numel(ssep)
    es = ssep{i};
    es(es==char(32)|es==char(13)|es==newline) = [];
    p = split(es, sepColumn);
    myMatrix{i} = zeros(1, numel(p));
    columnNumber(i) = numel(p);
    for j = 1:1:numel(p)
        myMatIJ = str2double(p{j});
        myMatrix{i}(1,j) = myMatIJ;
    end
    myMatrix{i}( isnan(myMatrix{i}))=[];
    if(isempty(myMatrix{i}))
        myFlag(i) = false;
    end
end
myMatrix = myMatrix(myFlag,1);
end