%% generate plane with noise
npts = 1000; % total points in the plane

% Plane around which to generate points
plane_x = 0.2;
plane_y = 0;
plane_z = 1;
plane_offset = -2;
norm_plane_eq = [plane_x, plane_y, plane_z]/norm([plane_x, plane_y, plane_z]);

% All of these axes are in the coordinate system of the plane
% Points are generated uniformly within this range and then perturbed in
% the z axis either by uniform or gaussian noise
x_spread = 3; % Positive and negative spread of points on x axis
y_spread = 3; % Positive and negative spread of points on y axis
z_spread = 0.2; % Positive and negative spread of points on z axis
z_norm_spread = 1; % Standard deviation of gaussian used to generate outlier points
gauss_prop = 0.9; % Proportion of points to perturb with gaussian noise

pts = pointCloud(noisy_plane(plane_x, plane_y, plane_z, plane_offset, npts, x_spread, y_spread, z_spread, z_norm_spread, gauss_prop)');

% show cloud and correct plane
figure(1); clf
hold on
plot_planes(pts.Location', plane_x, plane_y, plane_z, plane_offset)
plot_pointcloud(pts)

figure(2)
pcshow(pts, 'MarkerSize', 40)

%% Example of plotting multiple planes

nplanes = 5;
sigma = 0.1;
plane_eqs = [];
for i=1:nplanes
   % perturb the original plane by gaussian noise along each coefficient
   plane_eqs(i, :) = [plane_x, plane_y, plane_z, plane_offset] + randn(1,4) * sigma;
end

mean_offset = mean(plane_eqs(:,4));

figure(2); clf;
hold on;
plot_pointcloud(pts)
% use this if you have inliers for each plane
% plotPointCloud(pts, inliers, 'count')

% All planes. Can pass inliers as the last parameter to constrain the drawn
% planes to their inliers. By default they are drawn to the bounds of the
% cloud. Mean plane from normals is plotted in green.
plot_planes(pts, plane_eqs(:, 1), plane_eqs(:, 2), plane_eqs(:, 3), plane_eqs(:, 4))
% actual plane
plot_planes(pts, plane_x, plane_y, plane_z, plane_offset, [], 'r')


%% create parameter settings
params.confidence = 0.99;
params.inlier_threshold = 0.5;
params.min_sample_dist = 0.2;
params.min_iter = 5;
params.error_func = @ransac_error;

ransac_params = params;
ransac_params.name = 'ransac';

msac_params = params;
msac_params.name = 'msac';
msac_params.error_func = @msac_error;

mlesac_params = params;
mlesac_params.name = 'mlesac';
% ~68% of points in first sd, 95% in 2sd, so divide original threshold by 2
% to get approximate equivalence of inliers
mlesac_params.inlier_threshold = params.inlier_threshold/2;
mlesac_params.error_func = @mlesac_error;

plist = [ransac_params msac_params mlesac_params];

%% Call sac with the different parameter settings
% Run sample consensus on the same data multiple times for each parameter
% setting, according to the number of repetitions specified

% number of times to apply the same parameters to the data
repetition_vals = [2, 4, 10, 20, 30, 40, 50]; % change this
% store all experiment results in here
exp_map = containers.Map();
data = {};
count_list = 0;
for cur_params = plist
    count_list = count_list + 1;
    param_map = containers.Map('KeyType', 'uint32', 'ValueType', 'any');
    count = 0;    
    data_add = [];
    for n_reps = repetition_vals
        count = count + 1;
        rep_map = containers.Map();
        
        plane_eqs = zeros(n_reps, 4);

        % keep track of how many samples each fit uses, to average later
        sample_count_sum = 0; 
        
        for i = 1:n_reps
           
            [a,b,c,d,inliers,sample_count] = fit_plane(pts.Location, cur_params);
            plane_eqs(i, :) = [a b c d];
            sample_count_sum = sample_count_sum + sample_count;
        end
        
        % Example of how to add to the map
        avg_iterations = sample_count_sum/n_reps;
        % avg iterations required to reach specified confidence level
        rep_map('avg_iter') = avg_iterations;
        
        % ================ Compute your statistics here ===============
        % mean and variances..
    
        
        data_add = [data_add;mean(plane_eqs);var(plane_eqs)];
        
        
        
        % =============================================================
        param_map(n_reps) = rep_map;
        
    end
    
    
    data{count_list} = data_add;
    exp_map(cur_params.name) = param_map;    
end

%% Unwrap the cell array that was produced

exp_keys = keys(exp_map);
rep_counts = cell2mat(keys(exp_map(exp_keys{1})));

val_map = containers.Map('KeyType', 'char', 'ValueType', 'any');

% We will combine all of the results for a certain value from each parameter
% setting into a single matrix so that it can be used for plotting
for i = 1:exp_map.Count
    % here we are looking a the different parameter settings (e.g ransac)
    cur_param_map = exp_map(exp_keys{i});
    rep_keys = keys(cur_param_map);
    for j=1:cur_param_map.Count
        % here we are looking at the results for different numbers of
        % repetitions
        cur_rep_map = cur_param_map(rep_keys{j});
        val_keys = keys(cur_rep_map);
        for v = 1:cur_rep_map.Count
            % look at the actual values computed
            
            % if the value map doesn't have the key yet, initialise it to
            % an empty matrix
            if ~isKey(val_map, val_keys{v})
                val_map(val_keys{v}) = [];
            end
            % can't operate on matrix when it's in the map?
            val_mat = val_map(val_keys{v});
            op_val = cur_rep_map(val_keys{v});
            % if the value we're looking at is a scalar, we will construct
            % a matrix where each row is made up of the value received,
            % corresponding to a certain number of repetitions, and each
            % column corresponds to a different parameter setting
            %
            % if the value is a vector, the same applies, but each
            % parameter setting will be in a different slice instead of
            % column
            if isscalar(op_val)
                val_mat(j, i) = op_val;    
            else
                val_mat(j, :, i) = op_val;              
            end
            val_map(val_keys{v}) = val_mat;
        end
    end
end

%% Plot the data (example)
% This is an example of how you might display the data. You can use your
% own implementation to do this!

% Use repetition counts as the x-axis, and plot the grouped data in bar
% charts
for k=keys(val_map)
    vals = val_map(k{1});
    % don't show results for 3d matrices
    if ndims(vals) == 2
        figure
        bar(rep_counts, val_map(k{1}))
        legend(exp_keys)
        title(strrep(k{1}, '_', ' ')) % underscores do subscripts in titles
    end
end