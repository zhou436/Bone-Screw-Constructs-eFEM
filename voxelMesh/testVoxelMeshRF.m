clear all
close all
clc
%%
tic
%% load bone micro-CT
% folder_name = 'RF_20R_VOIss';
% pixelSize = 11.953001/1000; % unit: mm, same as Abaqus unit
pixelSize = 20/1000; % unit: mm, same as Abaqus unit
scaleFac = 1/4; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
VOIFrac = 0.70;
% im = importImSeqs(folder_name);
load("./data/072_09_b__imgMat.mat");
%% screw data
screwMove = [0.1801	0.0558	-2.8931];
rotMat = axang2rotm([0.3555	0.2074	-0.9114	0.0139]);
% screwMove = [0.0	0.0	-4.0];
% rotMat = axang2rotm([0.3555	0.2074	-0.9114	0]);
outerRadius = 3.0; % Outter Radius 2.0 mm
innerRadius = 1.0; % Inner Radius 0.95 mm, as well the pilot hole

%%
% volshow(imgMat);
im = imgMat;
im = flip(im,1);
im = flip(im,2);
im = flip(im,3);
% VOIFracZ = 0.60;
% im = im(:,:,floor((1-VOIFracZ)*size(im,3)):end);
%% Import screw mesh
% [data]= abaqusInpRead("./data/ScrewIn15PH05CA15.inp");
% % screwData.Elements = [data.Elements{1};data.Elements{2}+size(data.Nodes{1},1)];
% % data.Nodes{2}(:,1) = data.Nodes{2}(:,1) + size(data.Nodes{1},1);
% % screwData.Nodes = [data.Nodes{1};data.Nodes{2}];
% screwData.Elements = data.Elements{1};
% screwData.Nodes = data.Nodes{1};
% eleNum = size(screwData.Elements,1);
% screwData.Elements = [(1:eleNum)',screwData.Elements];
% save("ScrewIn15PH05CA15.mat","screwData");

%% load Screw mesh
% load ("./data/optiScrew/ScrewIn20PH15CA30.mat");
load ("./screwLTSMesh.mat");
abaData.Screw.Elements = screwData.Elements;
abaData.Screw.Nodes = screwData.Nodes;
topCoorZ = max(abaData.Screw.Nodes(:,4));
[abaData.Screw.NodeTop,~] = find(abaData.Screw.Nodes(:,4)==topCoorZ);

abaData.Screw.Nodes(:,2) = abaData.Screw.Nodes(:,2)+screwMove(1);
abaData.Screw.Nodes(:,3) = abaData.Screw.Nodes(:,3)+screwMove(2);
abaData.Screw.Nodes(:,4) = abaData.Screw.Nodes(:,4)+screwMove(3);
abaData.Screw.Nodes(:,2:4) = abaData.Screw.Nodes(:,2:4) * rotMat;
abaData.Screw.move = screwMove;
clear screwData;
%% smallerVOI
if VOIFrac == 1
    imVOI = im;
else
%     findImg = find(im); % find non-zero voxels
%     [row, col, ~] = ind2sub(size(im), findImg);
    xmid = floor(1/2*size(im,1)) + floor(screwMove(2)/pixelSize);
    ymid = floor(1/2*size(im,2)) + floor(screwMove(1)/pixelSize);
    ROIRad = min(size(im(:,:,1)))*VOIFrac/2;
    abaData.Bone.radi = ROIRad*pixelSize;
%     im = imtranslate(im, [floor(1/2*(size(im,1))-xmid),floor(1/2*(size(im,2))-ymid),0]);
%     abaData.Bone.Xmid = xmid*pixelSize;
    delMat = ones(size(im(:,:,1)));
    for ii=1: size(im(:,:,1),1)
        for jj=1: size(im(:,:,1),2)
            if (ii-xmid)^2 + (jj-ymid)^2 >= ROIRad^2
                delMat(ii,jj) = 0;
            end
        end
    end
    imVOI = im;
    for ii=1: size(im,3)
        imVOI(:,:,ii) = uint8(double(im(:,:,ii)).*delMat);
    end
end
%% rescale image size, for low resolution models
imSca = imresize3(imVOI, scaleFac, "method", "nearest");
% clear imVOI;
% imSca(imSca<=100)=0;
% imSca(imSca>=100)=255;
imSca = uint8(imbinarize(imSca))*255;
pixelSizeSca = pixelSize/scaleFac;
% volshow(imSca);
%% image size
dx = pixelSizeSca;
dy = pixelSizeSca;
dz = pixelSizeSca;  % Scaled pixel size in x, y, z direction, usually same
% dx - column direction, dy - row direction,
% dz - vertical direction (slice)

% preprocess
% imSca = flip(flip(imSca, 1), 3);

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
abaData.Bone.Elements = eleCell{2,1}(:,[1 3:10]);
clear eleCell nodeCoorUni
toc

%% do boolean operation!
addpath('./../meshBoolean');
boneData = abaData.Bone;
boneData.allNodes = nodeCoor;
screwData = abaData.Screw;
toDelEles = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove);
boneData.Elements(toDelEles,:) = [];
% toc

%% Output Abaqus files
abaData.Bone.Elements(toDelEles,:) = [];
abaData = abaInpData(abaData, []); % basic abaqus settings
fileName = 'printInpTemp';     
nodeOutCell = abaInp(fileName, abaData); % generate inp file
disp('Number of elements:\n');
disp(size(boneData.Elements,1));
disp('VOI:\n');
disp(size(imVOI)*pixelSize);
toc
%% plot mesh
screwBoneMesh = figure(5);
plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
% volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
hold on;
scatter3(nodeCoor(nodeOutCell{1},2), nodeCoor(nodeOutCell{1},3), nodeCoor(nodeOutCell{1},4));
hold on
scatter3(nodeCoor(nodeOutCell{2},2), nodeCoor(nodeOutCell{2},3), nodeCoor(nodeOutCell{2},4));
hold on
% Load screw data and plot

plotMesh(abaData.Screw.Elements(:,2:5), abaData.Screw.Nodes, 0.5, 'none');

% plot labels
xlabel('x');
ylabel('y');
zlabel('z');

xlim([0, inf]);
% ylim([0, inf]);
view(240,30);

saveas(screwBoneMesh, 'screwBoneMesh.png');




