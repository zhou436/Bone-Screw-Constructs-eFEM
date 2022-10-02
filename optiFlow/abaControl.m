function expNumDiff = abaControl(arx,counteval)
% clear all
% close all
% clc
%%
% 10000;...       % Young's modulus
% 125;...         % compression yield stress [MPa]
% 20;...          % compression (ultimate - yield) stress [MPa]
% 0.02;...        % compression (ultimate - yield) strain [-]
% 0.05;...        % compression (deletion - ultimate) strain [-]
% 100;...         % tension yield stress [MPa]
% 0.01;...        % tension (deletion - ultimate) strain [-]
% 0.3;...         % friction coefficient

%%
abaData.Bone.MAT.vaEL = [arx(1), 0.3]; % Young's modulus and Poisson's ratio
% abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
abaData.Bone.MAT.comp.sigmaY = arx(2);          % compression yield stress [MPa]
abaData.Bone.MAT.comp.sigmaUYD = arx(3);        % compression (ultimate - yield) stress [MPa]
abaData.Bone.MAT.comp.epsilonU = arx(4);        % compression ultimate strain [-]
abaData.Bone.MAT.comp.epsilonF = arx(5);        % compression failure (deletion) strain [-]
abaData.Bone.MAT.tens.sigmaY = arx(6);          % tension yield stress [MPa]
abaData.Bone.MAT.tens.epsilonF = arx(7);        % tension failure (deletion) strain [-]
abaData.fricCoeef = arx(8);                     % friction coeefficient 
%%
addpath('./../voxelMesh');
%% Output Abaqus input file
abaData = abaInpData(abaData); % basic abaqus settings
% abaInpMatCDP(fid, abaData.Bone.MAT);
fNCDP = 'matCDP';
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNCDP));
abaInpMatCDP(abaData.Bone.MAT, fNCDP);
%% run abaqus simulation
system('DEL /Q Job-1.lck');
disp('EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe');
disp([EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe]);
system('abaqus job=printInpTemp double cpus=24');
%% read simulation results and output objective value
[expNumDiff] = readAbaqusData(counteval);
end