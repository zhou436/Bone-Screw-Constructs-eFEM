function [toDelEles] = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove)
% Print Abaqus .inp material part
% input boneData:           Bone data structure
% input screwData:          Screw data structure
% input outerRadius:        Outer radius of screw
% input innerRadius:        Screw movement due to insertion position
zCoor = -1; %Lets say -1
disCon = 0.50;
%% screw geometry and preprocessing
% loop over Hex mesh check if any point inner Outer diameter
eleNodesBoolDist = reshape(((boneData.allNodes(boneData.Elements(:,2:9),2)-screwMove(1)).^2+...
    (boneData.allNodes(boneData.Elements(:,2:9),3)-screwMove(2)).^2), [], 8);
eleNOUTBool = (eleNodesBoolDist <= outerRadius^2);
[eleNOUTBoolRow, ~] = find(eleNOUTBool);
ele2CheckOUT = unique(eleNOUTBoolRow);
% hexEleZoneNode = boneData.Elements(ele2Check,:);

%% check if hex mesh in inner diameter range && higher than a value (TO DELETE).
eleNINNBool = (eleNodesBoolDist <= innerRadius^2);
[eleNINNBoolRow, ~] = find(eleNINNBool);
ele2DELINN = unique(eleNINNBoolRow);

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
eleNBCoor = [mean(reshape(boneData.allNodes(boneData.Elements(:,2:9),2),[],8),2),...
    mean(reshape(boneData.allNodes(boneData.Elements(:,2:9),3),[],8),2),...
    mean(reshape(boneData.allNodes(boneData.Elements(:,2:9),4),[],8),2)...
    ];
eleNBCoorCheck = eleNBCoor(ele2Check,:);
eleNSCoor = [mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),2),[],4),2),...
    mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),3),[],4),2),...
    mean(reshape(screwData.Nodes(screwData.Elements(:,2:5),4),[],4),2)...
    ];
% if size(eleNBCoorCheck,1) >= 1e5
DistMatrix = permute(sum((repmat(eleNBCoorCheck,1,1,size(eleNSCoor,1))-...
    permute(repmat(eleNSCoor,1,1,size(eleNBCoorCheck,1)),[3,2,1])).^2,2),[1,3,2]);
DistMatrix = DistMatrix(:,:,1);
DistMatrixMin = min(DistMatrix,[],2);
ele2CheckDis = (DistMatrixMin <= disCon);

clear DistMatrix; clear DistMatrixMin;

ele2Check = ele2Check(ele2CheckDis,:);
%% elements in the zone to be checked
hexEleZoneNode = boneData.Elements(ele2Check,:);
%% check if hex mesh points inside tet mesh elements
ele2Del = [];
parfor ii=1: size(hexEleZoneNode,1)
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
    for jj=1: size(screwData.Elements,1)
        tetCoor = [...
            screwData.Nodes(screwData.Elements(jj,2),2:4);...
            screwData.Nodes(screwData.Elements(jj,3),2:4);...
            screwData.Nodes(screwData.Elements(jj,4),2:4);...
            screwData.Nodes(screwData.Elements(jj,5),2:4);...
            ];
        if funColliTestCubeTet(cubeCoor, tetCoor)
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