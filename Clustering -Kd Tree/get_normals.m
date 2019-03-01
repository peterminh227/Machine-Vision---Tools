function normals = get_normals(p, neighbours, viewpoint)

if nargin < 2
    normals = pcnormals(p);
else
    normals = pcnormals(p, neighbours);
end

if nargin < 3
    viewpoint = [0,0,0];
end

% Adapted from https://uk.mathworks.com/help/vision/ref/pcnormals.html?s_tid=doc_ta
for k = 1:p.Count
   p1 = viewpoint - p.Location(k,:);
   p2 = normals(k,:);
   % Flip the normal vector if it is not pointing towards the sensor.
   angle = atan2(norm(cross(p1,p2)),p1*p2');
   if angle > pi/2 || angle < -pi/2
       normals(k, :) = -normals(k,:);
   end
end

end

