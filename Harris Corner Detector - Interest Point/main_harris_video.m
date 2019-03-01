%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2: Interest Points and Descriptors
% Daniel Wolf, Michal Staniaszek 2017
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

h = figure(1); clf
debug_corners = false; % <<< change to reduce output when you're done

%check the supported formats and driver first

%windows 
%info = imaqhwinfo('winvideo', 1);
%info.SupportedFormats'
%vid = videoinput('winvideo', 1, 'YUYV_640x480');

%linux
info = imaqhwinfo('linuxvideo', 1);
info.SupportedFormats'
vid = videoinput('linuxvideo', 1, 'YUYV_640x480');  

Isrc = getsnapshot(vid);
Igray = rgb2gray(ycbcr2rgb(Isrc));  % check the format 

% parameters <<< try different settings!
harris.sigma1 = 0.8;
harris.sigma2 = 1.5;
harris.threshold = 0.2;
harris.k = 0.04;

H = uicontrol('Style', 'PushButton',  'String', 'Exit',  'Callback', 'delete(gcbf)');
while ishandle(H)

    Isrc = getsnapshot(vid);
    Igray = rgb2gray(ycbcr2rgb(Isrc));
    
    clear Corners;
    [ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(Igray, harris);
    show_corners(I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners, debug_corners);
    drawnow();
    
end

delete(vid);
