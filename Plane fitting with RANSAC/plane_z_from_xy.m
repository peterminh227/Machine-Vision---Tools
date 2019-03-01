function z = plane_z_from_xy(x,y,a,b,c,d)
% Compute plane z values for the given x and y values, with the
% coefficients a b c and d.

z = -(a*x + b*y + d)/c;

end

