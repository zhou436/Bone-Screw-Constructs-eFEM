function abaInpMatLE(fid, MAT)
% Print Abaqus .inp material part
% input fid:            File ID
% input MAT.matName:    Material name, a string
% input MAT.varDens:    Material density (important for explicit simulation)
% input MAT.vaEL:       Elastic properties [Young's modulus, Poisson's ratio]

% Print Heading of material section
fprintf(fid, ...
    ['** ----------------------------------------------------------------\n'...
    '** \n'...
    '** MATERIALS\n'...
    '** \n'...
    '*Material, name=%s\n'], MAT.matName);

% Print density
% varDens = 1.89e-09;
fprintf(fid, '*Density\n');
fprintf(fid, '%f,\n', varDens);

% Print Young's modulus and Poisson's ratio
fprintf(fid, '*Elastic\n');
fprintf(fid, '%f, %f\n', vaEL);

% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end