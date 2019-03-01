%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [error, inliers] = ransac_error(~, distances, threshold)
%  purpose :    compute the RANSAC error and inliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     ~:         Unused argument for compatibility with other error funcs
%     distances: Perpendicular distance of each point to the plane
%     threshold: Points with distance less than this are inliers
%  output   arguments
%     error:   RANSAC error for given distances and threshold
%     inliers: logical array of inliers
%
%   Author: Minh Nhat Vu
%   MatrNr:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [error, inliers] = ransac_error(~, distances, threshold)
    inliers = find(distances < threshold); 
    outliers = distances >= threshold;
    error = 0* sum(distances(inliers).^2) + 1*sum(distances(outliers).^2);
end