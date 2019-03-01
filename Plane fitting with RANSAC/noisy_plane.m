function pts = noisy_plane(a, b, c, d, npoints, spread_x, spread_y, spread_z, sigma, gauss_prop)
% a, b, c, d: plane coefficients
% npoints: number of points to generate
% spread_x: the range of x values for the generated points
% spread_y: the range of y values for the generated points
% spread_z: z values are initially generated so that all points lie on the
% plane. The spread defines the range of the uniform noise applied along the
% normal vector to (1-gauss_prop) * npoints of the points
% sigma: after initial points are generated, gaussian noise is applied to
% gauss_prop * npoints of the points, with a variance of sigma
% gauss_prop: proportion of the points to apply gaussian noise to
normal = [a b c]';

% x and y randomly distributed in the given range, compute z from those
% values
x = (rand(1, npoints) - 0.5) * 2 * spread_x;
y = (rand(1, npoints) - 0.5) * 2 * spread_y;
z = plane_z_from_xy(x, y, a, b, c, d);
pts = [x; y; z];

% create noise to add to each point, applied along the normal of the plane
% apply uniform noise to shake up some of the points a little bit, within a
% smaller range, then apply gaussian noise to some others to create more
% outliers
n_uniform_pts = ceil((1-gauss_prop) * npoints);
n_norm_pts = npoints - n_uniform_pts;
% select which points will have uniform noise applied
uniform_pt_inds = zeros(size(x));
perm = randperm(npoints);
uniform_pt_inds(perm(1:n_uniform_pts)) = 1;
uniform_pt_inds = logical(uniform_pt_inds);

% generate uniform and gaussian values for 
uniform_rands = repmat((rand(1, n_uniform_pts) - 0.5) * spread_z, 3, 1);
norm_rands = repmat(randn(1, n_norm_pts) * sigma, 3, 1);
norm_rep_uniform = repmat(normal, 1, n_uniform_pts);
norm_rep_norm = repmat(normal, 1, n_norm_pts);

pts(:, uniform_pt_inds) = pts(:, uniform_pt_inds) + uniform_rands .* norm_rep_uniform;
pts(:, ~uniform_pt_inds) = pts(:, ~uniform_pt_inds) + norm_rands .* norm_rep_norm;
end