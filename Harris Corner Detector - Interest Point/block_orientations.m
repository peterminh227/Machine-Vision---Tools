%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  desc = block_orientations(patch)
%  purpose : Compute orientation-histogram based descriptor from a patch,
%            using blocks to divide the patch into regions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     patch: Patch from a grayscale image (16 x 16)
%
%  output   arguments
%     desc: Orientation histograms from 16 4 x 4 blocks of the patch,
%           concatenated in row major order (1 x 128).
%           Each orientation histogram should consist of 8 bins in the
%           range [-pi, pi], each bin being weighted by the sum of gradient
%           magnitudes of pixel orientations assigned to that bin.
%
%           You can use kron(reshape(1:16, 4, 4)', ones(4)) as a test
%           patch to see if block ordering is correct.
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function desc = block_orientations(patch)
N = 4*ones(1,4);

h_y = fspecial('sobel'); % vertical gradient % horizontal edges
h_x = h_y'; % horizontal gradient % vertical edges
Gy = imfilter(patch,h_y,'replicate');
Gx = imfilter(patch,h_x,'replicate');
gradient = sqrt(Gx.^2 + Gy.^2);    
orientation = atan2(Gy,Gx); 
blocks_mag = mat2cell(gradient,N,N); % blocks{1,1} = 1; blocks{1,2} = 2; ...
blocks_ori = mat2cell(orientation,N,N); % 16 blocks
desc = [];
for i = 1:4
    for j = 1:4
        [~, ~, bin] = histcounts(blocks_ori{i,j},-pi:pi/4.0:pi); % 8 bins
        % create mask
        for index =1:1:8
             temp = blocks_mag{i,j}.*(bin == index);
             desc = [desc sum(temp(:))];
        end
    end
end
end

