function [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)
% USAGE: [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)
[desiredresponse,inputvectors,betamatrix] = unpacklms(xvector,constants,thedata);
[targetdim,nrstim] = size(desiredresponse);
lambda = constants.model.penaltytermweight;
errorsignal = -(desiredresponse - betamatrix * inputvectors);
gmx = [];
for i = 1:nrstim,
    gradmatrixi = lambda*betamatrix + errorsignal(:,i)*inputvectors(:,i)';
    gradmatrixiT = gradmatrixi';
    gradveci = gradmatrixiT(:);
    gmx = [gmx gradveci];
end;
gradientvector = (mean(gmx'))';
end

