clear all
close all
clc
%%
% Part source code and ideas based on Jiexian Ma (2022). voxelMesh (voxel-based mesh) 
% (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh)
% MATLAB Central File Exchange. Last Access 202207
tic
% ---------------------------------------------------------------------
% import image sequences in a folder, e.g. a001.tif, a002.tif, ...
folder_name = 'RF_26_L_Rec';
im = importImSeqs(folder_name);
im = imresize3(im, 0.2);
%%
% im(im<=50)=0;
% im(im>=50)=255;
%%
% ---------------------------------------------------------------------
% parameters % to be modified
dx = 1; dy = 1; dz = 1; % scale of original 3d image 
                        % dx - column direction, dy - row direction,
                        % dz - vertical direction (slice)

nodePreci = 8; % precision of node coordinates, for output

% ---------------------------------------------------------------------
% preprocess
im = flip(flip(im, 1), 3);

dimYNum = size(im, 1);
dimXNum = size(im, 2);
dimZNum = size(im, 3);    % slice

% get unique intensities from image
intensity = unique(im);     % column vector
% intensity = 255;            % user defined intensity
% ---------------------------------------------------------------------
% get numbering of 8 nodes in each element
% get list of node coordinates
% eleCell{i}(j,:) = [element_number, phase_number, node_number_of_8_nodes]
% nodeCoor(i,:) = [node_number, x, y, z]
% toc
[nodeCoor, eleCell] = voxelMesh(im, intensity, dimXNum, dimYNum, dimZNum);

% ---------------------------------------------------------------------
% export
% scale nodeCoor using dx, dy, dz
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
toc
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
abaData.Bone.Parts.eleType = ['C3D8','C3D8R']; % element type, for printInp_multiSect % C3D8R reduced integration point
abaData.Bone.Parts.partName = ['Bone','Void'];
abaData.Bone.Parts.partNum = 2;

%% Abaqus parameters General
abaData.mSFactor = '1e-04';
abaData.fricCoeef = 0.30;
abaData.displacement = -2.5;


%%
% generate inp file
% export multi-phases in image as multi-sections in inp file
fileName = 'printInpTemp';     
abaInp(nodeCoor, eleCell{2,1}, nodePreci, fileName, abaData);
toc
%% plot mesh
plotMesh(eleCell{2,1}(:,3:10), nodeCoor);
axis equal
% toc







