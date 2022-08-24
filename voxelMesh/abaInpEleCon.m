function abaInpEleCon(fid, Part)
% Print Abaqus .inp material part
% input fid:        File ID

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');

% Print Heading of element control section
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '** \n');

% Print element control section
outputKWs = [...
    '** ELEMENT CONTROLS\n'...
    '**\n'...
    '*Section Controls, name=EC-%d, DISTORTION CONTROL=YES, ELEMENT DELETION=%s, MAX DEGRADATION=0.8, second order accuracy=YES\n'...
    '1., 1., 1.\n'...
    ];
fprintf(fid, outputKWs, [Part.setNum, Part.eleDel]);



% Print Ending of element control section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end