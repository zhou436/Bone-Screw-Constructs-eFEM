function [toDelEles] = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove)
% Print Abaqus .inp material part
% input boneData:           Bone data structure
% input screwData:          Screw data structure
% input outerRadius:        Outer radius of screw
% input innerRadius:        Screw movement due to insertion position
zCoor = -3; %Lets say -1
disCon = 0.5;
%% screw geometry and preprocessing
% loop over Hex mesh check if any point inner Outer diameter
eleNodesBoolDist = reshape(((boneData.allNodes(boneData.Elements(:,2:9),2)-screwMove(1)).^2+...
    (boneData.allNodes(boneData.Elements(:,2:9),3)-screwMove(2)).^2), [], 8);
eleNOUTBool = (eleNodesBoolDist <= outerRadius^2);
[eleNOUTBoolRow, ~] = find(eleNOUTBool);
ele2CheckOUT = unique(eleNOUTBoolRow);
% hexEleZoneNode = boneData.Elements(ele2Check,:);

%% check if hex mesh in inner diameter range && higher than a value (TO DELETE).
if innerRadius ~= 0
    eleNINNBool = (eleNodesBoolDist <= innerRadius^2);
    [eleNINNBoolRow, ~] = find(eleNINNBool);
    ele2DELINN = unique(eleNINNBoolRow);
else
    ele2DELINN = [];
end

eleCoorZ = reshape(boneData.allNodes(boneData.Elements(:,2:9),4),[],8);
% Z coordinate higher to be deleted
eleNUPPBool = (eleCoorZ >= zCoor);
[eleNUPPBoolRow, ~] = find(eleNUPPBool);
ele2DELUPP = unique(eleNUPPBoolRow);
% elements to be deleted
ele2Del = intersect(ele2DELINN,ele2DELUPP);
ele2DelMat = boneData.Elements(ele2Del,:);
% Outter minus (inner and upper)
ele2Check = setdiff(ele2CheckOUT,ele2Del);

%% Prescan if hex mesh distance to tet mesh (critical distance setting)
eleNBCoorCheck = single([mean(reshape(boneData.allNodes(boneData.Elements(ele2Check,2:9),2),[],8),2),...
    mean(reshape(boneData.allNodes(boneData.Elements(ele2Check,2:9),3),[],8),2),...
    mean(reshape(boneData.allNodes(boneData.Elements(ele2Check,2:9),4),[],8),2)...
    ]);
% eleNBCoorCheck = eleNBCoor(ele2Check,:);
eleNSCoor = single([mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),2),[],4),2),...
    mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),3),[],4),2),...
    mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),4),[],4),2)...
    ]);
% if size(eleNBCoorCheck,1) >= 1e5
matAllNum = 10000;
ele2CheckFor = [];
DistMatrix2Check = [];
for ii=1: ceil(size(eleNBCoorCheck,1)/matAllNum)
    fprintf('checking distance %d to %d from %d elements\n',(ii-1)*matAllNum+1,ii*matAllNum,size(eleNBCoorCheck,1));
%     disp(ii*matAllNum);
    if ii ~= ceil(size(eleNBCoorCheck,1)/matAllNum)
        DistMatrix = permute(sum((repmat(eleNBCoorCheck((ii-1)*matAllNum+1:ii*matAllNum,:),1,1,size(eleNSCoor,1))-...
            permute(repmat(eleNSCoor,1,1,size(eleNBCoorCheck((ii-1)*matAllNum+1:ii*matAllNum),1)),[3,2,1])).^2,2),[1,3,2]);
    else
        DistMatrix = permute(sum((repmat(eleNBCoorCheck((ii-1)*matAllNum+1:end,:),1,1,size(eleNSCoor,1))-...
            permute(repmat(eleNSCoor,1,1,size(eleNBCoorCheck((ii-1)*matAllNum+1:end),1)),[3,2,1])).^2,2),[1,3,2]);
    end
    % DistMatrix = DistMatrix(:,:,1);
    DistMatrixBol = (DistMatrix <= disCon);
    [DistMatrixBolRow, ~] = find(DistMatrixBol);
    ele2CheckDis = unique(DistMatrixBolRow);
    DistMatrix2Check = [DistMatrix2Check; DistMatrix(ele2CheckDis,:)];
    ele2CheckFor = [ele2CheckFor; ele2Check(ele2CheckDis+(ii-1)*matAllNum,:)];
end

ele2Check = ele2CheckFor;
clear DistMatrix; clear DistMatrixMin;
%% elements in the zone to be checked
hexEleZoneNode = boneData.Elements(ele2Check,:);
%% check if hex mesh points inside tet mesh elements
ele2Del = [];
parfor ii=1: size(hexEleZoneNode,1)
% for ii=1: size(hexEleZoneNode,1)
    cubeCoor = [...
        boneData.allNodes(hexEleZoneNode(ii,2),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,3),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,4),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,5),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,6),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,7),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,8),2:4);...
        boneData.allNodes(hexEleZoneNode(ii,9),2:4);...
        ];
    distArr = DistMatrix2Check(ii,:);
    screwEle2CheckBol = find(distArr <= disCon);
    for jj=1: size(screwEle2CheckBol,2)
        tetCoor = [...
            screwData.Nodes(screwData.Elements(screwEle2CheckBol(jj),2),2:4);...
            screwData.Nodes(screwData.Elements(screwEle2CheckBol(jj),3),2:4);...
            screwData.Nodes(screwData.Elements(screwEle2CheckBol(jj),4),2:4);...
            screwData.Nodes(screwData.Elements(screwEle2CheckBol(jj),5),2:4);...
            ];
%         if funColliTestCubeTet(cubeCoor, tetCoor)
        if GJK(cubeCoor,tetCoor,6)
            ele2Del = [ele2Del;ii];
            fprintf('to delete %d\n',ii);
            break
        end
    end
end
ele2DelMat = [ele2DelMat;hexEleZoneNode(ele2Del,:)];
%% plot the delete meshes
screwBoneMeshDel = figure();
plotMesh(screwData.Elements(:,2:5), screwData.Nodes, 1.0, '-');
hold on
plotMesh(hexEleZoneNode(:,2:9), boneData.allNodes, 1.0, 'none');
hold on
transPara = 0.5;
plotMesh(ele2DelMat(:,2:9), boneData.allNodes, transPara, '-');
axis equal
hold off
saveas(screwBoneMeshDel, 'screwBoneMeshDel.png');
%% 
toDelEles = ele2DelMat(:,1);
toc
end