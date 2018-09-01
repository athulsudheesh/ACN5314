function [gradaverage,gradientmatrix] = dogradient(betavector,data)
% USAGE: [gradientvector,gradientmatrix] = dogradient(betavector,data)
[nrrecords,nrvars] = size(data);
targ = data(:,1);
inputvectors = data(:,2:nrvars);
prob = logisticsigmoid(betavector'*inputvectors');
errorsignal = -(targ' - prob); 
errorsignalmx = errorsignal'*ones(1,nrvars-1);
gradientmatrixT = errorsignalmx .* inputvectors; % RMG 2/6/2018
gradientmatrix = gradientmatrixT'; % RMG 2/6/2018
gradaverage = (mean(gradientmatrixT))'; % RMG 2/6/2018
