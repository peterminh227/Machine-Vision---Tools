%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [a,b,c,d,inliers,k] = fitPlaneRANSAC(p, confidence, inlier_margin, min_sample_dist)
%  purpose :    find dominant plane in pointcloud with RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:               input pointCloud object
%     params.inlier_threshold:   Max. distance of a point from the plane to be considered an "inlier" (in meters)
%  output   arguments
%     a,b,c,d:         plane parameters
%     inliers:         logical array marking the inliers of the pointcloud
%
%   Author:
%   MatrNr:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a,b,c,d,inliers] = fit_plane(p, params)

[model, inliers, ~] = pcfitplane(p, params.inlier_threshold);
        
% convert inliers to logical array for consitency
if isa(inliers, 'double')
    tmp_inliers = zeros(1, p.Count);
    tmp_inliers(inliers) = 1;
    inliers = logical(tmp_inliers);
end

a = model.Parameters(1);
b = model.Parameters(2);
c = model.Parameters(3);
d = model.Parameters(4);

end
