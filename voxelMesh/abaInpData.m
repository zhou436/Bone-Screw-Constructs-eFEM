function abaData = abaInpData(abaData)
%% Abaqus parameters Bone
abaData.Bone.MAT.matName = 'Bone';
abaData.Bone.MAT.varDens = '1.89e-09';
abaData.Bone.MAT.vaEL = [300, 0.3]; % Young's modulus and Poisson's ratio
abaData.Bone.MAT.varCDPPlas = [40.0, 0.1, 1.16, 0.6667, 0.0]; % CDP plasticity table
abaData.Bone.MAT.varCDPCHard = [... % CDP compressive hardening
    6.0, 0.0;
    8.0, 0.00833333;
    10.0, 0.0166667;
    6.75, 0.0441667;
    3.5, 0.0716667;
    0.25, 0.0991667;
    ];
abaData.Bone.MAT.varCDPTSti = [... % CDP tension stiffening
    6.0, 0.0;
    4.06667, 0.0164444;
    2.13333, 0.0328889;
    0.2, 0.0493333;
    ];
abaData.Bone.MAT.varCDPCDam = [... % CDP compression damage
    0.0, 0.0;
    0.0, 0.00833333;
    0.0, 0.0166667;
    0.325, 0.0441667;
    0.65, 0.0716667;
    0.975, 0.0991667;
    ];
abaData.Bone.MAT.varCDPTDam = [... % CDP tension damage
    0.0, 0.0;
    0.322222, 0.0164444;
    0.644444, 0.0328889;
    0.966667, 0.0493333;
    ];
% CDP failure strain and damage
abaData.Bone.MAT.varCDPFai = [0.0493333, 0.0991667, 0.966667, 0.975];
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
abaData.mSFactor = '1e-04';
abaData.fricCoeef = 0.30;
abaData.displacement = 2.5;
% abaData.BC.BCTop.Name = 'ScrewTop';
abaData.Parts = {'Screw', 'Bone'};


end