%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%  function  [x, y, rotation, scale] = match_to_params(m1, m2)
%  purpose : Compute the position, rotation and scale of an object implied
%  by a matching pair of descriptors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     d1: match parameters from the test image
%     d2: match parameters from the template image
%
%     Note: Match parameters are in the form [x,y,scale, rotation], where x
%     and y are the position at which the descriptor was extracted in that
%     image.
%
%  output   arguments
%     x,y: coordinates of the top left corner of the object in the test
%     image
%     rotation: rotation of the object in the test image in radians,
%     positive being clockwise, and 0 rotation pointing along the x axis
%     scale: scale of the object in the test image relative to the template
%
%   Author: Minh Nhat Vu
%   MatrNr: 11742814
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x, y, scale, rotation] = match_to_params(m1, m2)

x1 = m1(1,:);
y1 = m1(2,:); % --> from test image
s1 = m1(3,:);
o1 = m1(4,:);
%
x2 = m2(1,:);
y2 = m2(2,:); % --> from test image
s2 = m2(3,:);
o2 = m2(4,:);
% from body rotating from to world frame
x = x1 + sum ( [-x2;-y2].* [cos(o1 - o2); -sin(o1 - o2)]).* (s1./s2);
y = y1 + sum ( [-x2;-y2].* [sin(o1 - o2); cos(o1 - o2)]).* (s1./s2);
scale = s1./s2;
rotation = wrapToPi(o1 - o2); % -pi to pi
end