    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:               input pointcloud (3xN)
%     maxdist:         Max. distace between two points of the same cluster (in meters)
%    
%  output   arguments
%     clusters:        coordinates of cluster centroids (3xC matrix, C = number of clusters)
%     point2cluster:   1xN vector, storing the assigned cluster number for each point
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [clusters, point2cluster] = cluster_kdtree(p, maxdist)
    p = double(p');
    n = size(p,1);
    idx = randsample(n,1);
    pointsKDT = KDTreeSearcher(p);
    Y = p(idx,:); % Query data
    clus_num = 1;
    point2cluster = zeros(1,n);
    %outer_flag = 1;
    while 1
        inner_flag = 1;
        store_outer = idx;
        while inner_flag % for each clusters
            store_inner = [];
            for i = 1:size(Y,1)
                IdxKDT = rangesearch(pointsKDT, Y(i,:), maxdist);
                store_inner = [store_inner IdxKDT{1}];
            end
            store_inner = unique(store_inner);
            % assign querry points
            Y = p(store_inner(~ismember(store_inner,store_outer)),:);
            store_outer = [store_outer store_inner];
            % delete the duplicate points
            store_outer = unique(store_outer);
            if isempty(Y)
                inner_flag = 0;
            end
        end
        % store value and increase clus_num

        pos_points = find(point2cluster == 0);
        add_points = store_outer(ismember(store_outer, pos_points));

        point2cluster(1, add_points) = clus_num;
        %
        clus_num = clus_num + 1;
        if (size(store_outer,2) ==n)
            break;
        end
        % choose another random point
        a = 1:n;
        a = a(~ismember(1:n,store_outer));
        idx = a(1,randsample(size(a,2),1));
        Y = p(idx,:);
        idx = [idx store_outer];
        %
    end
    % mean of cluster
    num_cluster = max(point2cluster);
    clusters = zeros(num_cluster,3);
    for i = 1:num_cluster
        clusters(i,:) = mean(p(find(point2cluster == i),1:3));
    end
    clusters = clusters';
    point2cluster = point2cluster';

end