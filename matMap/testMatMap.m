clear all
close all
clc
%%
addpath('./../voxelMesh');
% tic
%% load bone micro-CT
% folder_name = './RF_20RS';
pixelSize = 8.67/1000; % unit: mm, same as Abaqus unit
% im = importImSeqs(folder_name);
load("Bone_360_LR.mat");
load("Bone_360_GT.mat");
% im = ImgMatLR;
im = ImgMatGT;
im = flip(im,1);
im = flip(im,2);
im = flip(im,3);
% imhist(im);
%% rescale image size, for low resolution models
% scaleFac = 1; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
scaleFac = 8.67/80;
imSca = imresize3(im, scaleFac);
imSca = uint8(imbinarize(imSca))*255;
pixelSizeSca = pixelSize/scaleFac;
% imSca = permute(imSca,[3,1,2]);
% volshow(imSca);
%% image size
dx = pixelSizeSca;
dy = pixelSizeSca;
dz = pixelSizeSca;  % Scaled pixel size in x, y, z direction, usually same
% dx - column direction, dy - row direction,
% dz - vertical direction (slice)

% preprocess
imSca = flip(flip(imSca, 1), 3);

dimYNum = size(imSca, 1);
dimXNum = size(imSca, 2);
dimZNum = size(imSca, 3);    % slice

% get unique intensities from image
intensity = unique(imSca);     % column vector
% intensity = 255;            % user defined intensity
% toc
%% Generate voxel mesh from micro-CT images
[nodeCoor, eleCell] = voxelMesh(imSca, intensity, dimXNum, dimYNum, dimZNum);
% scale nodeCoor using dx, dy, dz (from 1,1,1 to pixel size)
nodeCoor(:, 2) = nodeCoor(:, 2) * dx;
nodeCoor(:, 3) = nodeCoor(:, 3) * dy;
nodeCoor(:, 4) = nodeCoor(:, 4) * dz;
%% clean nodes
% nodes are double, memory consumed!
nodeCoorUni = nodeCoor(unique(reshape(eleCell{2,1}(:,3:10),[],1)),:);
abaData.Bone.Nodes = nodeCoorUni;
abaData.Bone.Elements = [];
for ii=2: 1: size(eleCell,1)
    abaData.Bone.Elements = [abaData.Bone.Elements;eleCell{ii,1}(:,[1 3:10])];
%     eleCellBone{ii,1} = eleCell{ii,1}(:,[1 3:10]);
end
% clear eleCell nodeCoorUni
% toc
%% write inp
% fileName = 'printInpTemp';
% nodeS = abaInpMatMap(fileName, abaData); % generate inp file
% eleType = "C3D8";
% preci = 10;
eleCellBone = {};
for ii=2: 1: size(eleCell,1)
    eleCellBone{ii-1,1} = eleCell{ii,1};
end
eleCount = 1;
for ii=1: 1: size(eleCellBone,1)
    for jj=1: 1: size(eleCellBone{ii,1},1)
        eleCellBone{ii,1}(jj,1) = eleCount;
        eleCount = eleCount + 1;
    end
end
% eleCellBone = eleCell{2:end,:};
printInp_multiSect(nodeCoor, eleCellBone, "C3D8", 5);
%%
fid=fopen('test.inp','A');
% fprintf('*\n');
fprintf(fid, '*INCLUDE, INPUT=MATPRO.inp\n');
fprintf( fid, '**' );
fclose(fid);
%%
fid=fopen('MATPRO.inp','wW');
% Print Heading of material section
fprintf(fid, ...
    ['** ----------------------------------------------------------------\n'...
    '** \n'...
    '** MATERIALS\n'...
    '** \n']);
num_sect = length( eleCellBone );
for ii=1: num_sect
    MAT.matName = sprintf('Material-%03d',ii);
    MAT.varDens = eleCellBone{ii,1}(1,2);
    MAT.vaEL = MAT.varDens * 2;
    fprintf(fid,'*Material, name=%s\n', MAT.matName);
    fprintf(fid, '*Density\n');
    fprintf(fid, '%f,\n', MAT.varDens);
    % Print Young's modulus and Poisson's ratio
    fprintf(fid, '*Elastic\n');
    fprintf(fid, '%f, %f\n', MAT.vaEL, 0.3);
end
% Print Ending of material section
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
fclose(fid);
% ele_cell{i}(:,[1 3:10])

