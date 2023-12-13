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
sigmaPC = sigmaYC*0.8;
epsilonPC = sigmaPC/EL;
epsilonYC = 0.0104; % epsilonYC is 0.0104
sigmaUC = MAT.comp.sigmaU;

sigmaPYDC = sigmaYC - sigmaPC;
sigmaYUDC = sigmaUC - sigmaYC;

epsilonUC = MAT.comp.epsilonU;
% if sigmaUC/epsilonUC >= sigmaYC/epsilonYC
%     disp("too small ultimate strain");
% end
sigmaFC = MAT.comp.sigmaF;
epsilonFC = MAT.comp.epsilonF;

elaCNum = 3;
MAT.comp.elaCNum = elaCNum;
plaCNum = floor(sigmaPYDC/1);
yieCNum = floor(sigmaYUDC/1);
faiCNum = floor(sigmaUC*0.95/1);

% create table for compression
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
MAT.comp.CDPtable = zeros([elaCNum+plaCNum+yieCNum+faiCNum-3,6]);
MAT.comp.CDPtable(1:elaCNum,1) = linspace(0,epsilonPC,elaCNum);
MAT.comp.CDPtable(1:elaCNum,2) = linspace(0,sigmaPC,elaCNum);
% plastic stage
MAT.comp.CDPtable(elaCNum:elaCNum+plaCNum-1,2) = linspace(sigmaPC,sigmaYC,plaCNum);
MAT.comp.CDPtable(elaCNum:elaCNum+plaCNum-1,1) = linspace(epsilonPC,epsilonYC,plaCNum);
% yield stage
MAT.comp.CDPtable(elaCNum+plaCNum-1:elaCNum+plaCNum+yieCNum-2,2) = linspace(sigmaYC,sigmaUC,yieCNum);
MAT.comp.CDPtable(elaCNum+plaCNum-1:elaCNum+plaCNum+yieCNum-2,1) = linspace(epsilonYC,epsilonUC,yieCNum);
% failure stage
MAT.comp.CDPtable(elaCNum+plaCNum+yieCNum-2:elaCNum+plaCNum+yieCNum+faiCNum-3,2) = linspace(sigmaUC,sigmaFC,faiCNum);
MAT.comp.CDPtable(elaCNum+plaCNum+yieCNum-2:elaCNum+plaCNum+yieCNum+faiCNum-3,1) = linspace(epsilonUC,epsilonFC,faiCNum);
% damage
MAT.comp.CDPtable(:,3) = 1 - MAT.comp.CDPtable(:,2)/sigmaUC;
MAT.comp.CDPtable(1:elaCNum+plaCNum+yieCNum-2,3) = 0;
% elastic strain
MAT.comp.CDPtable(:,4) = MAT.comp.CDPtable(:,2)/EL;
% inelastic strain
MAT.comp.CDPtable(:,5) = MAT.comp.CDPtable(:,1)-MAT.comp.CDPtable(:,4);
% plastic strain
MAT.comp.CDPtable(:,6) = MAT.comp.CDPtable(:,5)-MAT.comp.CDPtable(:,3)./(1-MAT.comp.CDPtable(:,3))...
    .*MAT.comp.CDPtable(:,2)/EL;

% create table for tension
sigmaYT = MAT.tens.sigmaY;
sigmaPT = sigmaYT*0.8;
epsilonPT = sigmaPT/EL;
epsilonYT = 0.0073; % epsilonYT is 0.073
sigmaUT = MAT.tens.sigmaU;

sigmaPYDT = sigmaYT - sigmaPT;
sigmaYUDT = sigmaUT - sigmaYT;

epsilonUT = MAT.tens.epsilonU;
sigmaFT = MAT.tens.sigmaF;
epsilonFT = MAT.tens.epsilonF;

elaTNum = 3;
MAT.tens.elaTNum = elaTNum;
plaTNum = floor(sigmaPYDT/1);
yieTNum = floor(sigmaYUDT/1);
faiTNum = floor(sigmaUT*0.95/1);

% create table for tension
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
MAT.tens.CDPtable = zeros([elaTNum+plaTNum+yieTNum+faiTNum-3,6]);
MAT.tens.CDPtable(1:elaTNum,1) = linspace(0,epsilonPT,elaTNum);
MAT.tens.CDPtable(1:elaTNum,2) = linspace(0,sigmaPT,elaTNum);
% plastic stage
MAT.tens.CDPtable(elaTNum:elaTNum+plaTNum-1,2) = linspace(sigmaPT,sigmaYT,plaTNum);
MAT.tens.CDPtable(elaTNum:elaTNum+plaTNum-1,1) = linspace(epsilonPT,epsilonYT,plaTNum);
% yield stage
MAT.tens.CDPtable(elaTNum+plaTNum-1:elaTNum+plaTNum+yieTNum-2,2) = linspace(sigmaYT,sigmaUT,yieTNum);
MAT.tens.CDPtable(elaTNum+plaTNum-1:elaTNum+plaTNum+yieTNum-2,1) = linspace(epsilonYT,epsilonUT,yieTNum);
% failure stage
MAT.tens.CDPtable(elaTNum+plaTNum+yieTNum-2:elaTNum+plaTNum+yieTNum+faiTNum-3,2) = linspace(sigmaUT,sigmaFT,faiTNum);
MAT.tens.CDPtable(elaTNum+plaTNum+yieTNum-2:elaTNum+plaTNum+yieTNum+faiTNum-3,1) = linspace(epsilonUT,epsilonFT,faiTNum);
% damage
MAT.tens.CDPtable(:,3) = 1 - MAT.tens.CDPtable(:,2)/sigmaUT;
MAT.tens.CDPtable(1:elaTNum+plaTNum+yieTNum-2,3) = 0;
% elastic strain
MAT.tens.CDPtable(:,4) = MAT.tens.CDPtable(:,2)/EL;
% inelastic strain
MAT.tens.CDPtable(:,5) = MAT.tens.CDPtable(:,1)-MAT.tens.CDPtable(:,4);
% plastic strain
MAT.tens.CDPtable(:,6) = MAT.tens.CDPtable(:,5)-MAT.tens.CDPtable(:,3)./(1-MAT.tens.CDPtable(:,3))...
    .*MAT.tens.CDPtable(:,2)/EL;


%% Check if Ascending comp
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
figure()
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
CDPCPSCP = sort(CDPCPSCP);
if isequal(CDPCPS, CDPCPSCP)
    disp('Good compression CDP');
else
    disp('Error!');
end
%% Check if Ascending tens
% strain, stress, damage, elastic strain, inelastic strain, plastic strain
figure()
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
CDPCPSCP = sort(CDPCPSCP);
if isequal(CDPCPS, CDPCPSCP)
    disp('Good tensile CDP');
else
    disp('Error!');
end
%%
stressStrainCurve = figure();
plot(MAT.comp.CDPtable(:,1), MAT.comp.CDPtable(:,2), 'LineWidth', 2);
hold on
plot(-MAT.tens.CDPtable(:,1), -MAT.tens.CDPtable(:,2), 'LineWidth', 2);
hold on
legend('Compression', 'Tension',"Location","southeast");
xlabel('Strain [-]');
ylabel('Stress [MPa]');
grid on
hold on
set(gca,"FontSize",15)
saveas(stressStrainCurve, 'stressStrainCurve.png');
% close stressStrainCurve;
end