function [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)
% USAGE: [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)
[desiredresponse,inputvectors,betamatrix] = unpacklogistic(thetavector,constants,thedata);
lambda = constants.model.penaltytermweight;
[targetdim,nrstim] = size(desiredresponse);
predictedresponses = betamatrix*inputvectors;
prob = logisticsigmoid(predictedresponses);
logprob = mylog(prob);
logmprob = mylog(1-prob);
errorprob = -desiredresponse .* logprob - (1-desiredresponse) .* logmprob;
errorsignalmx = desiredresponse - predictedresponses;
objfunctionval =  sum(sum(errorprob))/nrstim;
objfunctionval = objfunctionval + (lambda/2)*sum(sum(betamatrix .* betamatrix));



