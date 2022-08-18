clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'Job-Boolean.inp';
data = abaqusInpRead(fileName);
%% plot nodes
scatter3(data.Nodes{1,1}(:,2),data.Nodes{1,1}(:,3),data.Nodes{1,1}(:,4));
axis equal
hold on
scatter3(data.Nodes{1,2}(:,2),data.Nodes{1,2}(:,3),data.Nodes{1,2}(:,4));
axis equal
%% plot hex mesh
trisurfaces = [];
for ii=1: 1: size(data.Elements{1,1},1)
    trisurfaces = [trisurfaces; ...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,2),data.Elements{1,1}(ii,3)];...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,3),data.Elements{1,1}(ii,4)];...
        [data.Elements{1,1}(ii,5),data.Elements{1,1}(ii,6),data.Elements{1,1}(ii,7)];...
        [data.Elements{1,1}(ii,5),data.Elements{1,1}(ii,7),data.Elements{1,1}(ii,8)];...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,2),data.Elements{1,1}(ii,6)];...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,6),data.Elements{1,1}(ii,5)];...
        [data.Elements{1,1}(ii,2),data.Elements{1,1}(ii,3),data.Elements{1,1}(ii,7)];...
        [data.Elements{1,1}(ii,2),data.Elements{1,1}(ii,7),data.Elements{1,1}(ii,6)];...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,8),data.Elements{1,1}(ii,5)];...
        [data.Elements{1,1}(ii,1),data.Elements{1,1}(ii,4),data.Elements{1,1}(ii,8)];...
        [data.Elements{1,1}(ii,4),data.Elements{1,1}(ii,7),data.Elements{1,1}(ii,8)];...
        [data.Elements{1,1}(ii,4),data.Elements{1,1}(ii,3),data.Elements{1,1}(ii,7)];...
        ];
end
trisurf(trisurfaces,data.Nodes{1,1}(:,2),data.Nodes{1,1}(:,3),data.Nodes{1,1}(:,4));
axis equal
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
% scatter3(hexNodeBTZone(:,2),hexNodeBTZone(:,3),hexNodeBTZone(:,4));
% hold on
% scatter3(hexNodeInZone(:,2),hexNodeInZone(:,3),hexNodeInZone(:,4));
hexNodeBTZoneNum = size(hexNodeBTZone,1);
hexNodeInZoneNum = size(hexNodeInZone,1);
ele2Del = [];
for ii=1: 1: hexNodeInZoneNum
    [row,~] = find(data.Elements{1,1}==hexNodeInZone(ii,1));
    ele2Del = [ele2Del;row];
end
ele2Del = unique(ele2Del);
%% Select the Tet elements contribute to region outer Innerdiameter
tetNodeNum = size(data.Nodes{1,2},1);
tetNodeZone = [];
for ii=1: 1: tetNodeNum
    if (data.Nodes{1,2}(ii,2)^2+data.Nodes{1,2}(ii,3)^2) >= innerRadius^2
        tetNodeZone = [tetNodeZone;data.Nodes{1,2}(ii,:)];
    end
end
tetNodeZoneNum = size(tetNodeZone,1);
tetEle2Check = [];
for ii=1: 1: tetNodeZoneNum
    [row,~] = find(data.Elements{1,2}==tetNodeZone(ii,1));
    tetEle2Check = [tetEle2Check;row];
