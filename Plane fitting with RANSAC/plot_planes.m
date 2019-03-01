function plot_planes(p_in, a, b, c, d, inliers, colours)
% Plot planes, using information about inliers and points to
% define bounds
% p_in: points in the cloud, or pointCloud object
% a, b, c, d: plane coefficients. Can be scalars or vectors. If vectors,
% multiple planes will be plotted.
% inliers: logical array with 1 if the corresponding point is an inlier.
% Used to define the plane extents on the plot. Pass an empty array to use
% the whole cloud to define the plane extents. Can be a vector or a matrix,
% where each row defines the inliers for the plane with the coefficients at
% the corresponding index.
% colours: colour to use for each plane. If one value is passed, the same
% value is used for all planes. Can be any colour definition accepted by the
% "FaceColor" parameter of the surf command.

if isa(p_in, 'pointCloud')
    p = p_in.Location';
else
    p = p_in;
end

nplanes = min([numel(a), numel(b), numel(c), numel(d)]);

if nargin < 6
    inliers = [];
end

if nargin < 7
    colours = 'b';
end 

holdstate = ishold;
hold on;
for i = 1:nplanes
    if ~any(inliers)
        % Without inliers, use the min/max of the whole cloud for size
        pa = p(1:2, :);
        mins = min(pa, [], 2);
        maxs = max(pa, [], 2);
    else
        % If we have inliers, limit the plane size to their bounding box
        pi = p(1:2,logical(inliers(i, :)));
        mins = min(pi,[],2);
        maxs = max(pi,[],2);
    end

    padding = 0.2;  
    rangex = [mins(1)-padding,maxs(1)+padding];
    rangey = [mins(2)-padding,maxs(2)+padding];
    [x, y] = meshgrid(rangex, rangey);
    z = plane_z_from_xy(x, y, a(i), b(i), c(i), d(i));
    
    if size(colours, 1) == 1
        this_colour = colours;
    else
        this_colour = colours(i, :);
    end
    s = surf(x, y, z, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceColor', this_colour);
    % quiver3(x, y, z, repmat(a(i), size(x)), repmat(b(i), size(y)), repmat(c(i), size(z)), 'g')
    % if the data aspect ratio and box aspect ratio are not set, the
    % normals will look incorrect despite them having the same value as
    % you receive from surfnorm
    % https://de.mathworks.com/matlabcentral/answers/100252
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gca,'PlotBoxAspectRatio',[1 1 1]);
    alpha(s, .3)
    grid on
end

mean_normal = mean([a b c]);
% plot an average plane based on the mean normal, if more than one plane is
% given
if ~isscalar(mean_normal)
    mean_normal = mean_normal/norm(mean_normal);
    quiver3(0,0, -mean(d), mean_normal(1), mean_normal(2), mean_normal(3), 'r')
    z = plane_z_from_xy(x, y, mean_normal(1), mean_normal(2), mean_normal(3), mean(d));
    surf(x, y, z, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceColor', 'g')
end

if numel(a) == 1
    title(sprintf('a=%.03f, b=%.03f, c=%.03f, d=%.03f', a, b, c, d))
end

% We turn hold on above, but want to return to the hold state that exists in
% the caller - if it is different, toggle the hold state
if holdstate ~= ishold
    hold
end

end

