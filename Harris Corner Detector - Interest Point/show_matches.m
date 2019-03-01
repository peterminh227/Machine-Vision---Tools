function show_matches(ImgA, ImgB, cornersA, cornersB, matchesAB, colour)

if nargin < 6
    colour = 'random';
end

hold off
[ha,wa] = size(ImgA);
[hb,wb] = size(ImgB);
% if images are  different sizes, need to pad rows so that they can be
% concatenated
if ha < hb
    % need to put more rows into imgA
    ImgA = [ImgA; zeros(size(ImgB,1)-size(ImgA,1), size(ImgA,2))];
elseif hb < ha
    % need to put more rows into imgB
    ImgA = [ImgA; zeros(size(ImgA,1)-size(ImgB,1), size(ImgB,2))];
end
Img = [ImgA, ImgB];
imshow(Img); hold on
scatter(cornersA(:,2)  ,cornersA(:,1), 'xr');
scatter(cornersB(:,2)+wa,cornersB(:,1), 'xr');
nmatches = size(matchesAB, 1);

if strcmp('random', colour)
    colours = cell(nmatches,1);
    c_vals = hsv(nmatches);
    % make the colours used consistent over repeated displays
    sprev = rng();
    rng(10)
    c_vals = c_vals(randperm(nmatches),:);
    rng(sprev) % reset to prevent other rng being affected
    for i=1:nmatches
        colours{i} = c_vals(i,:);
    end
else
    colours = cell(1,1);
    colours{1} = colour;
    colours = repmat(colours, nmatches, 1);
end

for i = 1:size(matchesAB,1)
    y = [cornersA(matchesAB(i,1),1), cornersB(matchesAB(i,2),1)]; 
    x = [cornersA(matchesAB(i,1),2), cornersB(matchesAB(i,2),2)+wa]; 
    h = plot(x,y);
    set(h,'color', colours{i});
end
end