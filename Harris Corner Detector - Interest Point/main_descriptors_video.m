%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2: Interest Points and Descriptors
% Daniel Wolf, Michal Staniaszek 2017
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

figure(1), clf;

%check the supported formats and driver first

% UNCOMMENT THE FOLLOWING LINES IF YOU'RE USING WINDOWS
%windows 
%info = imaqhwinfo('winvideo', 1);
%info.SupportedFormats'
%vid = videoinput('winvideo', 1, 'YUYV_640x480');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% COMMENT THE FOLLOWING LINES OUT IF YOU'RE USING WINDOWS
%linux
info = imaqhwinfo('linuxvideo', 1);
info.SupportedFormats'
vid = videoinput('linuxvideo', 1, 'YUYV_640x480');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Isrc = getsnapshot(vid);
IgrayA = rgb2gray(ycbcr2rgb(Isrc));  % check the format 

% parameters: try different settings!
harris.sigma1 = 0.8;
harris.sigma2 = 1.5;
harris.threshold = 0.05;
harris.k = 0.04;
patch_size = 5;

% Choose which descriptor to use by indexing into the cell array
descriptor_func_ind = 1;

descriptor_funcs = {@patch_basic, @patch_norm, @patch_sort, @patch_sort_circle, @block_orientations};

% Patch size must be 16 for block_orientations
if descriptor_func_ind == 5
    patch_size = 16;
end

descriptor_func = descriptor_funcs{descriptor_func_ind};

% Harris corner detector
[ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayA, harris);
% Create descriptors
[interest_points_A, descriptorsA] = compute_descriptors(descriptor_func, I, Corners(:,1:2), patch_size);

% Add exit button to figure
H = uicontrol('Style', 'PushButton',  'String', 'Exit',  'Callback', 'delete(gcbf)');

while ishandle(H)

    Isrc = getsnapshot(vid);
    IgrayB = rgb2gray(ycbcr2rgb(Isrc));
    
    % Harris corner detector
    [ I, Ixx, Iyy, Ixy, Gxx, Gyy, Gxy, Hdense, Hnonmax, Corners] = harris_corner(IgrayB, harris);
    % Create descriptor
    [interest_points_B, descriptorsB] = compute_descriptors(descriptor_func, I, Corners(:,1:2), patch_size);

    % Match descriptors
    matchesAB = match_descriptors(descriptorsA, descriptorsB);

    % Display results
    show_matches(IgrayA, IgrayB, interest_points_A, interest_points_B, matchesAB)

end

delete(vid);
