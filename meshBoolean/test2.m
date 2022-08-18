clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'Job-1.inp';
% fileName = 'Job-Boolean.inp';
data = abaqusInpRead(fileName);
%% plot nodes
% scatter3(data.Nodes{1,1}(:,2),data.Nodes{1,1}(:,3),data.Nodes{1,1}(:,4));
% axis equal
% hold on
% scatter3(data.Nodes{1,2}(:,2),data.Nodes{1,2}(:,3),data.Nodes{1,2}(:,4));
% axis equal
%% plot hex mesh
% plotMesh(data.Elements{1,1}, data.Nodes{1,1}, 0.5, 'none');
%% Screw geometry and preprocessing
outerRadius = 2.0; % Outter Radius 2.0 mm
innerRadius = 0.95; % Inner Radius 0.95 mm
% loop over Hex mesh check if any point inner Outer diameter
hexNodeNum = size(data.Nodes{1,1},1);
hexNodeZone = [];
for ii=1: 1: hexNodeNum
    if (data.Nodes{1,1}(ii,2)^2+data.Nodes{1,1}(ii,3)^2) <= outerRadius^2
        hexNodeZone = [hexNodeZone;data.Nodes{1,1}(ii,:)];
    end
end
% scatter3(hexMeshZone(:,1),hexMeshZone(:,2),hexMeshZone(:,3));
% loop over Hex mesh check if any point between Inner and Outer diameter
hexNodeZoneNum = size(hexNodeZone,1);
hexNodeBTZone = [];
hexNodeInZone = [];
for ii=1: 1: hexNodeZoneNum
    if (hexNodeZone(ii,2)^2+hexNodeZone(ii,3)^2) >= innerRadius^2
        hexNodeBTZone = [hexNodeBTZone;hexNodeZone(ii,:)];
    else
        hexNodeInZone = [hexNodeInZone;hexNodeZone(ii,:)];
    end
end
hexNodeBTZoneNum = size(hexNodeBTZone,1);
hexNodeInZoneNum = size(hexNodeInZone,1);
ele2Del = [];
for ii=1: 1: hexNodeInZoneNum
    [row,~] = find(data.Elements{1,1}==hexNodeInZone(ii,1));
    ele2Del = [ele2Del;row];
end
ele2Del = unique(ele2Del);
% check the hex elements between inner and outer diameter
hexEleBTZone = [];
for ii=1: 1: hexNodeBTZoneNum
    [row,~] = find(data.Elements{1,1}==hexNodeBTZone(ii,1));
    hexEleBTZone = [hexEleBTZone;row];
end
hexEleBTZone = unique(hexEleBTZone);
% Delete the inner zone hex elements from the between zone elements
hexEleBTInZone = [];
for ii=1: 1: size(ele2Del,1)
    [row,~] = find(hexEleBTZone==ele2Del(ii));
    hexEleBTInZone = [hexEleBTInZone;row];
end
hexEleBTInZone = unique(hexEleBTInZone);
hexEleBTZone(hexEleBTInZone,:) = [];
hexEleBTZoneNode = data.Elements{1,1}(hexEleBTZone,:);
% hexEleBTZone = ;
%%
plotMesh(data.Elements{1,1}(hexEleBTZone,:), data.Nodes{1,1}, 0.5, 'none');
axis equal
hold on
%% Select the Tet elements contribute to region outer Innerdiameter
tetNodeNum = size(data.Nodes{1,2},1);
tetNodeZone = []; % the tet element nodes of screw outer innerdiamter
for ii=1: 1: tetNodeNum
    if (data.Nodes{1,2}(ii,2)^2+data.Nodes{1,2}(ii,3)^2) >= innerRadius^2
        tetNodeZone = [tetNodeZone;data.Nodes{1,2}(ii,:)];
    end
end
tetNodeZoneNum = size(tetNodeZone,1);
tetEle2Check = []; % the tet elements of screw contain element nodes outer innerdiameter
for ii=1: 1: tetNodeZoneNum
    [row,~] = find(data.Elements{1,2}==tetNodeZone(ii,1));
    tetEle2Check = [tetEle2Check;row];
end
tetEle2Check = unique(tetEle2Check);
tetEle2CheckNode = data.Elements{1,2}(tetEle2Check,:);
%%
plotMesh(data.Elements{1,2}(tetEle2Check,:), data.Nodes{1,2}, 1.0, '-');
axis equal
hold on
%% check if hex mesh points inside tet mesh elements
parfor ii=1: size(hexEleBTZone,1)
    cubeCoor = [...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,1),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,2),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,3),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,4),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,5),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,6),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,7),2:4);...
        data.Nodes{1,1}(hexEleBTZoneNode(ii,8),2:4);...
        ];
    for jj=1: size(tetEle2CheckNode,1)
        tetCoor = [...
            data.Nodes{1,2}(tetEle2CheckNode(jj,1),2:4);...
            data.Nodes{1,2}(tetEle2CheckNode(jj,2),2:4);...
            data.Nodes{1,2}(tetEle2CheckNode(jj,3),2:4);...
            data.Nodes{1,2}(tetEle2CheckNode(jj,4),2:4);...
            ];
        if funColliTestCubeTet(cubeCoor, tetCoor)
            ele2Del = [ele2Del;hexEleBTZone(ii)];
            fprintf('to delete %d\n',ii);
            break
        end
    end
end
ele2Del = unique(ele2Del);
%% plot the delete meshes
restEle = data.Elements{1,1};
% restEle(ele2Del,:) = [];
transPara = 0.5;
plotMesh(restEle(ele2Del,:), data.Nodes{1,1}, transPara, 'none');
axis equal
hold on



