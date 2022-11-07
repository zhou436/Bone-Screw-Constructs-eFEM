function abaInpMatCDP(MAT, fileName)
% Print Abaqus .inp material part
% input fid:        File ID
% input MAT.matName:    Material name, a string
% input MAT.varDens:    Material density (important for explicit simulation)
% input MAT.vaEL:       Elastic properties [Young's modulus, Poisson's ratio]
% input MAT.varCDPPlas: CDP plasticity [Dilation Angle, Eccentricity, fb0/fc0, K, Viscosity Parameter]
% input MAT.varCDPCHard:CDP compressive hardening table [Yield Stress, Inelastic Strain]
% input MAT.varCDPTSti: CDP tension stiffening table [Yield Stress, Cracking Strain]
% input MAT.varCDPCDam: CDP compression damage [Damage Parameter, Inelastic Strain]
% input MAT.varCDPTDam: CDP tension damage [Damage Parameter, Cracking Strain]
% input MAT.varCDPFai:  CDP strain table 
%                       [Ultimate Inelastic Strain, Ultimate Cracking Strain, 
%                       Correspnding Damage Parameter, Correspnding Damage Parameter]

fid=fopen(sprintf('%s.inp',fileName),'w+');
% Print Heading of material section
fprintf(fid, ...
    ['** ----------------------------------------------------------------\n'...
    '** \n'...
    '** MATERIALS\n'...
    '** \n'...
    '*Material, name=%s\n'], MAT.matName);

% Print density
fprintf(fid, '*Density\n');
fprintf(fid, '%s,\n', MAT.varDens);

% Print Young's modulus and Poisson's ratio
fprintf(fid, '*Elastic\n');
fprintf(fid, '%f, %f\n', MAT.vaEL);

% Print CDP plasticity table
fprintf(fid, '*Concrete Damaged Plasticity\n');
fprintf(fid, '%f, %f, %f, %f, %f\n', MAT.varCDPPlas);

% Print CDP compressive hardening table
fprintf(fid, '*Concrete Compression Hardening\n');
fprintf(fid, '%f, %f\n', MAT.varCDPCHard');

% Print CDP tension stiffening table
fprintf(fid, '*Concrete Tension Stiffening\n');
fprintf(fid, '%f, %f\n', MAT.varCDPTSti');

% Print CDP compression damage table
fprintf(fid, '*Concrete Compression Damage\n');
fprintf(fid, '%f, %f\n', MAT.varCDPCDam');

% Print CDP tension damage table
fprintf(fid, '*Concrete Tension Damage\n');
fprintf(fid, '%f, %f\n', MAT.varCDPTDam');

% Print CDP failure table
fprintf(fid, '*Concrete Failure, TYPE=Strain\n');
fprintf(fid, '%f, %f, %f, %f\n', MAT.varCDPFai);

% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
fclose(fid);
end