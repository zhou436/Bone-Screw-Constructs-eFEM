function abaInpMatCDP(fid, matName)
% Print Abaqus .inp material part
% input fid:        File ID
% input matName:    Material name, a string

% fileName = 'printInpTemp';
% fid=fopen(sprintf('%s.inp',fileName),'wW');
matName = 'Bone';
% Print Heading of material section
fprintf(fid, ...
    ['** ----------------------------------------------------------------\n'...
    '** \n'...
    '** MATERIALS\n'...
    '** \n'...
    '*Material, name=%s\n'], matName);

% Print density
varDensity = '1.89e-09';
fprintf(fid, '*Density\n');
fprintf(fid, '%s,\n', varDensity);

% Print Young's modulus and Poisson's ratio
varEmPr = [300, 0.3]; % Young's modulus and Poisson's ratio
fprintf(fid, '*Elastic\n');
fprintf(fid, '%f, %f\n', varEmPr);

% Print CDP plasticity table
varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
fprintf(fid, '*Concrete Damaged Plasticity\n');
fprintf(fid, '%f, %f, %f, %f, %f\n', varCDPPlas);

% Print CDP compressive hardening table
varCDPCHard = [...
    6.0, 0.0;
    8.0, 0.00833333;
    10.0, 0.0166667;
    6.75, 0.0441667;
    3.5, 0.0716667;
    0.25, 0.0991667;
    ];
fprintf(fid, '*Concrete Compression Hardening\n');
fprintf(fid, '%f, %f\n', varCDPCHard');

% Print CDP tension stiffening table
varCDPTSti = [...
    6.0, 0.0;
    4.06667, 0.0164444;
    2.13333, 0.0328889;
    0.2, 0.0493333;
    ];
fprintf(fid, '*Concrete Tension Stiffening\n');
fprintf(fid, '%f, %f\n', varCDPTSti');

% Print CDP compression damage table
varCDPCDam = [...
    0.0, 0.0;
    0.0, 0.00833333;
    0.0, 0.0166667;
    0.325, 0.0441667;
    0.65, 0.0716667;
    0.975, 0.0991667;
    ];
fprintf(fid, '*Concrete Compression Damage\n');
fprintf(fid, '%f, %f\n', varCDPCDam');

% Print CDP tension damage table
varCDPTDam = [...
    0.0, 0.0;
    0.322222, 0.0164444;
    0.644444, 0.0328889;
    0.966667, 0.0493333;
    ];
fprintf(fid, '*Concrete Tension Damage\n');
fprintf(fid, '%f, %f\n', varCDPTDam');

% Print CDP failure table
varCDPFai = [0.0493333,0.0991667,0.966667,0.975];
fprintf(fid, '*Concrete Failure, TYPE=Strain\n');
fprintf(fid, '%f, %f, %f, %f\n', varCDPFai);

% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
% fclose(fid);
end