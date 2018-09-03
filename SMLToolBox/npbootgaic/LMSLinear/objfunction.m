function [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)
% USAGE: [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)
[desiredresponse,inputvectors,betamatrix] = unpacklms(thetavector,constants,thedata);
lambda = constants.model.penaltytermweight;
[targetdim,nrstim] = size(desiredresponse);
predictedresponses = betamatrix*inputvectors;
errorsignalmx = desiredresponse - predictedresponses;
objfunctionval =  (1/2)*sum(sum(errorsignalmx .* errorsignalmx))/nrstim;
objfunctionval = objfunctionval + (lambda/2)*sum(sum(betamatrix .* betamatrix));



