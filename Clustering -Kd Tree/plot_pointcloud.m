function plot_pointcloud(p, inliers)
% Plot a pointcloud
%
% If only p is passed, only the pointcloud will be plotted. With additional
% arguments, inliers will also be shown
%
% p: Pointcloud to plot (N x 6 or N x 3), or pointCloud
%
% inliers: Inliers to highlight

if isa(p, 'pointCloud')
    if nargin < 2
        pcshow(p, 'MarkerSize', 20)
    else
        pcoloured = copy(p);
        pcoloured.Color(inliers, :) = repmat([0 255 0], numel(find(inliers)), 1);
        pcoloured.Color(~inliers, :) = repmat([255 0 0], numel(find(~inliers)), 1);
        pcshow(pcoloured, 'MarkerSize', 20)
    end
else
    if nargin < 2
        if size(p, 1) < 6 % only xyz
            colours = repmat([0 1 0], size(p, 2), 1);
        else
            colours = [p(:,4) p(:,5) p(:,6)];
        end
        % only plot point cloud
        scatter3(p(:,1),p(:,2),p(:,3), [], colours, 'filled');
        rotate3d on
        set(gca,'DataAspectRatio',[1 1 1]);
        set(gca,'PlotBoxAspectRatio',[1 1 1]);
    else
        % plot inliers and outliers
        scatter3(p(1,find(inliers)),p(2,find(inliers)),p(3,find(inliers)), [], 'g.', 'filled');
        hold on;
        scatter3(p(1,find(~inliers)),p(2,find(~inliers)),p(3,find(~inliers)),[], 'r.', 'filled');

        % plot fitted plane as mesh
        padding = 0.2;

        pi = p(1:2,inliers);
        mins = min(pi,[],2);
        maxs = max(pi,[],2);

        rangex = mins(1)-padding:0.05:maxs(1)+padding;
        rangey = mins(2)-padding:0.05:maxs(2)+padding;
        [x y] = meshgrid(rangex, rangey);
        z = (-a*x -b*y-d)/c;
        mesh(x,y,z,'EdgeColor',[0 0 1])
        rotate3d on
        hold off;       
    end
end