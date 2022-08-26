function [expNumDiff] = abaqusControl(arx,counteval)
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