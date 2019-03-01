function overlaid = edge_overlay(image, edges, overlay_colour)
%EDGE_OVERLAY overlay a binary image onto another image
% The image and edge image should be the same size.
% edges: binary image to overlay on the given image.
% overlay_colour: specifies the colour to use for the overlaid edges, a
% 3 element vector [r g b]. Default is red.
if nargin < 3
    overlay_colour = [1 0 0];
end

if ndims(image) == 3
    overlaid = image;
else
    % if the image is grayscale, concatenate it to create 3 channels so we
    % can overlay with colour
    overlaid = cat(3, image, image, image);
end

[x, y] = find(edges);
imsize = size(overlaid);
dim3 = ones(size(x));

edge_inds_r = sub2ind(imsize, x, y, dim3);
edge_inds_g = sub2ind(imsize, x, y, dim3 + 1);
edge_inds_b = sub2ind(imsize, x, y, dim3 + 2);

overlaid(edge_inds_r) = overlay_colour(1);
overlaid(edge_inds_g) = overlay_colour(2);
overlaid(edge_inds_b) = overlay_colour(3);
end

