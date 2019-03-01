%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  edges = hyst_thres(edges_in, low, high)
%  purpose :    hysteresis thresholding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     edges_in:    edge image (m x n)
%     low:  lower hysteresis threshold
%     high: higher hysteresis threshold
%  output   arguments
%     edges:     edge image with hysteresis thresholding applied (m x n)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edges = hyst_thresh(edges_in, low, high)
d = size(edges_in);
% predefine matrixs
edges_low = zeros(d); edges_high = zeros(d); edges = zeros(d);
% 
edges_low(edges_in > low) = 1;
edges_high(edges_in > high) = 1;
% check connectivity of pixels
indexs = find(edges_high>0);
% this is the fastest way, I guess, using mask-bit technique.
edges_take_indexes = imfill(edges_low==0, indexs, 8) - (edges_low == 0);
%
edges(edges_take_indexes>0) = edges_in(edges_take_indexes>0);

end