function abaData = abaInpData(abaData)
%% Abaqus parameters Bone
abaData.Bone.MAT.matName = 'Bone';
abaData.Bone.MAT.varDens = '1.89e-09';
if ~isfield(abaData.Bone.MAT, 'vaEL')
    abaData.Bone.MAT.vaEL = [18000, 0.3]; % Young's modulus and Poisson's ratio
end
if ~isfield(abaData.Bone.MAT, 'varCDPPlas')
    abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
end
if ~isfield(abaData.Bone.MAT, 'comp')
    abaData.Bone.MAT.comp = struct();
end
if ~isfield(abaData.Bone.MAT.comp, 'sigmaY')
    abaData.Bone.MAT.comp.sigmaY = 150;         % compression yield stress [MPa]
end
if ~isfield(abaData.Bone.MAT.comp, 'sigmaUYD')
    abaData.Bone.MAT.comp.sigmaUYD = 50;        % compression ultimate-yield stress [MPa]
end
abaData.Bone.MAT.comp.sigmaU = abaData.Bone.MAT.comp.sigmaY + abaData.Bone.MAT.comp.sigmaUYD;
if ~isfield(abaData.Bone.MAT.comp, 'epsilonU')
    abaData.Bone.MAT.comp.epsilonU = 0.05;      % compression ultimate strain [-]
end
abaData.Bone.MAT.comp.sigmaF = abaData.Bone.MAT.comp.sigmaU * 0.05;   % compression failure(deletion) stress [MPa]
if ~isfield(abaData.Bone.MAT.comp, 'epsilonF')
    abaData.Bone.MAT.comp.epsilonF = 0.10;      % compression failure (deletion) strain [-]
end
if ~isfield(abaData.Bone.MAT, 'tens')
    abaData.Bone.MAT.tens = struct();
end
if ~isfield(abaData.Bone.MAT.tens, 'sigmaY')
    abaData.Bone.MAT.tens.sigmaY = 100;          % tension yield stress [MPa]
end
abaData.Bone.MAT.tens.sigmaF = abaData.Bone.MAT.tens.sigmaY * 0.05;     % tension failure(deletion) stress [MPa]
if ~isfield(abaData.Bone.MAT.tens, 'epsilonF')
    abaData.Bone.MAT.tens.epsilonF = 0.02;      % tension failure (deletion) strain [-]
end
% create CDP tables [strain, stress, damage, elastic strain, inelastic strain, plastic strain]
abaData.Bone.MAT = funCDPGen(abaData.Bone.MAT);

% CDP compressive hardening [Yield Stress, Inelastic Strain]
abaData.Bone.MAT.varCDPCHard = [...
    abaData.Bone.MAT.comp.CDPtable(abaData.Bone.MAT.comp.elaCNum:end,2),...
    abaData.Bone.MAT.comp.CDPtable(abaData.Bone.MAT.comp.elaCNum:end,5)...
    ];
% CDP tension stiffening [Yield Stress, Cracking(Inelastic) Strain]
abaData.Bone.MAT.varCDPTSti = [... 
    abaData.Bone.MAT.tens.CDPtable(abaData.Bone.MAT.tens.elaTNum:end,2),...
    abaData.Bone.MAT.tens.CDPtable(abaData.Bone.MAT.tens.elaTNum:end,5)...
    ];
% CDP compression damage [Damage Parameter, Inelastic strain]
abaData.Bone.MAT.varCDPCDam = [... 
    abaData.Bone.MAT.comp.CDPtable(abaData.Bone.MAT.comp.elaCNum:end,3),...
    abaData.Bone.MAT.comp.CDPtable(abaData.Bone.MAT.comp.elaCNum:end,5)...
    ];
% CDP tension damage [Damage Parameter, Cracking(Inelastic) Strain]
abaData.Bone.MAT.varCDPTDam = [... 
    abaData.Bone.MAT.tens.CDPtable(abaData.Bone.MAT.tens.elaTNum:end,3),...
    abaData.Bone.MAT.tens.CDPtable(abaData.Bone.MAT.tens.elaTNum:end,5)...
    ];
% CDP failure strain and damage [Ultimate Inelastic Strain, Ultimate Cracking Strain, 
%                       Correspnding Damage Parameter, Correspnding Damage Parameter]
abaData.Bone.MAT.varCDPFai = [...
    abaData.Bone.MAT.comp.CDPtable(end,5),...
    abaData.Bone.MAT.tens.CDPtable(end,5),...
    abaData.Bone.MAT.comp.CDPtable(end,3),...
    abaData.Bone.MAT.tens.CDPtable(end,3),...
    ];
abaData.Bone.eleType = 'C3D8'; % element type, for printInp_multiSect % C3D8R reduced integration point
abaData.Bone.partName = 'Bone';
abaData.Bone.intePnts = 8;
abaData.Bone.setNum = 1;
abaData.Bone.eleDel = 'YES';
% abaData.Bone.Part.partNum = 1;

%% Abaqus parameters Screw
abaData.Screw.MAT.matName = 'Screw';
abaData.Screw.MAT.varDens = '4.50e-09';
abaData.Screw.MAT.vaEL = [120000, 0.3]; % Young's modulus and Poisson's ratio

abaData.Screw.eleType = 'C3D10'; % element type, for printInp_multiSect % C3D8R reduced integration point
abaData.Screw.partName = 'Screw';
abaData.Screw.intePnts = 10;
abaData.Screw.setNum = 2;
abaData.Screw.eleDel = 'NO';
% abaData.Screw.Part.partNum = 1;

%% Abaqus parameters General
abaData.mSFactor = '2.5e-06';
if ~isfield(abaData, 'fricCoeef')
    abaData.fricCoeef = 0.30;
end
abaData.displacement = 0.5;
% abaData.BC.BCTop.Name = 'ScrewTop';
abaData.Parts = {'Screw', 'Bone'};

end