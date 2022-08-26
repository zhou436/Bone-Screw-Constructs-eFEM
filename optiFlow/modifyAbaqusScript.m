function [status] = modifyAbaqusScript(EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe)
%%
% EMod = 200;
% yieldStress = 3;
% hardStress = 5;
% ultimStrain = 0.015;
% dispAFail = 0.5;
fileID1 = fopen('abaqusMacros20220720.py','r');
fileID2 = fopen('abaqusScriptOpti.py','w');
% fprintf(fileID,'%s\n',A);
tline = fgetl(fileID1);
while ischar(tline)
    % rules to change the parameters
    tlineChecked = strrep(tline,'table=((300.0, 0.3), )',sprintf('table=((%f, 0.3), )',EMod));
    tlineChecked = strrep(tlineChecked,'table=((2.0, 0.0), (4.0, 0.5))',sprintf('table=((%f, 0.0), (%f, 0.5))',yieldStress,hardStress));
    tlineChecked = strrep(tlineChecked,'table=((0.15, 0.0, 0.0), )',sprintf('table=((%f, 0.0, 0.0), )',ultimStrain));
    tlineChecked = strrep(tlineChecked,'table=((0.01, ), )',sprintf('table=((%f, ), )',dispAFail));
    tlineChecked = strrep(tlineChecked,'table=((0.3, ), ), shearStressLimit=None',sprintf('table=((%f, ), ), shearStressLimit=None',fricCoe));
    % write file
    fprintf(fileID2, '%s\n', tlineChecked);
    tline = fgetl(fileID1);
end
fclose(fileID1);
fclose(fileID2);
system('DEL /Q Job-1.lck');
disp('EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe');
disp([EMod, yieldStress, hardStress, ultimStrain, dispAFail, fricCoe]);
status = system('abaqus cae noGUI=abaqusScriptOpti.py');
end