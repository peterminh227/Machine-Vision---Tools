%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Vision and Cognitive Robotics WS 2014 - Exercise 5
% HELPER FUNCTION TO DISPLAY CLUSTERING RESULT FOR POINTCLOUD P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plot_clustering_result(p_in, clusters, point2cluster, cluster_threshold)
% cluster_threshold: clusters larger than this will have a colour, smaller
% ones will be gray

%cluster colors
ColorSet = [
0.00 0.00 1.00 % Data 1 - blue
0.00 1.00 0.00 % Data 2 - green
1.00 0.00 0.00 % Data 3 - red
0.00 1.00 1.00 % Data 4 - cyan
1.00 0.00 1.00 % Data 5 - magenta
0.75 0.75 0.00 % Data 6 - RGB
0.25 0.25 0.25 % Data 7
0.75 0.25 0.25 % Data 8
0.95 0.95 0.00 % Data 9
0.25 0.25 0.75 % Data 10
0.75 0.75 0.75 % Data 11
0.00 0.50 0.00 % Data 12
0.76 0.57 0.17 % Data 13
0.54 0.63 0.22 % Data 14
0.34 0.57 0.92 % Data 15
1.00 0.10 0.60 % Data 16
0.88 0.75 0.73 % Data 17
0.10 0.49 0.47 % Data 18
0.66 0.34 0.65 % Data 19
0.99 0.41 0.23 % Data 20
];

if nargin < 4
    cluster_threshold = 10;
end

hold_state = ishold;
pc_obj = isa(p_in, 'pointCloud');
if pc_obj
    p = copy(p_in);
else
    p = p_in;
end

valid_clusters = []; % indices clusters above the threshold
for c=unique(point2cluster(:)') % funky syntax to ensure columns/rows give expected iteration
    % points with the current cluster index
    idx = (point2cluster == c);
    
    if pc_obj
        % don't display too small clusters
        if sum(idx) >= cluster_threshold
            p.Color(idx, :) = repmat(uint8(ColorSet(mod(c,size(ColorSet,1))+1,:)*255),...
                                    numel(find(idx)), 1);
            valid_clusters = [valid_clusters c];
        else
            p.Color(idx, :) = repmat([128 128 128], numel(find(idx)), 1);
        end
    else
        hold on;
        % don't display too small clusters
        if sum(idx) > cluster_threshold
            plot3(p(1,idx),p(2,idx),p(3,idx), ...
                'Color',ColorSet(mod(c,size(ColorSet,1))+1,:), ...
                'Marker','.','LineStyle','None');

            valid_clusters = [valid_clusters c];
        else
            plot3(p(1, idx), p(2, idx), p(3, idx), ...
                'Color', [0.5, 0.5, 0.5], ...
                'Marker', '.', ...
                'LineStyle', 'None')
        end
    end
end

if pc_obj
    pcshow(p, 'MarkerSize', 150)
    hold on;
else
    rotate3d on
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gca,'PlotBoxAspectRatio',[1 1 1]);
end

scatter3(clusters(1,valid_clusters),clusters(2,valid_clusters), ...
       clusters(3,valid_clusters),'k','filled');

% return hold to the state it was in before this function call
if ishold ~= hold_state
   hold 
end

set(gca,'ZDir','reverse');
view(180,90);
