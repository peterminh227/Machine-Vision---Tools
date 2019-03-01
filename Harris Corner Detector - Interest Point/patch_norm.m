%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  desc = patch_norm(patch)
%  purpose : Compute normalised pixel intensity descriptor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     patch: Patch from a grayscale image (n x n)
%
%  output   arguments
%     desc: image patch intensities concatenated into normalised vector (1 x n*n)
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function desc = patch_norm(patch)
average = mean(patch(:));
sigma_2 = 1/length(patch(:))*sum(patch(:).^2);
desc = (patch(:)' - average)/ (sigma_2);
%desc = (patch(:)./norm(patch(:)))';
end