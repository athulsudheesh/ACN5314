function hessianmx = hessobjfunction(thetavector,constants,thedata)
% USAGE: hessianmx = hessobjfunction(thetavector,constants,thedata)

% NOTATION:
% Let c = the number of elements in the desired response vector.
% Let d = the number of elements in the input pattern vector.
% An "observation" is an ordered pair of a desired response vector and an
% input pattern vector.
% Let n = the number of observations. It is the number of training records.
% Let q = (c-1)d is the dimensionality of the parameter vector "theta".

% NOTE: Please see routine "unpackstuff.m" for more information
% about input variable structure.

% INPUT VARIABLES:
%     thetavector: this is "theta" which contains the parameters of the
%                  learning machine "packed up" as a vector. Don't use
%                  this. Use "betamatrix" generated from "unpackstuff.m"
%
%     constants:   this contains a lot of constants including the 
%                  training data packed up into a structure. don't use
%                  this. Use output of "unpackstuff.m".
%

% OUTPUT VARIABLES:
%    Hessian Matrix: this is a matrix with q rows and q columns
%                  which is the second derivative of the Objective
%                  Function

% Unpack stuff. "thetavector" contains "betamatrix". Constants contains
% Desiredresponse and inputvectors. See "unpackstuff.m" for dimensions of
% variables and definitions.
[desiredresponse,inputvectors,betamatrix] = unpackstuff(thetavector,constants,thedata);
[inputvectordim,nrinputvectors] = size(inputvectors);
lambda = constants.model.penaltytermweight;

% Compute probout and extract "inputvectors" and "desiredresponse"
% from "constants". Extract "betamatrix" from "xvector.
probout = computeprob(betamatrix,inputvectors);
[nrtargets,nrinputvectors] = size(probout);
nrtargsminus1 = nrtargets - 1;
qdim = nrtargsminus1 * inputvectordim;

% compute the Hessian matrix. 
% I used 1 loop to compute this (10 lines of MATLAB code)
% with 2 statements devoted to defining the for loop.
%------------------Student Response goes here-------------
hessianmx = lambda*eye(qdim); % start with the normalization constant
for i = 1:nrinputvectors,
    si = inputvectors(:,i);
    pi = probout(:,i);
    dpi = diag(pi) - pi*pi';
    dpireduced = dpi(1:nrtargsminus1,1:nrtargsminus1);
    inputcorr = si*si';
    hi = kron(dpireduced,inputcorr);
    hessianmx = hessianmx + (1/nrinputvectors)*hi;
end;

