function abaInpEleCon(fid, Parts)
% Print Abaqus .inp material part
% input fid:        File ID

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');

% Print Heading of element control section
fprintf(fid, '** ----------------------------------------------------------------\n');

for ii=1: Parts.partNum
    fprintf(fid, '** \n');
    outputKWs = [...
        '** ELEMENT CONTROLS\n'...
        '**\n'...
        '*Section Controls, name=EC-%d, DISTORTION CONTROL=YES, ELEMENT DELETION=YES, MAX DEGRADATION=0.8, second order accuracy=YES\n'...
        '1., 1., 1.\n'...
        ];
    fprintf(fid, outputKWs, ii);
    fprintf(fid, '** \n');
end

% Print Ending of element control section
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end