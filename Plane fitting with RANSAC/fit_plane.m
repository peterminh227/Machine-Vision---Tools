%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [a,b,c,d,inliers,k] = fit_plane(p, params)
%  purpose :    find dominant plane in pointcloud with sample consensus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:                      input pointcloud (N x 3, column: [x y z])
%     params: parameters for the sample consensus
%     params.confidence:      solution confidence in percent, range [0, 1)
%     params.inlier_threshold:   Max. distance of a point from the plane to be considered an inlier (in meters)
%     params.min_sample_dist: Min. distance of all sampled points to each other (in meters).
%     params.error_func:      Function to use when computing inlier error
%  output   arguments
%     a,b,c,d:         plane parameters
%     inliers:         logical array marking the inliers of the pointcloud
%     k:			   number of iterations needed
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a,b,c,d,inliers,k] = fit_plane(p, params)
p = p'; % [nx3] to [3xn]
% main function -  RANSAC 
s = 3; % minimum 3 points to fit a plane
trialcount = 0;
bestM = NaN;
maxTrials = 10000;
%
k = maxTrials; % ~ guess number
maxDataTrials = 100;
[~,numpoint] = size(p);
M = [];
min_error = inf;
while k > trialcount
    degenerate = 1;
    count = 1;
    while degenerate % do not choose 3 points at the same line
        ind = randsample(numpoint,s);
        degenerate = is_nonrobust(p(:,ind), params.min_sample_dist);
        % check if 3 points on the line, and distances
        if ~degenerate
            M = create_plane(p(:,ind));
        end
        if isempty(M)
            degenerate = 1;
        end
        count = count + 1;
        if count > maxDataTrials
            warning('Problem in the data-set');
            break
        end
    end
    [inliers, M, error_current] = X2P_distance(M,p, params.inlier_threshold, ...
        params.error_func);
    ninliers = length(inliers);
    
    if error_current < min_error
       min_error = error_current;
       bestinliers = inliers;
       bestM = M;
       fracinliers = ninliers/numpoint;
       pnum_outliers = 1 - fracinliers^s;
       pnum_outliers = min(max(eps,pnum_outliers), 1-eps);
       k = log(1-params.confidence)/log(pnum_outliers);
    end
    trialcount = trialcount + 1;
    fprintf('trial %d out of %d \r',trialcount, ceil(k));
    if trialcount > maxTrials
        fprintf('ransac reached the maximum number of %d trials \n',...
                maxTrials);
        break
    end
end % end of the main iterations
if ~isnan(bestM)
   M = bestM;
   inliers = bestinliers;
else
   M = [];
   inliers = [];
   fprintf('ransac was unable to find a useful solution');
end
% calculate the fitplane [a,b,c,d]
A  = p(:,inliers)'; % nx3 matrix
b = ones(size(A,1),1);
sol = A \ b;
%sol
%aa
a = sol(1); b = sol(2); c = sol(3); d = 1;
%
    function P = create_plane(X)
        P = X;
    end
    function r = is_nonrobust(X,min_dist) 
         % r = 1 if points are co-linear, 0 otherwise
         % X = [p1(1:3),p2(1:3),p3(1:3)]  
         p1 = X(:,1); p2 = X(:,2); p3 = X(:,3);
         r = norm(cross(p2-p1,p3-p1)) < eps;
         dist = [cal_dist(p1,p2), cal_dist(p1,p3), cal_dist(p2,p3)];
         r = ~(~r & all(dist > min_dist));
    end
    function dist = cal_dist(p1,p2)
        dist = sqrt(sum((p1 - p2).^2));
    end
    function [inliers, P, error] = X2P_distance(P,X,t, error_func) % distance points to plane 
        n = cross(P(:,2) - P(:,1), P(:,3) - P(:,1)); % normal vector
        n = n/norm(n);
        npoints = length(X);
        % perform the dot product
        dist = abs(sum((X - repmat(P(:,1),1, npoints)).*n,1));
        [error, inliers] = error_func(X', dist, t);
    end
end