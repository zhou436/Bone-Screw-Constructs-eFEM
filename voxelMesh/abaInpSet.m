function nodeS = abaInpSet(fid, Bone, Screw)
% to be optimized
% Print Heading of element sets
% set a tolerance
coorTor = 0.1;
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '** \n');
%% Print BC sets (side surfaces of the bone sample)
topCoorX = max(Bone.Nodes(:,2));
botCoorX = min(Bone.Nodes(:,2));
topCoorY = max(Bone.Nodes(:,3));
botCoorY = min(Bone.Nodes(:,3));
[nodeSide,~] = find(...
    abs(Bone.Nodes(:,2)-topCoorX) <= coorTor |...
    abs(Bone.Nodes(:,2)-botCoorX) <= coorTor |...
    abs(Bone.Nodes(:,3)-topCoorY) <= coorTor |...
    abs(Bone.Nodes(:,3)-botCoorY) <= coorTor...
    );
nodeSide = Bone.Nodes(nodeSide,1);
%% Find top surface in a ring region, 5 first



%%
fprintf(fid, '*Nset, nset=BoneSide, instance=Bone-1\n');
nodeNum = numel(nodeSide);
nodeNumF = floor(nodeNum/16)*16;
nodeInt = reshape(nodeSide(1:nodeNumF),16,[])';
printEle(fid, nodeInt, 16);
printEle(fid, nodeSide(end-nodeNum+nodeNumF+1:end), nodeNum-nodeNumF);
%% find screw top point
topCoorZ = max(Screw.Nodes(:,4));
[nodeTop,~] = find(Screw.Nodes(:,4)==topCoorZ);
nodeTop = Screw.Nodes(nodeTop,1);
% nodeTopCoor = Screw.Nodes(nodeTop(1),:);
% ScrewRefSet = [...
% %     '*Node\n'...
% %     '1, %f, %f, %f\n'...
%     '*Nset, nset=ScrewTop, instance=Screw-1\n'...
%     '46,    47,    48,    50,    51,   809,   829,   830,   831,   832,   844,   845,   846,   847,   848,   849\n'...
% 
%     '24006, 24684, 24849, 24864, 26144, 26982\n'...
%     ];
% fprintf(fid, ScrewRefSet);

fprintf(fid, '*Nset, nset=ScrewTop, instance=Screw-1\n');
nodeNum = numel(nodeTop);
nodeNumF = floor(nodeNum/16)*16;
nodeInt = reshape(nodeTop(1:nodeNumF),16,[])';
printEle(fid, nodeInt, 16);
printEle(fid, nodeTop(end-nodeNum+nodeNumF+1:end), nodeNum-nodeNumF);

% *Node
%  1, -1.0, 1.0, 7.0
% *Nset, nset=ScrewTopRef
%  1,
% ** Constraint: Constraint-1
% *Rigid Body, ref node=ScrewTopRef, tie nset=ScrewTop

% Print Ending of element sets
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');

nodeS= {};
nodeS{1} = nodeSide;
nodeS{2} = nodeTop;

end

function printEle(fid, ele, eleNum)
fprintf(fid, [repmat('%d, ', [1,eleNum]), '\n'], ele');
end