%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function [x,y,s,o] = detectObject(test_image, object_image, frames1, frames2, matches)                                                         
%  purpose :    Detect multiple object instances using the Hough transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     test_image:     Image in which the object should be detected
%     object_image:   Image of object to detect. (Image dimensions might be
%                     useful to set x/y grid size)
%     frames1/2:      4xn matrix containing the geometric properties of the
%                     SIFT descriptors of image1 and image2. 
%                     Row 1: x coordinate
%                     Row 2: y coordinate
%                     Row 3: Scale
%                     Row 4: Orientation
%                     ATTENTION: Because the y-coordinate points down, 
%                     clockwise is the positive angle direction                 
%     matches:        2xm matrix storing the indices of matched descriptors
%                     of image 1 and 2 (each column corresponds to 1 match).
%     
%  output   arguments
%     x, y:           x- and y-coordinate of the top-left corner of the
%                     found object (in image coordinates)
%     s:              Scale of the found object with respect to object image 
%     o:              Orientation of the found object
%                     ATTENTION: Because the y-coordinate points down,
%                     clockwise is the positive angle direction
%     All output arguments should be vectors containing as many elements as
%     detected object instances. Thus, x(1), y(1), s(1) and o(1) contain
%     the configuration of the first detected instance, x(2), y(2), s(2) and 
%     o(2) the second and so on...
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y,s,o] = detect_object(~, object_image, frames1, frames2, matches)
% ~ brainstorming - extract all keypoints
%x1 = frames1(1, matches(1,:));
%y1 = frames1(2, matches(1,:)); % --> from test image
%s1 = frames1(3, matches(1,:));
%o1 = frames1(4, matches(1,:));
%
%x2 = frames2(1, matches(2,:));
%y2 = frames2(2, matches(2,:)); % --> from template image
%s2 = frames2(3, matches(2,:));
%o2 = frames2(4, matches(2,:));
% rotate the unit axis in CW (as positive direction)
%vote_x = x1 + sum ( [-x2;-y2].* [cos(o1 - o2); sin(o1 - o2)]).* (s1./s2);
%vote_y = y1 + sum ( [-x2;-y2].* [-sin(o1 - o2); cos(o1 - o2)]).* (s1./s2);
%vote_s = s1./s2;
%vote_o = wrapToPi(o1 - o2); % -pi - pi
% Move above lines code to match_to_params.m.
% I actually dont understand what is the purpose of match_to_params as 
% described in the instruction, hope that i go to the right direction.
[vote_x, vote_y, vote_s, vote_o] = ...
    match_to_params(frames1(:, matches(1,:)), frames2(:, matches(2,:)));
%
good_params = 1;
if (good_params ==1)
    nbins.x = 300;
    nbins.y = 100;
    nbins.s = 10;
    nbins.o = 5;
else
    nbins.x = 100;
    nbins.y = 50;
    nbins.s = 2;
    nbins.o = 1;
end
% 
bx = addtobins(vote_x, nbins.x);
by = addtobins(vote_y, nbins.y);
bs = addtobins(vote_s, nbins.s);
bo = addtobins(vote_o, nbins.o);
% loops here
x = []; y = []; s = []; o = [];count = []; 

thresh = 1; % trial and error --> automatic choosing this value?, 
% try to use multi-dimentional array.. not yet finished.
%{ 
H = zeros(size(bx,2), size(by,2), size(bs,2), size(bo,2));
% one for loop
for i = 1:size(bx,2)
    H(bx(i),by(i),bs(i),bo(i)) = H(bx(i),by(i),bs(i),bo(i)) + 1;
end
indexes = find(H(:) > thresh);

for i = 1:size(indexes,1)
    [x_ind, y_ind, s_ind, o_ind] = ind2sub(size(H), indexes(i));
    vote_x(x_ind)
    x = [x vote_x(x_ind)];
    y = [y vote_y(y_ind)];
    s = [s vote_s(s_ind)];
    o = [o vote_o(o_ind)];
end
%}
% improve the code below
for ks = 1:nbins.s
    for ko = 1:nbins.o
        for kx = 1:nbins.x
            for ky = 1:nbins.y
                % counting votes at location
                ind = (bs == ks) & (bo == ko) & (bx == kx) & (by == ky);
                if sum(ind) > thresh
                    x(end+1) = median(vote_x(ind));
                    y(end+1) = median(vote_y(ind));
                    s(end+1) = median(vote_s(ind));
                    o(end+1) = median(vote_o(ind));
                    count(end+1) = sum(ind);
                end
            end
        end
    end
end

    % when creating the Hough space matrix from multiple-dimension array 
    % matlab, the size of memory to store the matrix is too large
    % the idea of addtobins: create a 1D matrix, and add the bin location to
    % each correlation matching point. 
    function b = addtobins(x, nb) %
        b = min(max(ceil((x-min(x))/(max(x) - min(x))*nb),1), nb);
    end

% calculate the box-ratio and keep 1, 
[h2, w2] = size(object_image);
w1 = s.*w2;
h1 = w1.* h2./w2;
temp_x = [x;1:size(x,2)]; 
x_clean = [];

while size(temp_x,2) > 0 
    flag_add = 0;
    ind_1 = temp_x(2,1); % index of box 1
    box_1 = [x(ind_1), y(ind_1),w1(ind_1),h1(ind_1)];
    del = [];
    for i=2:size(temp_x,2)
        ind_2 = temp_x(2,i);
        box_2 = [x(ind_2), y(ind_2),w1(ind_2),h1(ind_2)];
        if bboxOverlapRatio(box_1,box_2,'Union') > 0.5
            del = [del, i];
            flag_add = 1;
        end
    end
    if (flag_add ==1)
        % add this value
        
        temp_x(:,del) = []; % delete overlapping
    end
    x_clean = [x_clean temp_x(:,1)];
    temp_x(:,1) = [];
end

x = x(x_clean(2,:));
y = y(x_clean(2,:));
s = s(x_clean(2,:));
o = o(x_clean(2,:));
end