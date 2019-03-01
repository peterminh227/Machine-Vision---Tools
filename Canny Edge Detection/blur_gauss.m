%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  img_blurred = blur_gauss(img, sigma)
%  purpose :    blur the image with gaussian filter kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     img:    grayscale input image (m x n), m = number of rows, n = number of columns
%     sigma:  standard deviation of the gaussian kernel
%  output   arguments
%     img_blurred:     blurred image (m x n)
%
%   Author: Minh Nhat Vu 
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img_blurred = blur_gauss(img, smooth_sigma)
kernel_width  = 2 * round(1 * smooth_sigma + 1);
fGauss = fspecial('gaussian', kernel_width * ones(1,2), smooth_sigma);
img_blurred = imfilter(img, fGauss, 'replicate');
end