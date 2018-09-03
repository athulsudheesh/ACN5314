function [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)
% USAGE: [objfunctionval,errorsignalmx,predictedresponses] = objfunction(thetavector,constants,thedata)

% Unpack stuff. "thetavector" contains "betamatrix". Constants contains
% Desiredresponse and inputvectors. See "unpackstuff.m" for dimensions of
% variables and definitions.
[desiredresponse,inputvectors,betamatrix] = unpackstuff(thetavector,constants,thedata);
lambda = constants.model.penaltytermweight;

% Compute probout and extract "inputvectors" and "desiredresponse"
% from "constants". Extract "betamatrix" from "xvector.
probout = computeprob(betamatrix,inputvectors);

% Compute Predicted Responses
[nrtargets,inputvectordim] = size(probout);
predictedresponses = ones(nrtargets,1)*max(probout) == probout;

% Compute Error Signal Measures
errorsignalmx = desiredresponse - predictedresponses;

% Compute Objective Function 
%(epsilon inserted so that we don't get infinities)
normbetamx = sum(sum(betamatrix .* betamatrix));
objfunctionval = (lambda/2)*normbetamx -mean(log(eps + sum(desiredresponse .* probout)));


