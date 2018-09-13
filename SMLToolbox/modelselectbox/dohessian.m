function hessmx = dohessian(betavector,data);
% USAGE: hessmx = dohessian(betavector,data);

[nrstim,nrvars] = size(data);
inputvectors = data(:,2:nrvars); 
prob = logisticsigmoid((betavector' * inputvectors'));
diagprob = diag( prob .* (ones(1,nrstim) - prob));
hessmx = (1/nrstim)*inputvectors'*diagprob*inputvectors;