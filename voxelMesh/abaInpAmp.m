function abaInpAmp(fid)
% Print Abaqus .inp amplitude part
% input fid:        File ID

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');

% Print Heading of Amplitude section
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '** \n');

outputKWs = [...
    '*Amplitude, name=Amp-1, definition=SMOOTH STEP\n'...
    '0.,              0.,              1.,              1.\n'...
    ];
fprintf(fid, outputKWs);


% Print Ending of Amplitude section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end