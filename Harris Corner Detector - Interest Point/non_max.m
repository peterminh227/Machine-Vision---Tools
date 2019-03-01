%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  edges = non_max(gradients, orientations)
%  purpose: computes non-maximum suppression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input arguments
%     gradients:    gradient image (m x n)
%     orientations: orientation image (m x n)
%  output arguments
%     edges: edge image from gradients with non-edge pixels set to zero,
%            retaining gradient magnitude. (m x n)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [edges,ind_edges] = non_max(gradient, orientation)
 
%edges = gradients; % Remove this line before you start
mag_grad = gradient/max(gradient(:));
d = size(mag_grad);
edges = zeros(d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to get rid of for loop and too many if-then condition
% Convert from rad to degree 
oridentation_deg = rad2deg(orientation);
% Explanation:dir_vector = {1, 2, 3, 4} for chosing parrallel neighbors
% as we know, we have 4 directions w.r.t the angle of gradient vector: 
% VERTICAL: angle >= -22.5, < 22.5, angle <= -157.5, > 157.5, (1)
% in this situation, we will compare (y,x) with (y,x+1) and (y,x-1). The
% code below, I use forward and backward w.r.t above points respectively
% DIAGONAL RIGHT: angle >= -157, < -112.5; angle >= 22.5, < 67.5 (2)
% we will compare (y,x) with (y+1,x+1) and (y-1,x-1)
% and so on for HORIZONTAL(3) and DIAGONAL LEFT(4)
% the function below return the index of condition w.r.t to 4 cases above
dir_vector = floor(mod(oridentation_deg(:)+22.5, 180.0)/45.0) + 1; 
% Set offset value based on with point index you will compare with
% I call this is a offset value
off_x = [1 1 0 -1];
off_y = [0 1 1 1];
% 
dir_off_x = off_x(dir_vector)';
dir_off_y = off_y(dir_vector)';
%
indexs = (1:d(1)*d(2))';
[y_ind,x_ind] = ind2sub(d,indexs);
%
y_ind_forward = min(max(y_ind + dir_off_y, 1), d(1));
x_ind_forward = min(max(x_ind + dir_off_x, 1), d(2));
%
y_ind_backward = min(max(y_ind - dir_off_y, 1), d(1));
x_ind_backward = min(max(x_ind - dir_off_x, 1), d(2));
%
ind_forward = sub2ind(d,y_ind_forward,x_ind_forward);
ind_backward = sub2ind(d,y_ind_backward,x_ind_backward);
%
mag_grad_forward = mag_grad(ind_forward);
mag_grad_backward = mag_grad(ind_backward);
%
ind_edges = indexs(mag_grad(:) > mag_grad_forward & mag_grad(:) > mag_grad_backward);
%
edges(ind_edges) = 1;
end