function [gradaverage,gradientmatrix] = dogradient(betavector,data)
% USAGE: [gradientvector,gradientmatrix] = dogradient(betavector,data)
[nrrecords,nrvars] = size(data);
targ = data(:,1);
inputvectors = data(:,2:nrvars);
prob = logisticsig(betavector'*inputvectors');
errorsignal = -(targ' - prob); 
errorsignalmx = errorsignal'*ones(1,nrvars-1);
gradientmatrix = errorsignalmx .* inputvectors;
gradaverage = (mean(gradientmatrix))';