%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [clusters, point2cluster] = cluster_single(p, maxdist)
%  purpose :    cluster pointcloud to isolate objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:               input pointcloud (3xN, [x y z]')
%     maxdist:         Max. distance between two points of the same cluster (in meters)
%    
%  output   arguments
%     clusters:        coordinates of cluster centroids (3xC matrix, C = number of clusters)
%     point2cluster:   1xN vector, storing the assigned cluster number for each point
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [clusters, point2cluster] = cluster_single(p, maxdist)
    p = double(p'); % Nx3: each point is taken as one row
    size(p)
    clus_num = 1;
    d = ipdm(p);
    p(1,4) = 1;
    % 1. first step: Greedy algorithm % 
    for i = 1:size(p,1) % go through all points
        pos = find(d(i,:)~=0 & d(i,:) < maxdist);
        if ~isempty(pos) %
            temp = p(pos,4);
            if p(i,4) == 0 
                if isempty(find(temp ~= 0))
                    clus_num = clus_num + 1;
                    p(i,4) = clus_num;
                    p(pos,4) = p(i,4); % new clusters 
                else
                    min_index = min(p(pos(find(temp ~= 0)),4));
                    p(i,4) = min_index;
                    p(pos,4) = min_index;
                end
            else % p(i,4) == 0 --> choose the min - index
                if isempty(find(temp ~= 0))
                    p(pos,4) = p(i,4); % new clusters 
                else
                    min_index = min(p([i pos(find(temp ~= 0))],4));
                    p(i,4) = min_index;
                    p(pos,4) = min_index;
                end
            end
      
        end
    end
    %  
    point2cluster = p(:,4);
    temp1 = find(point2cluster == 0);
    if ~isempty(temp1)
        for i = 1:size(temp1,1)
            point2cluster(temp1(i,1), 1) = clus_num + i;
        end
    end
    disp('Greedy algorithm finished ...') 
    % extremely reduce the combination sets
    disp('Single Linkage ...')
    break_flag = 0;
    while (~break_flag)
        point2cluster = clean_clusnum(point2cluster);
        c = combnk(1:max(point2cluster),2); % go through all the combination of c
        merge = [];
        for i = 1:size(c,1)
            clus_A = p(find(point2cluster == c(i,1)),1:3);
            clus_B = p(find(point2cluster == c(i,2)), 1:3);
            if (~isempty(clus_A) && ~isempty(clus_B))
                dist = ipdm(clus_A,clus_B,'Subset','SmallestFew','limit',1,...
                    'result','struct');
                if (dist.distance < maxdist)
                     merge = [merge;c(i,:)];
                end
            else 
                continue;
            end
        end
        point2cluster_orig = point2cluster;
        if ~isempty(merge)
            for i =  1:size(merge)
                % merge B --> A
               temp2 = find(point2cluster_orig == merge(i,1));
               val_A = point2cluster(temp2(1,1),1);
               point2cluster(find(point2cluster_orig == merge(i,2)),1) = ...
                   val_A;
            end
        else
            break_flag = 1;
        end
    end
    % threshold
    %[p, point2cluster] = threshold_linkage(p, point2cluster);
    point2cluster = clean_clusnum(point2cluster);
    % mean of cluster
    num_cluster = max(point2cluster);
    clusters = zeros(num_cluster,3);
    for i = 1:num_cluster
        %size(p(find(point2cluster == i),1:3))
        clusters(i,:) = mean(p(find(point2cluster == i),1:3));
    end
    clusters = clusters';
    point2cluster = point2cluster';
    % support function
    function p2clus = clean_clusnum(p2clus)
        max_clus = max(p2clus);
        incre = 1;
        while (incre <= max_clus)

            mat = find(p2clus == incre);

            if isempty(mat)
                p2clus(find(p2clus > incre)) = ...
                    p2clus(find(p2clus > incre)) - 1;
            else
                incre = incre + 1; % update only valid
            end
            max_clus = max(p2clus);
            
        end
    end
    function [points, p2clus] = threshold_linkage(points, p2clus)
        max_clus = max(p2clus);
        del_ind = [];
        for ind = 1:max_clus
            mat = find(p2clus == ind);
            if size(mat,1) <= 10 % threshold
                del_ind = [del_ind;mat];
            end
        end
        
        if ~isempty(del_ind)
            points(del_ind,:) = [];
            p2clus(del_ind,:) = [];
        end
    end
    
end
