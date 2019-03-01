%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [error, inliers] = msac_error(~, distances, threshold)
%  purpose :    compute the MSAC error and inliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     ~:         Unused argument for compatibility with other error funcs
%     distances: Perpendicular distance of each point to the plane
%     threshold: Points with distance less than this are inliers
%  output   arguments
%     error:   MSAC error for given distances and threshold
%     inliers: logical array
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [error, inliers] = msac_error(~, distances, threshold)
    inliers = find(distances < threshold);
    outliers = distances >= threshold;
    error = 1* sum(distances(inliers).^2) + threshold^2 * sum(distances(outliers).^2);

end