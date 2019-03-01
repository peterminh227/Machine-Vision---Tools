function p2D = project_3D(p,params)
% u = fx*x/z + cx
% v = fy*y/z + cy
% pos = params.R*p + params.t;
p2D = ...
    ([params.fx_rgb; params.fy_rgb] .* (p(1:2,:)./p(3,:)) + ...
    [params.cx_rgb; params.cy_rgb]);
end