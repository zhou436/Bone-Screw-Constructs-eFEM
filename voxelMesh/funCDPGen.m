function CDPModel = funCDPGen(MAT)
MAT.EL = 10000;             % Elastic modulus
MAT.comp.sigmaY = 100;      % compression yield stress [MPa]
MAT.comp.sigmaUYD = 0;     % compression ultimate stress [MPa]
MAT.comp.sigmaU = MAT.comp.sigmaY + MAT.comp.sigmaUYD;
MAT.comp.epsilonU = 0.02;   % compression ultimate strain [-]
MAT.comp.sigmaF = MAT.comp.sigmaU * 0.05;   % compression failure(deletion) stress [MPa]
MAT.comp.epsilonF = 0.05;    % compression failure (deletion) strain [-]

MAT.tens.sigmaY = 100;        % compression yield stress [MPa]
MAT.tens.sigmaF = MAT.tens.sigmaY * 0.05;     % compression failure(deletion) stress [MPa]
MAT.tens.epsilonF = 0.025;    % compression failure (deletion) strain [-]
%
EL = MAT.EL;

sigmaYC = MAT.comp.sigmaY;
epsilonYC = sigmaYC/EL;
sigmaUYDC = MAT.comp.sigmaUYD;
sigmaUC = MAT.comp.sigmaU;
epsilonUC = MAT.comp.epsilonU;
sigmaFC = MAT.comp.sigmaF;
epsilonFC = MAT.comp.epsilonF;

sigmaYT = MAT.tens.sigmaY;
sigmaFT = MAT.tens.sigmaF;
epsilonFT = MAT.tens.epsilonF;

elaCNum = 3;
yieCNum = ceil(sigmaUYDC/1);
faiCNum = ceil(sigmaUC*0.95/1);

% create table for compression
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
MAT.comp.CDPtable = zeros([elaCNum+yieCNum+faiCNum-2,6]);
MAT.comp.CDPtable(1:elaCNum,2) = linspace(0,sigmaYC,elaCNum);
MAT.comp.CDPtable(1:elaCNum,1) = linspace(0,epsilonYC,elaCNum);
% yield stage
MAT.comp.CDPtable(elaCNum:elaCNum+yieCNum-1,2) = linspace(sigmaYC,sigmaUC,yieCNum);
MAT.comp.CDPtable(elaCNum:elaCNum+yieCNum-1,1) = linspace(epsilonYC,epsilonUC,yieCNum);
% failure stage
MAT.comp.CDPtable(elaCNum+yieCNum-1:elaCNum+yieCNum+faiCNum-2,2) = linspace(sigmaUC,sigmaFC,faiCNum);
MAT.comp.CDPtable(elaCNum+yieCNum-1:elaCNum+yieCNum+faiCNum-2,1) = linspace(epsilonUC,epsilonFC,faiCNum);
% damage
MAT.comp.CDPtable(:,3) = MAT.comp.CDPtable(:,2)/sigmaUC;
MAT.comp.CDPtable(1:elaCNum+yieCNum-1,3) = 0;
% elastic strain
MAT.comp.CDPtable(:,4) = MAT.comp.CDPtable(:,2)/EL;
% inelastic strain
MAT.comp.CDPtable(:,5) = MAT.comp.CDPtable(:,1)-MAT.comp.CDPtable(:,4);
% plastic strain
MAT.comp.CDPtable(:,6) = MAT.comp.CDPtable(:,5)-MAT.comp.CDPtable(:,3)./(1-MAT.comp.CDPtable(:,3))...
    .*MAT.comp.CDPtable(:,2)/EL;

plot(MAT.comp.CDPtable(:,6));


% create table for tension
MAT.tens.strainArr = [];

% notes
% remove all values of the damage parameter greater than 0.98
% ensure that the difference between two consecutive values of the damage
% is greater than 0.001

end