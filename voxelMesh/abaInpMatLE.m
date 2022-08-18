function abaInpMatLE(fid, matName)
% Print Abaqus .inp material part
% input fid:        File ID
% input matName:    Material name, a string

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');
% matName = 'Bone';
% Print Heading of material section
fprintf(fid, ...
    ['** ----------------------------------------------------------------\n'...
    '** \n'...
    '** MATERIALS\n'...
    '** \n'...
    '*Material, name=%s\n'], matName);

% Print density
varDensity = 1.89e-09;
fprintf(fid, '*Density\n');
fprintf(fid, '%f,\n', varDensity);

% Print Young's modulus and Poisson's ratio
varEmPr = [300, 0.3]; % Young's modulus and Poisson's ratio
fprintf(fid, '*Elastic\n');
fprintf(fid, '%f, %f\n', varEmPr);

% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end