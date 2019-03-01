%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [filtered_points, plane_eqs, plane_pts] = filter_planes(p, min_points_prop, sac_params)
%  purpose :    filter planes from a pointcloud
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:               Input pointcloud (N x 3, column: [x y z])
%     min_points_prop: If the number of points in an extracted plane is
%                      less than min_points_prop * N, stop the process.
%     sac_params:      Parameters to use for sample consensus
%  output   arguments
%     filtered_points: Points remaining in the cloud after removing planes
%     (M x 3)
%     plane_eqs:       Extracted plane equations/normals (P x 4)
%     plane_pts:       Cell array of P matrices, containing points filtered
%                      for each plane in plane_eqs (Q x 3)
%
%   Author: Minh Nhat Vu
%   MatrNr:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filtered_points, plane_eqs, plane_pts] = filter_planes(points, min_points_prop, sac_params)
plane_eqs = [];
filtered_points = points; % nx3
total_point = size(points,1);
plane_pts = {};
count = 0;
while 1
    [a,b,c,d,inliers,~] = fit_plane(filtered_points, sac_params);
    
    count = count+1;
    if size(inliers,2) < min_points_prop* total_point
        %plane_eqs  = [plane_eqs; [a b c d]];
        %plane_pts{count} = points(inliers,:);
        %points = filtered_points;
        break;
    else
        filtered_points(inliers,:) = [];
        plane_eqs  = [plane_eqs; [a b c d]];
        plane_pts{count} = points(inliers,:);
        points = filtered_points;
    end
end
end