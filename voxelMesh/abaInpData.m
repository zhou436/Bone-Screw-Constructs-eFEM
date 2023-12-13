function abaData = abaInpData(abaData, inputData)
%% Abaqus parameters Bone
abaData.Bone.MAT.matName = 'Bone';

if isempty(inputData) % if there is no preliminary inputs
    density = 1.8;
    tenCompRTo = 0.60;   % tension/compression ratio
    ultYDRTo = 1.2;     % ultimate/Yielding ratio
    ultStr = 0.020 + 0.0104;      % ultimate strain
    postUltStr = 0.25;   % post-ultimate strain
else
    density = inputData(1);
    tenCompRTo = inputData(2);   % tension/compression ratio
    ultYDRTo = inputData(3);     % ultimate/Yielding ratio
    ultStr = inputData(4) + 0.0104;      % ultimate strain
    postUltStr = inputData(5);   % post-ultimate strain
end
% default parameters
strRTSC = 1.0912;   % strain rate scaling factor
% parameter calculation
yngsM = 6850*density^1.49; % calculate the young's modulus
ultStrsComp = 49.5*strRTSC*density^2;   % calculate the ultimate compression stress
ultStrsTen = ultStrsComp * tenCompRTo;  % calculate the ultimate tension stress
yldStrsComp = ultStrsComp/ultYDRTo;     % calculate the yielding compression stress
yldStrsTen = ultStrsTen/ultYDRTo;       % calculate the yielding tension stress
% set the values
abaData.Bone.MAT.varDens = sprintf('%.2fE-9',density);
abaData.Bone.MAT.vaEL = [yngsM, 0.3]; % Young's modulus and Poisson's ratio
abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0];   % CDP plasticity table
abaData.Bone.MAT.comp = struct();
abaData.Bone.MAT.comp.sigmaY = yldStrsComp;         % compression yield stress [MPa]
%     abaData.Bone.MAT.comp.sigmaUYD = 51.8517;         % compression ultimate-yield stress [MPa]
abaData.Bone.MAT.comp.sigmaU = ultStrsComp;         % compression ultimate-yield stress [MPa]
abaData.Bone.MAT.comp.epsilonU = ultStr;            % compression ultimate strain [-]
abaData.Bone.MAT.comp.sigmaF = abaData.Bone.MAT.comp.sigmaU * 0.05;     % compression deletion stress [MPa]
abaData.Bone.MAT.comp.epsilonF = postUltStr + ...
    abaData.Bone.MAT.comp.epsilonU;                 % compression deletion strain [-]
abaData.Bone.MAT.tens = struct();
abaData.Bone.MAT.tens.sigmaY = yldStrsTen;          % tension yield stress [MPa]
abaData.Bone.MAT.tens.sigmaU = ultStrsTen;          % tension ultimate stress [MPa]
abaData.Bone.MAT.tens.epsilonU = ultStr;            % tension ultimate strain [-]
abaData.Bone.MAT.tens.sigmaF = abaData.Bone.MAT.tens.sigmaU * 0.05;     % tension failure(deletion) stress [MPa]
abaData.Bone.MAT.tens.epsilonF = postUltStr + ...
    abaData.Bone.MAT.tens.epsilonU;                 % tension deletion strain [-]

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

abaData.Screw.eleType = 'C3D4'; % element type, for printInp_multiSect % C3D8R reduced integration point
abaData.Screw.partName = 'Screw';
abaData.Screw.intePnts = 4;
abaData.Screw.setNum = 2;
abaData.Screw.eleDel = 'NO';
abaData.Screw.length = 15;
% abaData.Screw.Part.partNum = 1;

%% Abaqus parameters General
abaData.mSFactor = '5.0e-06';
if ~isfield(abaData, 'fricCoeef')
    abaData.fricCoeef = 0.30;
end
abaData.displacement = -0.5;
% abaData.BC.BCTop.Name = 'ScrewTop';
abaData.Parts = {'Screw', 'Bone'};

end