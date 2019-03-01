clear all
close all
clc
% MAIN SCRIPT 
%%%%%%%% SELECT POINTCLOUD FILE %%%%%%%%
pointcloud_idx = 8;            % 0-9
cloud_path_test = 'test';
cloud_path_train = 'training';
extension = 'pcd';
%===================================================
%%%%% RANSAC PARAMS %%%%
downsample_percent = 1;
sac_params.inlier_threshold = 0.03;      % in meters
%===================================================
%%%%% CLUSTERING PARAMS %%%%
downsample_prop = 0.2;
maxdist = 0.02;           % in meters
%===================================================

% RGB Intrinsic Parameters
params.fx_rgb = 5.1885790117450188e+02;
params.fy_rgb = 5.1946961112127485e+02;
params.cx_rgb = 3.2558244941119034e+02-5;
params.cy_rgb = 2.5373616633400465e+02-12;
%
% Rotation
params.R = -[ 9.9997798940829263e-01, 5.0518419386157446e-03, ...
   4.3011152014118693e-03, -5.0359919480810989e-03, ...
   9.9998051861143999e-01, -3.6879781309514218e-03, ...
   -4.3196624923060242e-03, 3.6662365748484798e-03, ...
   9.9998394948385538e-01 ];

params.R = reshape(params.R, [3 3]);
params.R = inv(params.R');
% 3D Translation
t_x = 2.5031875059141302e-02;
t_z = -2.9342312935846411e-04;
t_y = 6.6238747008330102e-04;
params.t = [t_x, t_y, t_z]';
%===================================================
%%%%% SIFT  %%%%
addpath('../vlfeat-0.9.21/toolbox')
vl_setup
% Setup-cloud test image
pc_fname = sprintf('dataset/%s/image%03d.%s', cloud_path_test, pointcloud_idx, extension);
p_orig = pcread(pc_fname);
p_orig = p_orig.removeInvalidPoints();
% downsample to 10% of original number of points
p_downsampled = pcdownsample(p_orig, 'random', downsample_percent);
% delete all [0;0;0] entries
p = p_downsampled.select(find(all(p_downsampled.Location ~= [0 0 0], 2)));
% RANSAC ALGORITHM - use bult in function 
[model, inliers, ~] = pcfitplane(p, sac_params.inlier_threshold);
% convert inliers to logical array for consitency
if isa(inliers, 'double')
    tmp_inliers = zeros(1, p.Count);
    tmp_inliers(inliers) = 1;
    inliers = logical(tmp_inliers);
end
figure(100);
plot_pointcloud(p, inliers);
% remove all points of the plane
p_filtered = select(p, find(~inliers));
%
testLocation_2D = project_3D(p_filtered.Location',params); %[u,v]
testLocation_2D(isnan(testLocation_2D)) = 100;
testLocation_2D = round(testLocation_2D);
construct_rgb = uint8(zeros(480,640,3));
construct_rgb(sub2ind(size(construct_rgb),...
    testLocation_2D(2,:), testLocation_2D(1,:), ones(1,size(testLocation_2D,2)))) = ...
    p_filtered.Color(:,1)'; % r
construct_rgb(sub2ind(size(construct_rgb), testLocation_2D(2,:), testLocation_2D(1,:), ...
        repmat(2,1,size(testLocation_2D,2)))) = p_filtered.Color(:,2)'; % g
construct_rgb(sub2ind(size(construct_rgb), testLocation_2D(2,:), testLocation_2D(1,:), ...
        repmat(3,1,size(testLocation_2D,2)))) = p_filtered.Color(:,3)'; % b
figure(1)
imshow(construct_rgb)
% subsample the filtered points
psub = select(p_filtered, randperm(p_filtered.Count, round(p_filtered.Count * downsample_prop)));
% CLUSTERING ALGORITHM - kdtree
fprintf(1,'Clustering...\n');
g = tic;
[clusters, point2cluster] = cluster_kdtree(psub.Location', maxdist);
toc(g)
%  clusters = 3 x num_of_clus
% point2cluster = 3 x num_of_points
figure(1000)
plot_pointcloud(psub)
fprintf(1,'DONE. %d clusters found.\n', size(clusters,2));
% plotting
figure(101);
plot_clustering_result(psub, clusters, point2cluster);
title(sprintf('Pointcloud %d', pointcloud_idx)); 
% project 3D point clould to 2D 
psub_2D = project_3D(psub.Location',params); %[u,v]
psub_2D = round(psub_2D);
valid_clusters = [];
center_clusters = [];
cluster_threshold = 20;
for c=unique(point2cluster(:)') % funky syntax to ensure columns/rows give expected iteration
    % points with the current cluster index
    idx = (point2cluster == c);
    idx_find = find(point2cluster == c);
    if sum(idx) >= cluster_threshold
            valid_clusters = [valid_clusters c];
            cen_x = round(mean(psub_2D(1,idx_find)));
            cen_y = round(mean(psub_2D(2,idx_find)));
            center_clusters = [center_clusters [cen_x cen_y]'];
    end
end
% 
figure(5)
value = 1:size(valid_clusters,2);
insert_TEXT = insertText(construct_rgb, center_clusters', ...
    value, 'AnchorPoint','LeftBottom');
imshow(insert_TEXT)
% assign to the color map
jet_map = jet(size(valid_clusters,2));
figure(200);
%dark_blue = [0, 0.0118, 0.3569];
dark_blue = [0, 0, 0];
projected_img(:,:,1) = repmat(dark_blue(1,1), 480, 640); % r
projected_img(:,:,2) = repmat(dark_blue(1,2), 480, 640); % r
projected_img(:,:,3) = repmat(dark_blue(1,3), 480, 640); % r
count = 0;
for c = valid_clusters
    count = count + 1;
    
    idx = find(point2cluster == c);
    % position
    pos = psub_2D(:,idx);
    projected_img(sub2ind(size(projected_img), pos(2,:), pos(1,:), ...
        ones(1,size(pos,2)))) = jet_map(count,1);
    projected_img(sub2ind(size(projected_img), pos(2,:), pos(1,:), ...
        repmat(2,1,size(pos,2)))) = jet_map(count,2);
    projected_img(sub2ind(size(projected_img), pos(2,:), pos(1,:), ...
        repmat(3,1,size(pos,2)))) = jet_map(count,3);
end
se = strel('disk',round(50*downsample_prop/2)); 
se_erode = strel('disk',round(30*downsample_prop/2)); 

projected_img = imdilate(projected_img,se);
projected_img = imerode(projected_img,se_erode);
imshow(projected_img)

vote_clusters = zeros(size(valid_clusters,2),size(valid_clusters,2));
% Matching process: 
% Setup-clould training image
if (pointcloud_idx <8)
    type = ["cookiebox","cup","ketchup","sugar","sweets","tea"];
    training_counts = [21, 16, 21, 21, 21, 21];
else
    type = ["book","cookiebox","cup","ketchup","sugar","sweets","tea"];
    training_counts = [16, 21, 16, 21, 21, 21, 21];
end
% Normalize intensities to range  [0 1]
test_im_gray = double(rgb2gray(construct_rgb))/255.0;
test_im_gray=test_im_gray-min(test_im_gray(:));
test_im_gray=test_im_gray/(max(test_im_gray(:)) - min(test_im_gray(:)));
%test_im_gray = imsharpen(test_im_gray);
[frames1,descr1] = vl_sift(single(test_im_gray));
for m = 1:numel(type)
    set_type = type(m);
    fprintf("voting %s ... \n", set_type)
    for j=1:training_counts(m)+1
        fprintf("process:%d ...\n", j-1)
        pct_fname = sprintf('dataset/%s/%s%03d.%s', cloud_path_train, ...
            set_type, j-1, extension);
        pt_orig = pcread(pct_fname);
        pt_orig = pt_orig.removeInvalidPoints();

        % 
        tLocation_2D = project_3D(pt_orig.Location',params); %[u,v]
        tLocation_2D = round(tLocation_2D);
        white = [255, 255, 255];
        projected_timage = []; % reset
        projected_timage(:,:,1) = uint8(repmat(white(1,1), 480, 640)); % r
        projected_timage(:,:,2) = uint8(repmat(white(1,2), 480, 640)); % g
        projected_timage(:,:,3) = uint8(repmat(white(1,3), 480, 640)); % b
        %

        %
        projected_timage(sub2ind(size(projected_timage),...
            tLocation_2D(2,:), tLocation_2D(1,:), ones(1,size(tLocation_2D,2)))) = ...
            pt_orig.Color(:,1)'; % r
        projected_timage(sub2ind(size(projected_timage), tLocation_2D(2,:), tLocation_2D(1,:), ...
                repmat(2,1,size(tLocation_2D,2)))) = pt_orig.Color(:,2)'; % g
        projected_timage(sub2ind(size(projected_timage), tLocation_2D(2,:), tLocation_2D(1,:), ...
                repmat(3,1,size(tLocation_2D,2)))) = pt_orig.Color(:,3)'; % b
        % 
        %figure(3)
        upp_x = max(tLocation_2D(1,:)); low_x  = min(tLocation_2D(1,:));
        upp_y = max(tLocation_2D(2,:)); low_y  = min(tLocation_2D(2,:));
        compress_projected_timage = uint8(projected_timage(low_y:upp_y,low_x:upp_x,:));
        %imshow(uint8(projected_timage));
        %figure(30)
        projected_timage = compress_projected_timage;
        %imshow(projected_timage);
        
        % Calculate the SIFT for the projected image ... 
        template = double(rgb2gray(projected_timage))/255.0;
        % 
        template=template-min(template(:));
        template=template/(max(template(:)) - min(template(:)));
        %template = imgaussfilt(template,0.5);
        %
        fprintf('Computing frames and descriptors.\n') ;
        %template = imresize(template,1.25);
        [frames2,descr2] = vl_sift(single(template));
        % 
        fprintf('Computing matches.\n') ;
        descr1=uint8(descr1);
        descr2=uint8(descr2);
        matches=vl_ubcmatch(descr1, descr2, 2.2);
        % plot calculated SIFT descriptors
        %figure(2); clf;
        %imagesc(construct_rgb) ; colormap gray ;
        %hold on ;
        %h=vl_plotframe(frames1) ; set(h,'LineWidth',2,'Color','g') ;
        % plot matches
        figure(4); clf;
        plot_matches(test_im_gray,template,frames1, frames2, matches, 'points', 'random');
        
        % voting process: 
        for i=1:size(matches,2) % go through all matches ...
            pos_x = round(frames1(1,matches(1,i)));
            pos_y = round(frames1(2,matches(1,i)));
            take_color = reshape(projected_img(pos_y,pos_x,:),1,3);
            vote_index = find(ismember(jet_map,take_color,'rows'));
            vote_clusters(m,vote_index) = vote_clusters(m,vote_index) + 1;
        end
    end
end
% data processing: 1. choose the largest to pick
%
vote_clusters
for run_ind = 1:size(vote_clusters,1)
    [max_rows, ind] = max(vote_clusters,[],2);
    [~,rows_ind] = max(max_rows);
    name_clusters{ind(rows_ind)} = char(type(rows_ind));
  
    % reset value
    vote_clusters(rows_ind,:) = -1;
    vote_clusters(:,ind(rows_ind)) = -1;
end
name_clusters
figure(500)
insert_TEXT_final = insertText(construct_rgb, center_clusters', ...
    name_clusters, 'AnchorPoint','LeftBottom');
imshow(insert_TEXT_final)

