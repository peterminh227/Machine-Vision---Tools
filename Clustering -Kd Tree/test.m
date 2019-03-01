% test here
load fisheriris
rng(1); % For reproducibility
n = size(meas,1);
idx = randsample(n,5)

X = meas(~ismember(1:n,idx),3:4) % Training data
MdlKDT = KDTreeSearcher(X)

Y = meas(idx,3:4)             % Query data
r = 0.15; % Search radius

IdxKDT = rangesearch(MdlKDT,Y,r)
