function hessmx = hessobjfunction(thetavector,constants,thedata)
% USAGE: hessmx = hessobjfunction(thetavector,constants,thedata)
[desiredresponse,inputvectors,betamatrix] = unpacklms(thetavector,constants,thedata);
lambda = constants.model.penaltytermweight;
[inputvectordim,nrstim] = size(inputvectors);
[targetdim,nrstim] = size(desiredresponse);
littlehessmx =  lambda*eye(inputvectordim) + (inputvectors*inputvectors')/(nrstim);
hessmx = kron(eye(targetdim),littlehessmx);
    



