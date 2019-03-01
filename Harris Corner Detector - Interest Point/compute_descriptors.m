%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [interest_points, descriptors] = compute_descriptors(descriptor_func, img, locations, psize)
%  purpose: Calculate the given descriptor on patches of size psize x psize 
%           of the image, centred on the locations provided
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     descriptor_func: Descriptor to compute at each location
%     img:             Input grayscale image, value range: 0-1
%     locations:       locations at which to compute the descriptors (n x 2)
%                      First column is y, second is x.
%     psize:           Scalar value defining the width and height of the
%                      patch around each location to pass to the descriptor
%                      function.
%
%  output   arguments
%     interest_points: k x 2 matrix containing the image coordinates [y,x]
%                     of the corners. Locations too close to the image
%                     boundary to cut out the image patch should not be
%                     included.
%     descriptors:    k x m matrix containing the patch descriptors, where
%                     m is the length of the descriptor returned by
%                     descriptor_func (which may vary).
%                     Each row is a single descriptor.
%                     Descriptors at locations too close to the image 
%                     boundary to cut out the image patch should not be
%                     included. 
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [interest_points, descriptors] = compute_descriptors(descriptor_func, img, locations, psize)
% compute_descriptors(descriptor_func, I, Corners(:,1:2), patch_size);
% You should call descriptor_func(patch) for each valid patch you generate
% from the locations matrix
[r,c] = size(img);
interest_points = [];
descriptors = [];
half_stride = floor(psize / 2.0);
%
[x,y] = meshgrid(1:psize,1:psize);
offsets=sub2ind([r,c],y,x) - sub2ind([r,c], ceil(psize/2), ceil(psize/2));
%
for i = 1: size(locations, 1)
    if (locations(i,1)- half_stride >= 1) ...
            && (locations(i, 1) + half_stride <= r) ...
            && (locations(i,2) - half_stride >= 1) ...
            && (locations(i,2) + half_stride <= c)
        interest_points = [interest_points; locations(i, 1) locations(i, 2)];
            
        j = sub2ind([r,c], locations(i, 1), locations(i, 2));
      
        pixels  = descriptor_func(img(j + offsets));
      
        descriptors = [descriptors; pixels];
    end
end
end