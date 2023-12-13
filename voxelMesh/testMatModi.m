clear all
close all
clc
%% Example 01
% figure(1)
% clf
fileName = 'matCDP';
abaData = [];
inputData = [...
1.6000
0.6000
1.2000
0.0500
0.200
...
]; 
% Density, tension/compression ratio, ultimate/Yielding ratio, 
% ultimate strain, post-ultimate strain
abaData = abaInpData(abaData, inputData); % basic abaqus settings


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
%%
% saveas(gcf,'MATModel_Des24MedDelStr.png');
% saveas(gcf,'MATModel_TenYieldPlas.png');
