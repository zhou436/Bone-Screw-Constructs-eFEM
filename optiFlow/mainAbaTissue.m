clear all
close all
clc

%% Set initial parameters for bone material
% initial designs
iniVal=[...
    10000;...       % Young's modulus
    125;...         % compression yield stress [MPa]
    20;...          % compression (ultimate - yield) stress [MPa]
    0.02;...        % compression (ultimate - yield) strain [-]
    0.05;...        % compression (deletion - ultimate) strain [-]
    100;...         % tension yield stress [MPa]
    0.01;...        % tension (deletion - ultimate) strain [-]
    0.3;...         % friction coefficient
    ]; 
% boundary conditions
BC = [...
    4e3,25e3;...    % Young's modulus
    50,200;...      % compression yield stress [MPa]
    5,50;...        % compression (ultimate - yield) stress [MPa]
    0.005,0.02;...  % compression (ultimate - yield) strain [-]
    0.01,0.1;...    % compression (deletion - ultimate) strain [-]
    25,150;...      % tension yield stress [MPa]
    0.01,0.1;...    % tension (deletion - ultimate) strain [-]
    0.01,0.6;...    % friction coefficient
    ];
sigma=0.5;  % coordinate wise standard deviation (step size)
normalPara = [...
    (BC(1,2)-BC(1,1));...
    (BC(2,2)-BC(2,1));...
    (BC(3,2)-BC(3,1));...
    (BC(4,2)-BC(4,1));...
    (BC(5,2)-BC(5,1));...
    (BC(6,2)-BC(6,1));...
    (BC(7,2)-BC(7,1));...
    (BC(8,2)-BC(8,1));...
    ];
iniVal = iniVal./normalPara;
nVar=size(iniVal,1);  % number of objective variables/problem dimension

stopfitness = 1e-10;  % stop if fitness < stopfitness (minimization)
% stopeval = 1e3*nVar^2;   % stop after stopeval number of function evaluations
stopeval = 100;
ObjFun = 'abaControl';
if ~isfile('./dataOutput/dataMatrixOutput.xlsx')
     writematrix([iniVal'*0, 0], './dataOutput/dataMatrixOutput.xlsx');
end
%%
[xmin,ymin]=cmaes(nVar, iniVal, BC, sigma, stopfitness, stopeval, normalPara, ObjFun);
%%
% abaData.Bone.MAT.vaEL = [10000, 0.3]; % Young's modulus and Poisson's ratio
% % abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
% abaData.Bone.MAT.comp.sigmaY = 100;         % compression yield stress [MPa]
% abaData.Bone.MAT.comp.sigmaUYD = 20;        % compression ultimate stress [MPa]
% abaData.Bone.MAT.comp.epsilonU = 0.02;      % compression ultimate strain [-]
% abaData.Bone.MAT.comp.epsilonF = 0.05;      % compression failure (deletion) strain [-]
% abaData.Bone.MAT.tens.sigmaY = 50;          % tension yield stress [MPa]
% abaData.Bone.MAT.tens.epsilonF = 0.01;      % tension failure (deletion) strain [-]