function plot_rectangles(test_im, template, x, y, s, o)
%PLOT_RECTANGLES Plots rectangles given an x, y, scale and orientation
% I image on which to plot the rectangles
% x x coordinates of the top left corner of the rectangles
% y y coordinates of the top left corner of the rectangles
% s scale of the rectangle relative to the template
% o orientation of the rectangle in radians, positive rotation is
% clockwise, 0 rotation along the x axis

imshow(test_im)

hold_state = ishold;
hold on;
% rectangle coordinates before transformation. Assumes that the template
% image is the same size as the bounding box of the template
[h2, w2] = size(template);
xr = [0, w2, w2, 0, 0];
yr = [0, 0, h2, h2, 0];
p = [xr;yr];

for i=1:numel(x)
    % transform coordinates according to rotation and translation
    tp = transform_points(p, x(i), y(i), s(i), o(i));
    plot(tp(1,1:3), tp(2,1:3),'b', 'LineWidth', 3);
    plot(tp(1,3:end), tp(2,3:end),'g', 'LineWidth', 3);
end

if ishold ~= hold_state
    hold
end

end

