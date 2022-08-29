function BoolNum = funProjedTest(boolNum1, boolNum2, coorPntTet)
% input boolNum1:   A matrix (1,4), 4 booleans
% input boolNum2:   A matrix (1,4), 4 booleans
% input coorPntTet: A matrix (4,2), 4 points x,y (projected)
BoolNum = false;
% BoolNum:          A boolean number, false (cant find sepa face), true (found sepa face)
% if both boolean number are 0, for 1 point (cant find sepa face)
if ~all(boolNum1 | boolNum2)
%     BoolNum = false;
    return
end
% if both boolean number are 1, for 3 or 4 points (found sepa face) (after 0| check)
if sum(boolNum1 & boolNum2) >= 3
    BoolNum = true;
    return
end
% find +- and compare
% if 2 +-s, compare 1,2 only
compInd = find(~(boolNum1 & boolNum2)); % the indices of +- points
if size(compInd,2) == 2
    if (coorPntTet(compInd(1),2)*coorPntTet(compInd(2),1)-coorPntTet(compInd(2),2)*coorPntTet(compInd(1),1))...
            /(coorPntTet(compInd(2),1)-coorPntTet(compInd(1),1)) > 0
        BoolNum = true;
        return
    end
end
% if 3 +-s, compare 1,2; 1,3; 2,3
% if 4 +-s, compare 1,2; 1,3; 1,4; 2,3; 2,4; 3,4
BoolNumArr = zeros(1,size(compInd,2)*(size(compInd,2)-1));
BoolNumArrCount = 1;
for ii=1: 1: size(compInd,2)
    for jj=1: 1: size(compInd,2)-1
        BoolNumArr(BoolNumArrCount) = (coorPntTet(compInd(1),2)*coorPntTet(compInd(2),1)-coorPntTet(compInd(2),2)*coorPntTet(compInd(1),1))...
                /(coorPntTet(compInd(2),1)-coorPntTet(compInd(1),1)) >= 0; % means no intersection to -- field
        BoolNumArrCount = BoolNumArrCount + 1;
    end
end
% if all lines do not intersection -- field, return true (found sepa face)
if all(BoolNumArr)
    BoolNum = true;
    return
end
% othercases, return false (no sepa face found HERE!)
end