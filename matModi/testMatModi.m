clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'matCardTest';
abaData = [];
abaData = abaInpData(abaData); % basic abaqus settings
fid=fopen(sprintf('%s.inp',fileName),'wW');

%%
% Print Material properties (CDP)
abaInpMatCDP(fid, abaData.Bone.MAT);

% Print Material properties (Linear Elastic)
abaInpMatLE(fid, abaData.Screw.MAT);


fclose(fid);
disp('Check the inp file!');

