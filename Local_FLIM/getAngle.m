function [angle_line] = getAngle(coord)
%GETANGLE determines the angle of the line drawn using imline with respect
%to the x axis.  Angle will be 0 to 180 degrees.  In myradon transform,
%need to rotate the image -1*angle_lines before slicing and summing the
%image.

%Input:
%   coord: 2x2 matrix of endpoints of line returned by imline.  First call imline and
%          store the return value in a variable (eg. a).  coord should be
%          coord = a.getPosition.
%
%   angle: The angle is the angle of the line with respect to the x axis
%   pointing right 0->inf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 1
    error('Illegal input coordinates');
end

% make sure the top point is in the first row
% coords in form (x,y), but origin is in upper left

if (coord(2,2) < coord(1,2))
    temprow = coord(2,:);
    coord(2,:) = coord(1,:);
    coord(1,:) = temprow(1,:);
end



ydiff = abs(coord(1,2) - coord(2,2))
xdiff = abs(coord(1,1) - coord(2,1))

length = sqrt(xdiff.^2+ydiff.^2)

% line down and to right
if (coord(1,1) < coord(2,1))
    angle_line = 180 - atand (ydiff/xdiff);
    disp('down and right');
else
    %line down and to left
    if(coord(1,1) > coord(2,1))
        angle_line = atand (ydiff/xdiff); 
        disp('down and left');
    else
        angle_line = 90;
        disp('vertical line');
    end
end

%vec = [xdiff, ydiff];
%xaxis = [1,0];
%angle with respect to x axis = arccos((vec dot xaxis)/(|vec||xaxis|))
% reduces to angle = arccos(xdiff/mag(vec))

%angle_line = acosd(vec(1)./(length))





end
