function mask = circle_mask(dsize)
%CIRCLE_MASK create a logical matrix of dsize x dsize containing a circle

radius = dsize/2;
[col, row] = meshgrid(1:dsize, 1:dsize);
mask = (row - radius - 0.5).^2 + (col - radius - 0.5).^2 <= radius^2;

end