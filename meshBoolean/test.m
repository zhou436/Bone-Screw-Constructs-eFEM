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
hexMeshNum = size(data.Nodes{1,1},1);
hexMeshZone = [];
for ii=1: 1: hexMeshNum
    if (data.Nodes{1,1}(ii,2)^2+data.Nodes{1,1}(ii,3)^2) <= outerRadius^2
        hexMeshZone = [hexMeshZone;data.Nodes{1,1}(ii,:)];
    end
end
% scatter3(hexMeshZone(:,1),hexMeshZone(:,2),hexMeshZone(:,3));
% loop over Hex mesh check if any point between Inner and Outer diameter
hexMeshZoneNum = size(hexMeshZone,1);
hexMeshBTZone = [];
hexMeshInZone = [];
for ii=1: 1: hexMeshZoneNum
    if (hexMeshZone(ii,2)^2+hexMeshZone(ii,3)^2) >= innerRadius^2
        hexMeshBTZone = [hexMeshBTZone;hexMeshZone(ii,:)];
    else
        hexMeshInZone = [hexMeshInZone;hexMeshZone(ii,:)];
    end
end
scatter3(hexMeshBTZone(:,2),hexMeshBTZone(:,3),hexMeshBTZone(:,4));
hold on
scatter3(hexMeshInZone(:,2),hexMeshInZone(:,3),hexMeshInZone(:,4));
hexMeshBTZoneNum = size(hexMeshBTZone,1);
hexMeshInZoneNum = size(hexMeshInZone,1);
ele2Del = [];
for ii=1: 1: hexMeshInZoneNum
    [row,~] = find(hexMeshInZone==hexMeshInZone(ii));
    ele2Del = [ele2Del;row];
end
ele2Del = unique(ele2Del);
%%




