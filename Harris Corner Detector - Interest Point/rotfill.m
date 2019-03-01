function rot_im = rotfill(img, rotation)
%rotfill rotate an image, filling the parts that would otherwise have empty
%pixels by repeating pixels of the edges of the image (before the rotation)

[height, width] = size(img);

% get the diagonal extents of the rotated image
diag_len = sqrt(height^2 + width^2);

width_add = ceil(diag_len - width/2);
height_add = ceil(diag_len - height/2);

% repeat the edges of the image on the 4 sides so that the rotated image
% has repeated values instead of zeros
rtop = repmat(img(1,:), height_add, 1);
rleft = repmat(img(:,1), 1, width_add);
rbot = repmat(img(end,:), height_add, 1);
rright = repmat(img(:,end), 1, width_add);

% need the diagonals too, but just zeros, because they will be cropped out
diag_fill = zeros(height_add, width_add);

new_im = [diag_fill rtop diag_fill;
          rleft img rright;
          diag_fill rbot diag_fill];

rot_im = imrotate(new_im, rotation);

% get size after rotation of the original image, so we can crop it out
% correctly. Not very efficient, but oh well.
after_rotate = size(imrotate(img, rotation));
% the crop rectangle is defined by [xmin ymin width height]. Get the centre
% of the image, subtract half the size of the rotated image to get the xmin
% ymin coords
ar = [after_rotate(2) after_rotate(1)]; % need to flip size
% top left of rectangle
rot_size = size(rot_im);
xy = [rot_size(2) rot_size(1)]/2 - ar/2;

rot_im = imcrop(rot_im, [xy ar]);

end

