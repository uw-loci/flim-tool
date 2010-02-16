function [colsum, nonzeros, norm_prof] = myradon(I,mask, theta)
%MYRADON radon transform of single angle giving profile of average
%intensity.  Does NOT include holes in average intensity projection
%
% [colsum, nonzeros, norm_prof] = myradon(I,mask, theta)
%   INPUT:
%        I- image for radon transform
%        mask- thresholded B/W image of I with zeros representing holes
%        theta- the angle in degrees that the slice should be taken through
%
%   OUTPUT:
%        colsum: the sum of each slice (skewed by holes)
%        nonzeros: the number of non zero pixels in each slice
%        norm_prof: normalized profile of image: colsum/nonzeros
%       

if (nargin < 3)
    fprintf(1,'usage: [colsum, nonzeros, norm_prof] = myradon(I,mask, theta)\n');
    return;
end

rot_angle = -1*theta;

%rotate the image theta number of degrees in the opposite direction so the
%slices can be taken perpendicular to the x-axis
rotI = imrotate(I, rot_angle);
% figure()
% imagesc(rotI);

%rotate the mask the same way 
rotmask = imrotate(mask, rot_angle);
% figure()
% imagesc(rotmask)

%look at the mask to determine the number of non zero elements in slice
%Create a vector representing number of non zero elements per column

%add up the slice sum 
colsum = sum(rotI); 

nz_col = zeros(1,size(rotmask,2));
for i = 1:size(rotmask,2)
    nz_col(1,i) = nnz(rotmask(:,i));
end

norm_prof = zeros(1,size(rotmask,2))
for i = 1:size(rotI,2)
    if (nz_col(1,i) ~=0) 
        norm_prof(1,i) = colsum(1,i)./nz_col(1,i);
    else
        norm_prof(1,i)= 0;
    end   
end





%Profile of cell including the zeros
nonzeros = nz_col;
end


