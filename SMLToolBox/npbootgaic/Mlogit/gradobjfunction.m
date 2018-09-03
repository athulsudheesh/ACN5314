function [gradientvector,gmx] = gradobjfunction(thetavector,constants,thedata)
% USAGE: [gradientvector,gmx] = gradobjfunction(thetavector,constants,thedata)

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
%                  this. Use output of "unpackstuff.m" which takes
%                  "constants" as input and generates other variables.
%

% OUTPUT VARIABLES:
%    gmx: this is a matrix with q rows and n columns where
%         each column is the gradient of the objective function
%         for a particular observation.
%    gradientvector: this is a column vector with q elements which
%         is the average of all columns in "gmx".

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

% Compute the gradient matrix "gmx" where the kth column of the gradient
% matrix is the "gradient of the objective function for the "kth"
% observation. Don't forget the "regularization constant"!
% See "objfunction.m" for details of the objective function!

% ESTIMATED AMOUNT OF MATLAB CODE
% I used 1 loop to compute this....probably could do it without any loops.
% It took about 7 lines of MATLAB code including 2 lines for loop statement
%
%------------------Student Response goes here-------------
gmx = [];
for i = 1:nrinputvectors,
    gradmxi = lambda*betamatrix - (desiredresponse(1:nrtargsminus1,i) - probout(1:nrtargsminus1,i))*inputvectors(:,i)';
    gradmxiT = gradmxi';
    gradveci = gradmxiT(:);
    gmx = [gmx gradveci];
end;

% Compute the gradient vector "gradientvector"
% ESTIMATED AMOUNT OF MATLAB CODE: 1 line of MATLAB CODE
%------------------Student Response goes here-------------
gradientvector = (mean(gmx'))';

