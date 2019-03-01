function imrow(img_file, row, sigma, thresh_low, thresh_high)
%IMROW Show the pixel values of a row at each stage of the canny process
% img_file: path of the image file to show
% row: the row to display
% sigma: blur to apply
% thresh_low: low threshold for hysteresis
% thresh_high: high threshold for hysteresis


img = double(imread(img_file))./255.0;
if ndims(img) == 3
  img = rgb2gray(img);
end

blur_img = blur_gauss(img, sigma);
[gradients, orientations] = sobel(blur_img);
edges = non_max(gradients, orientations);
canny_edges = hyst_thresh(edges, thresh_low, thresh_high);

mod_img = blur_img;
mod_img(row, :) = 0;
mod_img = cat(3, mod_img, mod_img, mod_img);
mod_img(row,:, 1) = 255;

figure
imshow(mod_img)

figure
subplot(2,1,1)
plot(img(row,:))
title('original intensities')
subplot(2,1,2)
plot(blur_img(row,:))
title('blurred intensities')

figure
subplot(3,1,1)
plot(gradients(row,2:end-1))
title('sobel gradient magnitudes')
subplot(3,1,2)
plot(edges(row,:))
title('nonmax edges')
subplot(3,1,3)
plot(canny_edges(row,:))
title('canny edges')

end