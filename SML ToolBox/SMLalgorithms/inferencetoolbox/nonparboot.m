function bootdataset = nonparboot(originaldataset)
% USAGE: bootdataset = nonparboot(originaldataset) 
% nonparametric bootstrap data set generator

% originaldataset is n by d matrix with n rows of d-dimensional vectors
[n,d] = size(originaldataset);
selectedrows = randi(n,n,1);
bootdataset = originaldataset(selectedrows,:);

end

