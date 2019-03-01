function show_cloud_with_normals(p, normals, scale, size)

if nargin < 3
    scale = 1;
end

if nargin < 4
    size = 150;
end

figure
pcshow(p, 'MarkerSize', size)
hold on;
quiver3(p.Location(:, 1), p.Location(:, 2), p.Location(:, 3), ...
        normals(:, 1), normals(:,2), normals(:,3), scale);

end

