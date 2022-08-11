function eleCell = getElement(im, intensity, dimXNum, dimYNum, dimZNum)
% build element cell with number, intensity, and nodes
% Convert 3d image to voxel-based 8-node mesh
% input im:         micro-CT image, (dimXNum,dimYNum,dimZNum)
% input intensity:  A matrix (n,1), n intensity numbers
% input dimXNum:    Number of voxels in dimension X
% input dimYNum:    Number of voxels in dimension Y
% input dimZNum:    Number of voxels in dimension Z
% output nodeCoor:  node list combined the nodes number and coordinates (x,y,z)
% output eleCell:   element cell, {m,1}(n,10) [element number, intensity, nodes(8)]

phaseNum = length(intensity);
% initialize ele_cell
eleCell = cell(phaseNum, 1);
integerType = getIntType(dimXNum, dimYNum, dimZNum);

for i = 1: phaseNum
    eleIndVector = find(im == intensity(i));
    eleNum = size(eleIndVector, 1);
    eleTemp = zeros(eleNum, 10, integerType);
    parfor j = 1: eleNum
        % subscript of element in im
        [dimX, dimY, dimZ] = ind2sub([dimYNum, dimXNum, dimZNum], eleIndVector(j));
        % get linear index of eight corner of voxel(row,col,sli) in nodeCoor
        Lind_8corner = [
            (dimY-1)*(dimYNum+1) + dimX + (dimYNum+1)*(dimXNum+1)*(dimZ-1), ...
            dimY*(dimYNum+1) + dimX + (dimYNum+1)*(dimXNum+1)*(dimZ-1), ...
            dimY*(dimYNum+1) + dimX + 1 + (dimYNum+1)*(dimXNum+1)*(dimZ-1), ...
            (dimY-1)*(dimYNum+1) + dimX + 1 + (dimYNum+1)*(dimXNum+1)*(dimZ-1), ...
            (dimY-1)*(dimYNum+1) + dimX + (dimYNum+1)*(dimXNum+1)*dimZ, ...
            dimY*(dimYNum+1) + dimX + (dimYNum+1)*(dimXNum+1)*dimZ, ...
            dimY*(dimYNum+1) + dimX + 1 + (dimYNum+1)*(dimXNum+1)*dimZ, ...
            (dimY-1)*(dimYNum+1) + dimX + 1 + (dimYNum+1)*(dimXNum+1)*dimZ...
           ];

        % put Lind_8corner into
        eleTemp(j, :) = [eleIndVector(j), i, Lind_8corner];
    end

    eleCell{i} = eleTemp;
end

end

function integer_type = getIntType(dimXNum, dimYNum, dimZNum)
% get the suitable integer type for storing node number

total_num_node = (dimYNum+1)*(dimXNum+1)*(dimZNum+1);
if total_num_node >0 && total_num_node < 2^64

    if total_num_node < 2^8
        integer_type = 'uint8';
    elseif total_num_node < 2^16
        integer_type = 'uint16';
    elseif total_num_node < 2^32
        integer_type = 'uint32';
    else
        integer_type = 'uint64';
    end
else
    error('unexpected number of nodes');
end
end
