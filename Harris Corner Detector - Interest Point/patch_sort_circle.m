%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  desc = patch_sort_circle(patch)
%  purpose : Compute sorted normalised pixel intensity descriptor in a
%            circular region of the patch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     patch: Patch from a grayscale image (n x n)
%
%  output   arguments
%     desc: image patch intensities from the pixels inside a circle at the
%           centre of the patch concatenated into normalised, sorted
%           vector. Size will vary depending on patch size.
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function desc = patch_sort_circle(patch)

% Use circle_mask here
dsize =  size(patch,1);% diagonal size
patch = circle_mask(dsize)* patch;
patch = patch_sort(patch);

desc = sort(patch);
%
end