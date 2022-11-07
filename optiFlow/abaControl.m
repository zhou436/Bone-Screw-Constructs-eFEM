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
% 100;...         % tension yield (ultimate) stress [MPa]
% 0.01;...        % tension (deletion - ultimate) strain [-]
% 0.3;...         % friction coefficient

%%
addpath('./../voxelMesh');
%% input parameters
abaData.Bone.MAT.vaEL = [arx(1), 0.3]; % Young's modulus and Poisson's ratio
abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
abaData.Bone.MAT.comp.sigmaY = arx(2);          % compression yield stress [MPa]
abaData.Bone.MAT.comp.sigmaUYD = arx(3);        % compression (ultimate - yield) stress [MPa]
abaData.Bone.MAT.comp.sigmaU = abaData.Bone.MAT.comp.sigmaY + abaData.Bone.MAT.comp.sigmaUYD; % compression ultimate stress [MPa]
abaData.Bone.MAT.comp.epsilonU = arx(4) + ...
    abaData.Bone.MAT.comp.sigmaY/abaData.Bone.MAT.vaEL(1);                  % compression ultimate strain [-]
abaData.Bone.MAT.comp.sigmaF = abaData.Bone.MAT.comp.sigmaU * 0.05;         % compression failure(deletion) stress [MPa]
abaData.Bone.MAT.comp.epsilonF = arx(5) + abaData.Bone.MAT.comp.epsilonU;   % compression failure (deletion) strain [-]
abaData.Bone.MAT.tens.sigmaY = arx(6);          % tension yield (ultimate) stress [MPa]
abaData.Bone.MAT.tens.sigmaF = abaData.Bone.MAT.tens.sigmaY * 0.05;         % tension failure(deletion) stress [MPa]
abaData.Bone.MAT.tens.epsilonF = arx(7) + ...
    abaData.Bone.MAT.tens.sigmaY/abaData.Bone.MAT.vaEL(1);      % tension failure (deletion) strain [-]
abaData.fricCoeef = arx(8);                     % friction coeefficient 
%% Output Abaqus input file
inputFlag = 1;
abaData = abaInpData(abaData, inputFlag); % basic abaqus settings
%% modify CDP material model
fNCDP = 'matCDP';
% fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNCDP));
abaInpMatCDP(abaData.Bone.MAT, fNCDP);
%% modify interaction model
fNinter = 'interFric';
abaInpInteraction(abaData.fricCoeef, fNinter);
%% display input parameters
system('DEL /Q Job-1.lck');
disp('EMod');
disp(abaData.Bone.MAT.vaEL(1));
disp('compression yield Stress, compression ultimate stress, compression ultimate strain, compression failure(deletion) stress');
disp([abaData.Bone.MAT.comp.sigmaY, abaData.Bone.MAT.comp.sigmaU, abaData.Bone.MAT.comp.epsilonU, ...
    abaData.Bone.MAT.comp.epsilonF]);
disp('tensile yield Stress, tensile failure(deletion) stress, tension failure (deletion) strain');
disp([abaData.Bone.MAT.tens.sigmaY, abaData.Bone.MAT.tens.sigmaF, abaData.Bone.MAT.tens.epsilonF]);
disp('friction coefficient');
disp(abaData.fricCoeef);
%% run abaqus simulation (pseudo)
% system('abaqus job=printInpTemp double cpus=24');
disp('Abaqus simulation finished!');
%% read simulation results and output objective value
% [expNumDiff] = readAbaqusData(counteval);
expNumDiff = 1;
end