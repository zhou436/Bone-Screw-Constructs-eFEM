clc; clear
%% Example 01
figure(1)
clf
fileName = 'myExamInpFile.inp';
data = abaqusInpRead(fileName);
% following only works for 3-node-tri or 4-node-quad element
node = data.Nodes.Coordinates;
for i = 1:1:numel(data.Elements)
    element = data.Elements(i).NodeIDList;
patch('vertices',node,'faces',element,...
    'facevertexCdata',node(:,1),'facecolor','interp','edgecolor','k');
hold on
end
colormap jet
axis off
axis equal
title('Two Element Types')
%% Example 02
figure(2)
clf
fileName = 'myExamInpFile.inp';
[node, element, elementType] = abaqusInpRead(fileName);
% following only works for 3-node-tri or 4-node-quad element
patch('vertices',node,'faces',element,...
    'facevertexCdata',node(:,1),'facecolor','interp','edgecolor','k');
colormap jet
axis off
axis equal
title('Only One Element Type')