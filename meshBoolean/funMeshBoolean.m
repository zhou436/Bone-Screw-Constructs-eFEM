function [toDelEles] = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove)
% Print Abaqus .inp material part
% input boneData:           Bone data structure
% input screwData:          Screw data structure
% input outerRadius:        Outer radius of screw
% input innerRadius:        Screw movement due to insertion position

%% Screw geometry and preprocessing

% loop over Hex mesh check if any point inner Outer diameter
eleNodesBoolCoor = reshape(((boneData.allNodes(boneData.Elements(:,2:9),2)-screwMove(1)).^2+...
    (boneData.allNodes(boneData.Elements(:,2:9),3)-screwMove(2)).^2), [], 8);
eleNodesBool = (eleNodesBoolCoor <= outerRadius^2);
[eleNodesBoolRow, ~] = find(eleNodesBool);
ele2Check = unique(eleNodesBoolRow);

hexEleZoneNode = boneData.Elements(ele2Check,:);
% toc
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
ele2Del = hexEleZoneNode(ele2Del,:);
%% plot the delete meshes
screwBoneMeshDel = figure();
plotMesh(screwData.Elements(:,2:5), screwData.Nodes, 1.0, '-');
hold on
plotMesh(hexEleZoneNode(:,2:9), boneData.allNodes, 1.0, 'none');
hold on
transPara = 0.5;
plotMesh(ele2Del(:,2:9), boneData.allNodes, transPara, '-');
axis equal
hold off
saveas(screwBoneMeshDel, 'screwBoneMeshDel.png');
%% 
toDelEles = ele2Del(:,1);

end