function hessianmx = hessobjfunction(thetavector,constants,thedata)
% USAGE: hessianmx = hessobjfunction(thetavector,constants,thedata)
[desiredresponse,inputvectors,betamatrix] = unpacklogistic(thetavector,constants,thedata);
lambda = constants.model.penaltytermweight;
[inputvectordim,nrstim] = size(inputvectors);
[targetdim,nrstim] = size(desiredresponse);
probout = logisticsigmoid(betamatrix * inputvectors);
hessianmx = lambda*eye(targetdim*inputvectordim); % start with the normalization constant
for i = 1:nrstim,
    si = inputvectors(:,i);
    pi = probout(:,i);
    dpi = diag(pi) .* diag(1-pi);
    inputcorr = si*si';
    hi = kron(dpi,inputcorr);
    hessianmx = hessianmx + (1/nrstim)*hi;
end;

