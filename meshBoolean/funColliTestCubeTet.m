function BoolNum = funColliTestCubeTet(cubeCoor, tetCoor)
% input cubeCoor:   A matrix (8,3), 8 points x,y,z
% input TetCoor:    A matrix (4,3), 4 points x,y,z
% BoolNum:          A boolean number, false (no collision), true (collision)
BoolNum = true;
maxCoors = max(cubeCoor,[],1); % maximum coordinates in x,y,z directions
minCoors = min(cubeCoor,[],1); % minimum coordinates in x,y,z directions
booleanUpp = zeros(3,4);
booleanLow = zeros(3,4);
% check if all Tet vertices upper or lower than the Cube upper or lower plane, return true
for ii=1: 1: 3
    for jj=1: 1: 4
        booleanUpp(ii,jj) = maxCoors(ii) <= tetCoor(jj,ii); 
    end
    if all(booleanUpp(ii,:))
        BoolNum = false;
        return 
    end
    for jj=1: 1: 4
        booleanLow(ii,jj) = minCoors(ii) >= tetCoor(jj,ii);
    end
    if all(booleanLow(ii,:))
        BoolNum = false;
        return 
    end
end
% check if Cube edges can separate? return false
% to be optimized here
a = 1;
if a == 1
    % UU
    % U1, U2
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - maxCoors(1);
    tetCoorProj(:,2) = tetCoorProj(:,2) - maxCoors(2);
    tetCoorProj(:,3) = [];
    if funProjedTest(booleanUpp(1,:), booleanUpp(2,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % U1, U3
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - maxCoors(1);
    tetCoorProj(:,3) = tetCoorProj(:,3) - maxCoors(3);
    tetCoorProj(:,2) = [];
    if funProjedTest(booleanUpp(1,:), booleanUpp(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % U2, U3
    tetCoorProj = tetCoor;
    tetCoorProj(:,2) = tetCoorProj(:,2) - maxCoors(2);
    tetCoorProj(:,3) = tetCoorProj(:,3) - maxCoors(3);
    tetCoorProj(:,1) = [];
    if funProjedTest(booleanUpp(2,:), booleanUpp(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % LL
    % L1, L2
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - minCoors(1);
    tetCoorProj(:,2) = tetCoorProj(:,2) - minCoors(2);
    tetCoorProj(:,3) = [];
    if funProjedTest(booleanLow(1,:), booleanLow(2,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % L1, L3
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - minCoors(1);
    tetCoorProj(:,3) = tetCoorProj(:,3) - minCoors(3);
    tetCoorProj(:,2) = [];
    if funProjedTest(booleanLow(1,:), booleanLow(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % L2, L3
    tetCoorProj = tetCoor;
    tetCoorProj(:,2) = tetCoorProj(:,2) - minCoors(2);
    tetCoorProj(:,3) = tetCoorProj(:,3) - minCoors(3);
    tetCoorProj(:,1) = [];
    if funProjedTest(booleanLow(2,:), booleanLow(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % UL
    % U1, L2
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - maxCoors(1);
    tetCoorProj(:,2) = tetCoorProj(:,2) - minCoors(2);
    tetCoorProj(:,3) = [];
    if funProjedTest(booleanUpp(1,:), booleanLow(2,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % U1, L3
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - maxCoors(1);
    tetCoorProj(:,3) = tetCoorProj(:,3) - minCoors(3);
    tetCoorProj(:,2) = [];
    if funProjedTest(booleanUpp(1,:), booleanLow(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % U2, L3
    tetCoorProj = tetCoor;
    tetCoorProj(:,2) = tetCoorProj(:,2) - maxCoors(2);
    tetCoorProj(:,3) = tetCoorProj(:,3) - minCoors(3);
    tetCoorProj(:,1) = [];
    if funProjedTest(booleanUpp(2,:), booleanLow(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % LU
    % L1, U2
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - minCoors(1);
    tetCoorProj(:,2) = tetCoorProj(:,2) - maxCoors(2);
    tetCoorProj(:,3) = [];
    if funProjedTest(booleanLow(1,:), booleanUpp(2,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % L1, U3
    tetCoorProj = tetCoor;
    tetCoorProj(:,1) = tetCoorProj(:,1) - minCoors(1);
    tetCoorProj(:,3) = tetCoorProj(:,3) - maxCoors(3);
    tetCoorProj(:,2) = [];
    if funProjedTest(booleanLow(1,:), booleanUpp(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
    % L2, U3
    tetCoorProj = tetCoor;
    tetCoorProj(:,2) = tetCoorProj(:,2) - minCoors(2);
    tetCoorProj(:,3) = tetCoorProj(:,3) - maxCoors(3);
    tetCoorProj(:,1) = [];
    if funProjedTest(booleanLow(2,:), booleanUpp(3,:), tetCoorProj)
        BoolNum = false;
        return
    end
end
% otherwise, we think there is a overlap/collision, and delete the Cube/Hex element

end