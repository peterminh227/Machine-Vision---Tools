%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function [points2] = transformPoints(points, dx, dy, scaling, rotation)                                                      
%  purpose :    Rotate, translate and scale the given points.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     points:         2xn matrix containing points with x and y coordinate
%                     in every column.
%     dx, dy:         Translation in x and y direction
%     scaling:        Scale factor
%     rotation:       Rotation angle in rad, clockwise positive, 0 rotation
%                     pointing along x
%     
%  output   arguments
%     points2:        transformed points (same size as points)
%
%   Author: Minh Nhat Vu
%   MatrNr:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function points2 = transform_points(points, dx, dy, scaling, rot)

w2 = points(1,3); h2 = points(2,3);
% w1, h1
w1 = scaling*w2;
h1 = w1* h2/w2;
% edges point in body-rotation frame 
p1_b = [w1, 0]'; p2_b = [w1, h1]'; p3_b = [0, h1]'; % b = body frame
rotz = @(angle) [cos(angle) -sin(angle);sin(angle) cos(angle)]; 
p1_w = [dx;dy] + rotz(rot)*p1_b; % w = world frame
p2_w =  [dx;dy] + rotz(rot)*p2_b; 
p3_w =  [dx;dy] + rotz(rot)*p3_b; 
points2 = [[dx;dy] p1_w p2_w p3_w [dx;dy]];
end