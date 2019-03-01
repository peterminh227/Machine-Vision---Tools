%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 2a: Interest Points and Descriptors
% Daniel Wolf, Michal Staniaszek 2017
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%===================================================

figure(1), clf

% read images
IgrayA = rgb2gray(imread('desk/Image-00.jpg'));
IgrayB = rgb2gray(imread('desk/Image-03.jpg'));
% rotate the second image (for testing descriptor performance)
% IgrayB = rotfill(IgrayB, 25);

% parameters: try different settings!
harris.sigma1 = 0.8;
harris.sigma2 = 1.5;
harris.threshold = 0.08;
harris.k = 0.04;
patch_size = 19;

% Choose which descriptor to use by indexing into the cell array
descriptor_func_ind = 5;

descriptor_funcs = {@patch_basic, @patch_norm, @patch_sort, @patch_sort_circle, @block_orientations};

% Patch size must be 16 for block_orientations
if descriptor_func_ind == 5
    patch_size = 16;
end

descriptor_func = descriptor_funcs{descriptor_func_ind};

% Harris corner detector
[ I, ~, ~, ~, ~, ~, ~, ~, ~, Corners] = harris_corner(IgrayA, harris);
% Create descriptors
[interest_pointsA, descriptorsA] = compute_descriptors(descriptor_func, I, Corners(:,1:2), patch_size);

% Use this to show the orientation histograms for each block in a
% descriptor
% figure
% show_orientation_hist(descriptorsA(1,:))

% Harris corner detector
[ I, ~, ~, ~, ~, ~, ~, ~, ~, Corners] = harris_corner(IgrayB, harris);
% Create descriptors
[interest_pointsB, descriptorsB] = compute_descriptors(descriptor_func, I, Corners(:,1:2), patch_size);

% Match descriptors
matchesAB = match_descriptors(descriptorsA, descriptorsB);

% Display results
show_matches(IgrayA, IgrayB, interest_pointsA, interest_pointsB, matchesAB)

drawnow();
