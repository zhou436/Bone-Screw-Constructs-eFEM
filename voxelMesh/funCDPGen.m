function MAT = funCDPGen(MAT)
% clear all
% close all
% clc
% notes
% remove all values of the damage parameter greater than 0.98
% ensure that the difference between two consecutive values of the damage
% is greater than 0.001 (did not check yet)
%%
EL = MAT.vaEL(1);

sigmaYC = MAT.comp.sigmaY;
epsilonYC = sigmaYC/EL;
sigmaUYDC = MAT.comp.sigmaUYD;
sigmaUC = MAT.comp.sigmaU;
epsilonUC = MAT.comp.epsilonU;
sigmaFC = MAT.comp.sigmaF;
epsilonFC = MAT.comp.epsilonF;

elaCNum = 3;
MAT.comp.elaCNum = elaCNum;
yieCNum = floor(sigmaUYDC/1);
faiCNum = floor(sigmaUC*0.95/1);

% create table for compression
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
MAT.comp.CDPtable = zeros([elaCNum+yieCNum+faiCNum-2,6]);
MAT.comp.CDPtable(1:elaCNum,1) = linspace(0,epsilonYC,elaCNum);
MAT.comp.CDPtable(1:elaCNum,2) = linspace(0,sigmaYC,elaCNum);
% yield stage
MAT.comp.CDPtable(elaCNum:elaCNum+yieCNum-1,2) = linspace(sigmaYC,sigmaUC,yieCNum);
MAT.comp.CDPtable(elaCNum:elaCNum+yieCNum-1,1) = linspace(epsilonYC,epsilonUC,yieCNum);
% failure stage
MAT.comp.CDPtable(elaCNum+yieCNum-1:elaCNum+yieCNum+faiCNum-2,2) = linspace(sigmaUC,sigmaFC,faiCNum);
MAT.comp.CDPtable(elaCNum+yieCNum-1:elaCNum+yieCNum+faiCNum-2,1) = linspace(epsilonUC,epsilonFC,faiCNum);
% damage
MAT.comp.CDPtable(:,3) = 1 - MAT.comp.CDPtable(:,2)/sigmaUC;
MAT.comp.CDPtable(1:elaCNum+yieCNum-1,3) = 0;
% elastic strain
MAT.comp.CDPtable(:,4) = MAT.comp.CDPtable(:,2)/EL;
% inelastic strain
MAT.comp.CDPtable(:,5) = MAT.comp.CDPtable(:,1)-MAT.comp.CDPtable(:,4);
% plastic strain
MAT.comp.CDPtable(:,6) = MAT.comp.CDPtable(:,5)-MAT.comp.CDPtable(:,3)./(1-MAT.comp.CDPtable(:,3))...
    .*MAT.comp.CDPtable(:,2)/EL;

% create table for tension
sigmaYT = MAT.tens.sigmaY;
epsilonYT = sigmaYT/EL;
sigmaFT = MAT.tens.sigmaF;
epsilonFT = MAT.tens.epsilonF;

elaTNum = 3;
MAT.tens.elaTNum = elaTNum;
faiTNum = floor(sigmaYT*0.95/1);

% create table for compression
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
MAT.tens.CDPtable = zeros([elaTNum+faiTNum-1,6]);
MAT.tens.CDPtable(1:elaTNum,1) = linspace(0,epsilonYT,elaTNum);
MAT.tens.CDPtable(1:elaTNum,2) = linspace(0,sigmaYT,elaTNum);
% failure stage
MAT.tens.CDPtable(elaTNum:elaTNum+faiTNum-1,2) = linspace(sigmaYT,sigmaFT,faiTNum);
MAT.tens.CDPtable(elaTNum:elaTNum+faiTNum-1,1) = linspace(epsilonYT,epsilonFT,faiTNum);
% damage
MAT.tens.CDPtable(:,3) = 1 - MAT.tens.CDPtable(:,2)/sigmaYT;
MAT.tens.CDPtable(1:elaTNum,3) = 0;
% elastic strain
MAT.tens.CDPtable(:,4) = MAT.tens.CDPtable(:,2)/EL;
% inelastic strain
MAT.tens.CDPtable(:,5) = MAT.tens.CDPtable(:,1)-MAT.tens.CDPtable(:,4);
% plastic strain
MAT.tens.CDPtable(:,6) = MAT.tens.CDPtable(:,5)-MAT.tens.CDPtable(:,3)./(1-MAT.tens.CDPtable(:,3))...
    .*MAT.tens.CDPtable(:,2)/EL;

%% Check if Ascending comp
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
figure(1)
plot(MAT.comp.CDPtable(:,1), 'LineWidth', 2);
hold on
plot(MAT.comp.CDPtable(:,4), 'LineWidth', 2);
hold on
plot(MAT.comp.CDPtable(:,5), 'LineWidth', 2);
hold on
plot(MAT.comp.CDPtable(:,6), 'LineWidth', 2);
legend('Strain', 'Elastic Strain', 'Inelastic strain', 'Plastic strain');
ylim([0, inf]);
CDPCPS = MAT.comp.CDPtable(:,6);
CDPCPSCP = CDPCPS;
sort(CDPCPSCP);
if isequal(CDPCPS, CDPCPSCP)
    disp('Good CDP');
else
    disp('Error!');
end
%% Check if Ascending tens
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
figure(2)
plot(MAT.tens.CDPtable(:,1), 'LineWidth', 2);
hold on
plot(MAT.tens.CDPtable(:,4), 'LineWidth', 2);
hold on
plot(MAT.tens.CDPtable(:,5), 'LineWidth', 2);
hold on
plot(MAT.tens.CDPtable(:,6), 'LineWidth', 2);
legend('Strain', 'Elastic Strain', 'Inelastic strain', 'Plastic strain');
ylim([0, inf]);
CDPCPS = MAT.tens.CDPtable(:,6);
CDPCPSCP = CDPCPS;
sort(CDPCPSCP);
if isequal(CDPCPS, CDPCPSCP)
    disp('Good CDP');
else
    disp('Error!');
end
%%
stressStrainCurve = figure(3);
plot(MAT.comp.CDPtable(:,1), MAT.comp.CDPtable(:,2), 'LineWidth', 2);
hold on
plot(-MAT.tens.CDPtable(:,1), -MAT.tens.CDPtable(:,2), 'LineWidth', 2);
hold on
legend('Compression', 'Tension');
xlabel('Strain [-]');
ylabel('Stress [MPa]');
grid on
saveas(stressStrainCurve, 'stressStrainCurve.png')
end