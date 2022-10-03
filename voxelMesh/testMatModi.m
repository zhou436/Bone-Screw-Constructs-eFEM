clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'matCDP';
abaData = [];
abaData = abaInpData(abaData); % basic abaqus settings
% fid=fopen(sprintf('%s.inp',fileName),'wW');

%%
% Print Material properties (CDP)
% abaInpMatCDP(fid, abaData.Bone.MAT);
fNCDP = 'matCDP';
% fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNCDP));
abaInpMatCDP(abaData.Bone.MAT, fNCDP);

% Print Material properties (Linear Elastic)
fNLE = 'matLE';
% fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNLE));
abaInpMatLE(abaData.Screw.MAT, fNLE);

% fclose(fid);
disp('Check the inp file!');

