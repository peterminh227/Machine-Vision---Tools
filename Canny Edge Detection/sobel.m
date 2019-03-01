%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [gradient, orientation] = sobel(img)
%  purpose :  Computes the gradient and the orientation of an image with
%  the sobel operator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     img:    grayscale input image (m x n)
%  output   arguments
%     gradient:     gradients image (m x n)
%     orientation:  orientation image (m x n)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gradient, orientation] = sobel(img)
% imfilter using correlation as default
h_y = fspecial('sobel'); % vertical gradient % horizontal edges
h_x = h_y'; % horizontal gradient % vertical edges
% I use minus because i want to calcualte from left to right as the
% position direction


Gy = imfilter(img,h_y,'replicate');
Gx = imfilter(img,h_x,'replicate');
gradient = sqrt(Gx.^2 + Gy.^2);    

orientation = atan2(Gy,Gx); 
% normalization magniture of gradient
end