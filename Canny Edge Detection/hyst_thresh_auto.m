%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  edges = hyst_thresh_auto(edges_in, low_prop, high_prop)
%  purpose: hysteresis thresholding with automatic threshold selection
%  based on proportion of edge pixels to be found above high and low
%  thresholds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input arguments
%     edges_in: edge image (m x n)
%     low_prop: proportion of edge pixels in the image that should be found
%               above the low threshold
%     high_prop:  proportion of edge pixels in the image that should be
%                 found above the high threshold
%  output arguments
%     edges: binary edge image with hysteresis thresholding applied, where
%            thresholds have been automatically selected based on edge
%            pixel values (m x n)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edges = hyst_thresh_auto(edges_in, low_prop, high_prop)

[counts, edges] = histcounts(edges_in,50);
edges_midpoints = (edges(1:end-1) + edges(2:end))/2;
i = 1;
% guess value
Th(i) = round(sum(counts.*edges_midpoints))/sum(counts);
% compute mean_above T and mean_below T using the guess T
bg_pixel = cumsum(counts(edges_midpoints<=Th(i))); % background
mean_below = sum(edges_midpoints(edges_midpoints<=Th(i)).*...
    counts(edges_midpoints<=Th(i)))/bg_pixel(end);
fg_pixel = cumsum(counts(edges_midpoints>Th(i))); % foreground pixel
mean_above = sum(edges_midpoints(edges_midpoints>Th(i)).*...
    counts(edges_midpoints>Th(i)))/fg_pixel(end);
i = i+1;
Th(i) = (mean_below + mean_above)/2.0;
% iteration
while abs(Th(i)-Th(i-1))> 0.001
    disp('current Th')
    Th(i)
    bg_pixel = cumsum(counts(edges_midpoints<=Th(i)));
    mean_below = sum(edges_midpoints(edges_midpoints<=Th(i)).*...
        counts(edges_midpoints<=Th(i)))/bg_pixel(end);
    %
    
    fg_pixel = cumsum(counts(edges_midpoints>Th(i))); % foreground pixel
    mean_above = sum(edges_midpoints(edges_midpoints>Th(i)).*...
    counts(edges_midpoints>Th(i)))/fg_pixel(end);
    i=i+1;
    Th(i) = (mean_below+mean_above)/2; 
end
%
high = Th(i); low = 0.5*high;
edges = hyst_thresh(edges_in, low, high); 
end