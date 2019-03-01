%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [error, inliers] = mlesac_error(points, distances, threshold)
%  purpose :    compute the MLESAC error and inliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     points:    Points in the cloud (N x 3)
%     distances: Perpendicular distance of each point to the plane
%     threshold: Points with distance less than this are inliers
%  output   arguments
%     error:   MLESAC error for given distances and threshold
%     inliers: logical array of inliers
%
%   Author: Minh Vu Nhat
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [error, inliers] = mlesac_error(points, distances, threshold)
    % define param
    mu = 0;
    sigma = threshold;
    max_point = max(points); min_point = min(points);
    gap = max_point - min_point; 
    % calculate bounding box diagonal
    v = sqrt(sum(gap.*gap));
    %
    inliers = find(distances < threshold);
    %gamma = length(inliers)/size(points, 1);
    % Refer to the papers --> 
    gamma = 0.5;
    for i = 1:100
        linlier_Prob = gamma * normpdf(distances.^2,mu,sigma);
        loutlier_Prob = (1-gamma)/v;
        dinlier_Prob = linlier_Prob./(linlier_Prob + loutlier_Prob);
        gamma = mean(dinlier_Prob);
    end   
    
    Pr = gamma*normpdf(distances.^2,mu,sigma) + (1-gamma)/v;
    error = -sum(log(Pr));
    
end