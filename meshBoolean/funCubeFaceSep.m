function [Boolean] = funCubeFaceSep(cubeCoor, TetCoor)
% input cubeCoor:   A matrix (8,3), 8 points x,y,z
% input TetCoor:    A matrix (4,3), 4 points x,y,z
Boolean = false;
maxCoor = max(cubeCoor,[],1); % maximum coordinates in x,y,z directions
minCoor = min(cubeCoor,[],1); % minimum coordinates in x,y,z directions
for ii=1: 1: 3
    if TetCoor(ii,1) > maxCoor(ii) &&...
            TetCoor(ii,2) > maxCoor(ii) &&...
            TetCoor(ii,3) > maxCoor(ii) &&...
            TetCoor(ii,4) > maxCoor(ii)
        Boolean = true;
        break
    elseif TetCoor(ii,1) < minCoor(ii) &&...
            TetCoor(ii,2) < minCoor(ii) &&...
            TetCoor(ii,3) < minCoor(ii) &&...
            TetCoor(ii,4) < minCoor(ii)
        Boolean = true;
        break
    end
end
end