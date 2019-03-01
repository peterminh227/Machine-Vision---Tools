%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  matchesAB = match_descriptors(descriptorsA, descriptorsB)
%  purpose :    Find matches for descriptors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     descriptorsA:   patch descriptors of first image. m x n matrix
%                     containing m descriptors of length n
%     descriptorsB:   patch descriptors of second image. m x n matrix
%                     containing m descriptors of length n
%
%  output   arguments
%     matchesAB:      k x 2 matrix representing the k successful matches.
%                     Each row vector contains the indices of the matched
%                     descriptors of the first and the second image
%                     respectively.
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function matchesAB = match_descriptors(descriptorsA, descriptorsB)

[rA,~] = size(descriptorsA); % k*n^2
matchesAB = [];
for i = 1:rA
    d = vecnorm(descriptorsA(i,:) - descriptorsB,2,2);
    [d_sort, index] = sort(d);
    matchesAB = [matchesAB; i, index(1), d_sort(1)];
end
%
[rowAB, colAB] = size(matchesAB);
r_d = [];

for i = 1: rowAB
    d = [];
    pointer = find(matchesAB(:,2) == matchesAB(i,2));
    d = [d;matchesAB(rowAB * (colAB-1) + pointer),...
        rowAB * (colAB-1) + pointer];
    [d_sort, index] = sort(d(:,1));
    if (size(d) > 1)
        if (d_sort(1)/d_sort(2)) < 0.8 % valid point
            [rd,~] = ind2sub([rowAB, colAB], d(index(2:end),2));% rows to be deleted
            r_d = [r_d;rd];
        else
            % delete all points
            [rd,~] = ind2sub([rowAB, colAB], d(index(:),2));% rows to be deleted
            r_d = [r_d;rd];
        end
    end
end
matchesAB(r_d,:) = [];
matchesAB = matchesAB(:,1:2);
end