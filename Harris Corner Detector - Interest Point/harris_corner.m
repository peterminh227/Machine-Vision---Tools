%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = 
%                                                            harris_corner(Igray, parameters )
%  purpose :    Harris Corner Detector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     Igray:          grayscale input image, value range: 0-255 (m x n)
%     parameters:     struct containing the following elements:
%		parameters.sigma1: sigma for the first Gaussian filtering
%		parameters.sigma2: sigma for the second Gaussian filtering
%       parameters.k: coefficient for harris formula
%       parameters.threshold: corner threshold
%
%  output   arguments
%     I:              grayscale input image, value range: 0-1 (m x n)
%     Ixx:            squared input image filtered with derivative of gaussian in
%                     x-direction (m x n)
%     Iyy:            squared input image filtered with derivative of gaussian in
%                     y-direction (m x n)
%     Ixy:            Multiplication of input image filtered with
%                     derivative of gaussian in x- and y-direction (m x n)
%     Gxx:            Ixx filtered by larger gaussian (m x n)
%     Gyy:            Iyy filtered by larger gaussian (m x n)
%     Gxy:            Ixy filtered by larger gaussian (m x n)
%     Hdense:         Result of harris calculation for every pixel. Values 
%                     normalized to 0-1 (m x n)
%     Hnonmax:        Binary mask of non-maxima suppression. 1 where values are NOT
%                     suppressed, 0 where they are. (m x n)
%     Corners:        n x 3 matrix containing all detected corners after
%                     thresholding and non-maxima suppression. Every row
%                     vector represents a corner with the elements
%                     [y, x, d] (d is the result of the harris calculation)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(Igray, params)
% Normalize the images
I = double(Igray)./255.0;
[count_rows,count_cols] = size(I);

kw_1 = 2 * round(3 * params.sigma1) + 1; % kernel width 1
kw_2 = 2 * round(3 * params.sigma2) + 1; % kernel width 2
Gxy1 = fspecial('gaussian', [kw_1 kw_1], params.sigma1);
Gxy2 = fspecial('gaussian', [kw_2 kw_2], params.sigma2);

Gx1 = imfilter(Gxy1, [-1 0 1]);
Gy1 = imfilter(Gxy1, [-1 0 1]');

%
Ix = conv2(I, Gx1, 'same'); 
Iy = conv2(I, Gy1, 'same'); 
%
Ixx = Ix .^2;
Iyy = Iy .^ 2;  
Ixy = Ix .* Iy;
%
Gxx = conv2(Ixx, Gxy2, 'same'); 
Gyy = conv2(Iyy, Gxy2, 'same'); 
Gxy = conv2(Ixy, Gxy2, 'same'); 
%
Hdense = zeros(count_rows, count_cols);
Hdense_thresh = zeros(count_rows, count_cols);
% measure for cornerness
% det(M) = lambda1 * lambda2; trace(M) = lambda1 + lambda2
for x = 1: count_rows %
    for y = 1: count_cols % 
        % matrix for each pixel
        M = [Gxx(x,y) Gxy(x,y); Gxy(x,y) Gyy(x,y)];
        Hdense(x,y) = det(M) - params.k * (trace(M) ^ 2);
    end
end
% normalization
Hdense = Hdense/ max(Hdense(:));
Hdense([1:10, end-11:end], :) = 0;
Hdense(:,[1:10,end-11:end]) = 0;
% thresholding
Hdense_thresh(Hdense > params.threshold) = Hdense(Hdense > params.threshold);
% apply non-max suppression here
option = 1;
if (option == 1 )
    [r,c] = size(Hdense_thresh);
    Hnonmax = zeros(r,c);
    for i = 2:r-1
        for j = 2:c-1
            if Hdense_thresh(i,j) > Hdense_thresh(i-1,j-1) ...
                    && Hdense_thresh(i,j) > Hdense_thresh(i-1,j) ...
                    && Hdense_thresh(i,j) > Hdense_thresh(i-1,j+1)...
                    && Hdense_thresh(i,j) > Hdense_thresh(i,j-1)...
                    && Hdense_thresh(i,j) > Hdense_thresh(i,j+1)...
                    && Hdense_thresh(i,j) > Hdense_thresh(i+1,j-1)...
                    && Hdense_thresh(i,j) > Hdense_thresh(i+1,j)...
                    && Hdense_thresh(i,j) > Hdense_thresh(i+1,j+1)
                Hnonmax(i,j) = 1;
            end
        end
    end
    indexs = find(Hnonmax == 1);
    %
    [rows, columns] = ind2sub(size(Hnonmax), indexs);
elseif (option == 2)
    h_y = fspecial('sobel'); % vertical gradient % horizontal edges
    h_x = h_y'; % horizontal gradient % vertical edges
    Gy = imfilter(Hdense_thresh,h_y,'replicate');
    Gx = imfilter(Hdense_thresh,h_x,'replicate');
    gradient = sqrt(Gx.^2 + Gy.^2);    
    orientation = atan2(Gy,Gx); 
    [Hnonmax,indexs] = non_max(gradient, orientation);
    [rows, columns] = ind2sub(size(Hnonmax), indexs);
elseif (option == 3)
    Hnonmax = Hdense_thresh > imdilate(Hdense_thresh, [1 1 1; 1 0 1; 1 1 1]);
    indexs = find(Hnonmax > 0);
   [rows, columns] = ind2sub(size(Hnonmax), indexs);
end
Corners = [ rows, columns, Hdense(indexs)];
% 
end
