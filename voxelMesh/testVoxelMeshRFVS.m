clear all
close all
clc
%%
tic
%% load bone micro-CT
% folder_name = 'RF_20R_VOIss';
% pixelSize = 11.953001/1000; % unit: mm, same as Abaqus unit
pixelSize = 20/1000; % unit: mm, same as Abaqus unit
scaleFac = 0.25; % scale factor of the model, 0.1 means 1/10 voxels in one dimension
VOIFrac = 0.50;
% VOIFracZ = 1.00;
% im = importImSeqs(folder_name);
load("./data/080_10_a_imgMat.mat");
% move the screw a bit [-2,2,-4]
%% screw data
screwMove = [-0.0720	-0.2056	-3.4308];
rotMat = axang2rotm([-0.2352	0.1495	0.9604	0.0787]);
outerRadius = 2.5; % Outter Radius 2.0 mm
innerRadius = 0.40; % Inner Radius 0.95 mm, as well the pilot hole

%%
% volshow(imgMat);
im = imgMat;
im = flip(im,1);
im = flip(im,2);
im = flip(im,3);
% im = im(:,:,floor((1-VOIFracZ)*size(im,3)):end);
% im = permute(im,[3,1,2]);

%% load Screw mesh
load screwLTSMesh.mat
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
imSca = imresize3(imVOI, scaleFac);
% clear imVOI;
imSca(imSca<=100)=0;
imSca(imSca>=100)=255;
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
% toc


%% do boolean operation!
addpath('./../meshBoolean');
boneData = abaData.Bone;
boneData.allNodes = nodeCoor;
screwData = abaData.Screw;
toDelEles = funMeshBoolean(boneData, screwData, outerRadius, innerRadius, screwMove);
boneData.Elements(toDelEles,:) = [];
abaData.Bone.Elements(toDelEles,:) = [];
abaData.Bone.Elements(:,2:9) = abaData.Bone.Elements(:,2:9) - min(abaData.Bone.Nodes(:,1)) + 1;
abaData.Bone.Nodes(:,1) = abaData.Bone.Nodes(:,1) - min(abaData.Bone.Nodes(:,1)) + 1;
% toc
% plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
%% Generate voxel mesh from mask data
% imScaMSK = imSca*0+255;
imScaMSK = uint8(ones(size(imSca,1),size(imSca,2),size(imSca,3)*2))*255;
[nodeCoorScrew, eleCell] = voxelMesh(imScaMSK, 255, size(imScaMSK,1), size(imScaMSK,2), size(imScaMSK,3));
% scale nodeCoor using dx, dy, dz (from 1,1,1 to pixel size)
nodeCoorScrew(:, 2) = nodeCoorScrew(:, 2) * dx;
nodeCoorScrew(:, 3) = nodeCoorScrew(:, 3) * dy;
nodeCoorScrew(:, 4) = nodeCoorScrew(:, 4) * dz;
%% do boolean operation!
maskData.Elements = eleCell{1,1}(:,[1 3:10]);
maskData.allNodes = nodeCoorScrew;
screwData = abaData.Screw;
screwVoxEle = funMeshBoolean(maskData, screwData, outerRadius, 0, [0,0,0]);
abaData.Screw.Elements = maskData.Elements(screwVoxEle,:);
abaData.Screw.Elements(:,1) = abaData.Screw.Elements(:,1) - min(abaData.Screw.Elements(:,1)) + 1;
% nodeCoorScrew(:,4) = nodeCoorScrew(:,4) - size(imSca,3) * pixelSize/scaleFac;
% abaData.Screw.Nodes = nodeCoorScrew;
% toc
%% clean nodes
% nodes are double, memory consumed!
nodeCoorUni = nodeCoorScrew(unique(reshape(abaData.Screw.Elements(:,2:9),[],1)),:);
abaData.Screw.Nodes = nodeCoorUni;
abaData.Screw.Elements(:,2:9) = abaData.Screw.Elements(:,2:9) - min(abaData.Screw.Nodes(:,1)) + 1;
abaData.Screw.Nodes(:,1) = abaData.Screw.Nodes(:,1) - min(abaData.Screw.Nodes(:,1)) + 1;
% abaData.screw.Elements = eleCell{2,1}(:,[1 3:10]);
clear eleCell nodeCoorUni
%% Merge bone and screw
abaData.Screw.Nodes(:,1) = abaData.Screw.Nodes(:,1) + max(abaData.Bone.Nodes(:,1));
% abaData.Screw.Elements(:,1) = abaData.Screw.Elements(:,1) + size(abaData.Bone.Elements,1);
abaData.Screw.Elements(:,2:9) = abaData.Screw.Elements(:,2:9) + max(abaData.Bone.Nodes(:,1));
abaData.Multi.Nodes = [abaData.Bone.Nodes; abaData.Screw.Nodes];
abaData.Multi.Elements = {abaData.Bone.Elements, abaData.Screw.Elements};

topCoorZ = max(abaData.Multi.Nodes(:,4));
[abaData.Screw.NodeTop,~] = find(abs(abaData.Multi.Nodes(:,4)-topCoorZ)<=0.2);
abaData.Screw.NodeTop = abaData.Multi.Nodes(abaData.Screw.NodeTop,1);
%% Output Abaqus files

abaData = abaInpData(abaData, []); % basic abaqus settings
fileName = 'printInpTemp'; 
abaData.Multi.partName = 'Multi';
abaData.Multi.eleType = 'C3D8';
abaData.Multi.intePnts = 8;
abaData.Multi.MAT.matName = {'Bone','Screw'};
% abaData.Multi.Part.partName = 'Multi';
nodeOutCell = abaInpMulSec(fileName, abaData); % generate inp file
disp('Number of elements:\n');
disp(size(boneData.Elements,1));
disp('VOI:\n');
disp(size(imVOI)*pixelSize);
toc
%% plot mesh
% screwBoneMesh = figure();
% plotMesh(abaData.Bone.Elements(:,2:9), nodeCoor, 1, '-'); % 'none' for no edges
% % volshow(imSca, 'ScaleFactors', [pixelSizeSca,pixelSizeSca,pixelSizeSca]);
% hold on;
% scatter3(nodeCoor(nodeOutCell{1},2), nodeCoor(nodeOutCell{1},3), nodeCoor(nodeOutCell{1},4));
% hold on
% scatter3(nodeCoor(nodeOutCell{2},2), nodeCoor(nodeOutCell{2},3), nodeCoor(nodeOutCell{2},4));
% hold on
% % Load screw data and plot
% 
% plotMesh(abaData.Screw.Elements(:,2:9), abaData.Screw.Nodes, 0.5, 'none');
% 
% % plot labels
% xlabel('x');
% ylabel('y');
% zlabel('z');
% 
% xlim([0, inf]);
% % ylim([0, inf]);
% view(240,30);
% 
% saveas(screwBoneMesh, 'screwBoneMesh.png');


