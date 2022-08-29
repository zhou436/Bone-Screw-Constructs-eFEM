clear all
close all
clc
%% basic control
% iniVal=rand(nVar,1); % objective variables initial point
iniVal=[100; 10; 25; 0.05; 0.01; 0.2]; % EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe
BC = [10,2e2; 5,15; 15,30; 0.01,0.30; 0,0.1; 0.01,0.6]; % BC, EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe
sigma=0.5;  % coordinate wise standard deviation (step size)
normalPara = [(BC(1,2)-BC(1,1)); (BC(2,2)-BC(2,1)); (BC(3,2)-BC(3,1)); (BC(4,2)-BC(4,1)); (BC(5,2)-BC(5,1)); (BC(6,2)-BC(6,1))];
iniVal = iniVal./normalPara;
nVar=size(iniVal,1);  % number of objective variables/problem dimension

stopfitness = 1e-10;  % stop if fitness < stopfitness (minimization)
% stopeval = 1e3*nVar^2;   % stop after stopeval number of function evaluations
stopeval = 100;
penaltyValBas = 5e3;
ObjFun = 'abaqusControl';
if ~isfile('./dataOutput/dataMatrixOutput.xlsx')
     writematrix([iniVal'*0, penaltyValBas], './dataOutput/dataMatrixOutput.xlsx');
%      fclose(fileID);
end
%%
[xmin,ymin]=cmaes(nVar, iniVal, BC, sigma, stopfitness, stopeval, penaltyValBas, normalPara,ObjFun);
%%
