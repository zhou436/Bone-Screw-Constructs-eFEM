function [expNumDiff] = abaqusControl(arx,counteval)

% 10000;...       % Young's modulus
% 125;...         % compression yield stress [MPa]
% 20;...          % compression (ultimate - yield) stress [MPa]
% 0.02;...        % compression (ultimate - yield) strain [-]
% 0.05;...        % compression (deletion - ultimate) strain [-]
% 100;...         % tension yield stress [MPa]
% 0.01;...        % tension (deletion - ultimate) strain [-]
% 0.3;...         % friction coefficient

EMod = arx(1);
yieldStress = arx(2);
hardStress = arx(3);
ultimStrain = arx(4);
dispAFail = arx(5);
fricCoe = arx(6);
[status] = modifyAbaqusScript(EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe);
disp(status);
[expNumDiff] = readAbaqusData(counteval);
end