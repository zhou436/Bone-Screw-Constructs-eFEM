function nodeOutCell = abaInpSetTetScrew(fid, Bone, Screw)
% to be optimized
% Print Heading of element sets
% set a tolerance
coorTor = 0.1;
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '** \n');
%% Print BC sets (side surfaces of the bone sample)
% topCoorX = max(Bone.Nodes(:,2));
% botCoorX = min(Bone.Nodes(:,2));
% topCoorY = max(Bone.Nodes(:,3));
% botCoorY = min(Bone.Nodes(:,3));
% [nodeSide,~] = find(...
%     abs(Bone.Nodes(:,2)-topCoorX) <= coorTor |...
%     abs(Bone.Nodes(:,2)-botCoorX) <= coorTor |...
%     abs(Bone.Nodes(:,3)-topCoorY) <= coorTor |...
%     abs(Bone.Nodes(:,3)-botCoorY) <= coorTor...
%     );
% nodeSide = Bone.Nodes(nodeSide,1);
%% Find side surface
ringRad = Bone.radi-coorTor;
% nodeSide = [];
disMat = ((Bone.Nodes(:,2)-Screw.move(1)).^2 + (Bone.Nodes(:,3)-Screw.move(2)).^2).^0.5;
% nodeOut = find(disMat>=ringRad & Bone.Nodes(:,4) >= 1);
nodeOut = find(disMat>=ringRad);
bonNodesOut = Bone.Nodes(nodeOut,:);
[~, ia, ~] = unique(bonNodesOut(:,2:4),'rows');
% [bonNodesOutUni, ia, ic] = unique(bonNodesOut(:,2:3),'rows');
% for ii=1: 1: numel(ia)
%     colZ = find(ic==ii);
%     maxColZ = max(bonNodesOut(colZ,4));
%     colZTop = find(maxColZ-bonNodesOut(colZ,4)<=coorTor);
%     nodeSide = [nodeSide;bonNodesOut(colZ(colZTop,:),1)];
% end
nodeSide = bonNodesOut(ia,1);
nodeOutCell{1} = nodeSide;
%% Find side surface
botLine = min(Bone.Nodes(:,4));
% nodeSide = [];
% disMat = (Bone.Nodes(:,3).^2 + Bone.Nodes(:,3).^2).^0.5;
% nodeOut = find(disMat>=ringRad & Bone.Nodes(:,4) >= 1);
nodeOut = find(Bone.Nodes(:,4)<=botLine+coorTor);
bonNodesOut = Bone.Nodes(nodeOut,:);
[~, ia, ~] = unique(bonNodesOut(:,2:4),'rows');
nodeBot = bonNodesOut(ia,1);
nodeOutCell{2} = nodeBot;
%%
% Bone side
fprintf(fid, '*Nset, nset=BoneSide, instance=Bone-1\n');
nodeNum = numel(nodeSide);
nodeNumF = floor(nodeNum/16)*16;
nodeInt = reshape(nodeSide(1:nodeNumF),16,[])';
printEle(fid, nodeInt, 16);
printEle(fid, nodeSide(end-nodeNum+nodeNumF+1:end), nodeNum-nodeNumF);

% Bone bottom
fprintf(fid, '*Nset, nset=BoneBot, instance=Bone-1\n');
nodeNum = numel(nodeBot);
nodeNumF = floor(nodeNum/16)*16;
nodeInt = reshape(nodeBot(1:nodeNumF),16,[])';
printEle(fid, nodeInt, 16);
printEle(fid, nodeBot(end-nodeNum+nodeNumF+1:end), nodeNum-nodeNumF);

% Screw Top
% topCoorZ = max(Screw.Nodes(:,4));
% [nodeTop,~] = find(Screw.Nodes(:,4)>=topCoorZ-1);
nodeTop = Screw.NodeTop;

fprintf(fid, '*Nset, nset=ScrewTop, instance=Screw-1\n');
nodeNum = numel(nodeTop);
nodeNumF = floor(nodeNum/16)*16;
nodeInt = reshape(nodeTop(1:nodeNumF),16,[])';
printEle(fid, nodeInt, 16);
printEle(fid, nodeTop(end-nodeNum+nodeNumF+1:end), nodeNum-nodeNumF);

ScrewRefCons = [...
    '*Node\n'...
    ' 1, %.4f, %.4f, %.4f\n'...
    '*Nset, nset=ScrewTopRef\n'...
    ' 1,\n'...
    '** Constraint: Constraint-1\n'...
    '*Rigid Body, ref node=ScrewTopRef, tie nset=ScrewTop\n'...
    '*Elset, elset=ScrewEles, internal, instance=Screw-1, generate\n'...
    '1,  %d,     1\n'...
    ];
fprintf(fid, ScrewRefCons,Screw.move(1),Screw.move(2),Screw.move(3)+Screw.length,size(Screw.Elements,1));

% Print Ending of element sets
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');

end

function printEle(fid, ele, eleNum)
fprintf(fid, [repmat('%d, ', [1,eleNum]), '\n'], ele');
end