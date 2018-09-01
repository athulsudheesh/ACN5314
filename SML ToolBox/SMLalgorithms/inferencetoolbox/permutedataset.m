function permuteddataset = permutedataset(originaldataset)
% USAGE: permuteddataset = permutedataset(originaldataset) 
% nonparametric bootstrap data set generator

% originaldataset is n by d matrix with n rows of d-dimensional vectors
[n,d] = size(originaldataset);
rowindices = randperm(n);
permuteddataset = originaldataset(rowindices,:);

end