end
tetEle2Check = unique(tetEle2Check);
tetEle2CheckNode = data.Elements{1,2}(tetEle2Check,:);
%% check if hex mesh points inside tet mesh elements
hexNodeBTZone2Del = [];
tetEle2CheckNum = size(tetEle2Check,1);
for ii=1: 1: hexNodeBTZoneNum
    parfor jj=1: tetEle2CheckNum
        tetCoor = [data.Nodes{1,2}(tetEle2CheckNode(jj,1),2:4)',...
            data.Nodes{1,2}(tetEle2CheckNode(jj,2),2:4)',...
            data.Nodes{1,2}(tetEle2CheckNode(jj,3),2:4)',...
            data.Nodes{1,2}(tetEle2CheckNode(jj,4),2:4)'];
        pntCoor = hexNodeBTZone(ii,(2:4));
        paraArr = [tetCoor;1,1,1,1]\[pntCoor';1];
        if isequal(paraArr,abs(paraArr)) || isequal(paraArr,-abs(paraArr))
            hexNodeBTZone2Del = [hexNodeBTZone2Del;hexNodeBTZone(ii,1)];
        end
    end
end
hexNodeBTZone2Del = unique(hexNodeBTZone2Del);
%% find the hex nodes
hexNodeBTZone2DelNum = size(hexNodeBTZone2Del,1);
for ii=1: 1: hexNodeBTZone2DelNum
    [row,~] = find(data.Elements{1,1}==hexNodeBTZone2Del(ii,1));
    ele2Del = [ele2Del;row];
end
ele2Del = unique(ele2Del);
%% delete the hex elements

hexElements = data.Elements{1,1};
hexEleDeled = hexElements;
hexEleDeled(ele2Del,:) = [];
trisurfaces = [];
for ii=1: 1: size(hexEleDeled,1)
    trisurfaces = [trisurfaces; ...
        [hexEleDeled(ii,1),hexEleDeled(ii,2),hexEleDeled(ii,3)];...
        [hexEleDeled(ii,1),hexEleDeled(ii,3),hexEleDeled(ii,4)];...
        [hexEleDeled(ii,5),hexEleDeled(ii,6),hexEleDeled(ii,7)];...
        [hexEleDeled(ii,5),hexEleDeled(ii,7),hexEleDeled(ii,8)];...
        [hexEleDeled(ii,1),hexEleDeled(ii,2),hexEleDeled(ii,6)];...
        [hexEleDeled(ii,1),hexEleDeled(ii,6),hexEleDeled(ii,5)];...
        [hexEleDeled(ii,2),hexEleDeled(ii,3),hexEleDeled(ii,7)];...
        [hexEleDeled(ii,2),hexEleDeled(ii,7),hexEleDeled(ii,6)];...
        [hexEleDeled(ii,1),hexEleDeled(ii,8),hexEleDeled(ii,5)];...
        [hexEleDeled(ii,1),hexEleDeled(ii,4),hexEleDeled(ii,8)];...
        [hexEleDeled(ii,4),hexEleDeled(ii,7),hexEleDeled(ii,8)];...
        [hexEleDeled(ii,4),hexEleDeled(ii,3),hexEleDeled(ii,7)];...
       ];
end
trisurf(trisurfaces,data.Nodes{1,1}(:,2),data.Nodes{1,1}(:,3),data.Nodes{1,1}(:,4));
axis equal
hold on

%% plot tet mesh
triSurfTet = [];
for ii=1: 1: size(data.Elements{1,2},1)
    triSurfTet = [triSurfTet; ...
        [data.Elements{1,2}(ii,1),data.Elements{1,2}(ii,2),data.Elements{1,2}(ii,3)];...
        [data.Elements{1,2}(ii,1),data.Elements{1,2}(ii,3),data.Elements{1,2}(ii,4)];...
        [data.Elements{1,2}(ii,1),data.Elements{1,2}(ii,2),data.Elements{1,2}(ii,4)];...
        [data.Elements{1,2}(ii,2),data.Elements{1,2}(ii,3),data.Elements{1,2}(ii,4)];...
       ];
end
trisurf(triSurfTet,data.Nodes{1,2}(:,2),data.Nodes{1,2}(:,3),data.Nodes{1,2}(:,4));
axis equal
%% plot tet mesh
triSurfTet = [];
for ii=1: 1: size(tetEle2Plot,1)
    triSurfTet = [triSurfTet; ...
        [tetEle2Plot(ii,1),tetEle2Plot(ii,2),tetEle2Plot(ii,3)];...
        [tetEle2Plot(ii,1),tetEle2Plot(ii,3),tetEle2Plot(ii,4)];...
        [tetEle2Plot(ii,1),tetEle2Plot(ii,2),tetEle2Plot(ii,4)];...
        [tetEle2Plot(ii,2),tetEle2Plot(ii,3),tetEle2Plot(ii,4)];...
       ];
end
trisurf(triSurfTet,data.Nodes{1,2}(:,2),data.Nodes{1,2}(:,3),data.Nodes{1,2}(:,4));
axis equal
%%
>>>>>>> origin

tetCoor = [...
    -0.2,0.2,0.5;...
    0.2,1.2,0.5;...
    -0.2,1.2,0.5;...
    -0.2,1.2,0.8;...
    ];





