%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 1: Canny Edge Detector
% Daniel Wolf, Michal Staniaszek 2017
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

% read and normalize image
img_orig = double(imread('image/rubens.jpg'))./255.0; % try different images
img = rgb2gray(img_orig);
close all;
clc
%% 1. Blur image
% Use ctrl-enter to run just the selected section
sigma = 6;	% try different values
img_blurred = blur_gauss(img, sigma);
figure(1)
subplot(1,2,1)
imshow(img); tit(1) = title('Original Image');
subplot(1,2,2)
imshow(img_blurred);tit(2) = title('Applying Gaussian Image');


%% 2. Edge detection
img_orig = double(imread('image/parliament.jpg'))./255.0; % try different images
img = rgb2gray(img_orig);
addnoise = 0;
if (addnoise ==1)
    img_orig = imnoise(img_orig,'gaussian',0,0.05);
    img = rgb2gray(img_orig);
    img = blur_gauss(img, 5);
end


[gradients, orientations] = sobel(img);
figure(2)
imshow(gradients,[], 'colormap', parula);
title('gradient magnitude')
figure(3)
imshow(orientations,[], 'colormap', parula);
title('orientations')
%% 3. Non-maximum Suppression
edges = non_max(gradients, orientations);

figure(4)
imshow(gradients - edges, [], 'colormap', parula);
title('nonmax discards')

figure(5)
imshow(edges,[], 'colormap', parula);
title('basic edges')
%% 4. Hysteresis thresholding
hyst_thresh_method = 'auto';

if strcmp(hyst_thresh_method, 'manual')
    % 4. Hysteresis Thresholding
    thresh_low = 0.3;	% change this
    thresh_high = 0.5; % change this
    canny_edges = hyst_thresh(edges, thresh_low, thresh_high);
elseif strcmp(hyst_thresh_method, 'auto')
    % 5. Autthomatic hysteresis thresholding
    canny_edges = hyst_thresh_auto(edges, low_prop, high_prop);
else
    error('unknown hyst_thresh_method "%s"', hyst_thresh_method)
end

figure(6)
imshow(canny_edges,[]);
title('canny edges')
%%
img_log = double(imread('image/parliament.jpg'))./255.0;
img_log = rgb2gray(img_log);
edges_log = edge(img_log,'log');
figure(7)
imshow(edges_log)