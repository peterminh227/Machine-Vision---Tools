%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 3: Object recognition with SIFT & Generalized Hough Transform
% Daniel Wolf, Michal Staniaszek 2018
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
% This code includes parts of Andrea Vedaldi's SIFT for Matlab
%===================================================

%%%% PREPARATION %%%%
% 1. download and install Andrea Vedaldi's vlfeat library.
% http://www.vlfeat.org/download.html. See instructions at
% http://www.vlfeat.org/install-matlab.html
% 2. adjust the path to point to your vlfeat directory
% run ../vlfeat-0.9.21/toolbox/vl_setup.m
clc
close all
clear
addpath('../vlfeat-0.9.21/toolbox')
vl_setup

%%%% PARAMETERS %%%%
% index of test image to use (1-4)
image_nr = 3;
%%%%%%%%%%%%%%%%%%%%

%%%% You don't need to change anything after this point %%%%%%%%%%%%%%%%%%%

% read image in which objects should be detected
test_im = imread(['data/image' num2str(image_nr) '.png']);
test_im
test_im_gray = double(rgb2gray(test_im))/255.0 ;

% read template image
template = double(rgb2gray(imread('data/object.png')))/255.0;

% normalize intensities to range [0, 1]
test_im_gray=test_im_gray-min(test_im_gray(:));
test_im_gray=test_im_gray/max(test_im_gray(:));
template=template-min(template(:));
template=template/max(template(:));

fprintf('Computing frames and descriptors.\n') ;
[frames1,descr1] = vl_sift(single(test_im_gray));
[frames2,descr2] = vl_sift(single(template));

% plot calculated SIFT descriptors
% figure(1) ; clf ;
% subplot(1,2,1) ; imagesc(test_im) ; colormap gray ;
% hold on ;
% h=vl_plotframe(frames1) ; set(h,'LineWidth',2,'Color','g') ;
% subplot(1,2,2) ; imagesc(template) ; colormap gray ;
% hold on ;
% h=vl_plotframe(frames2) ; set(h,'LineWidth',2,'Color','g') ;
% hold off

fprintf('Computing matches.\n') ;
% By passing to integers we greatly enhance the matching speed (we use
% the scale factor 512 as Lowe, but it could be even larger without
% overflow)
descr1=uint8(512*descr1);
descr2=uint8(512*descr2);
matches=vl_ubcmatch(descr1, descr2, 1.5);

% plot successful matches between images
figure(2); clf;
plot_matches(test_im_gray,template,frames1, frames2, matches, 'points', 'random');

% call hough transform code to find object
[x,y,s,o] = detect_object(test_im_gray, template, frames1, frames2, matches);

figure(3);
plot_rectangles(test_im, template, x, y, s, o);