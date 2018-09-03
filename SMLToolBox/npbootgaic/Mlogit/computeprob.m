function probout = computeprob(betamatrix,inputvectors)
% USAGE: probout = computeprob(betamatrix,inputvectors)

% NOTATION:
% Let c = number of elements in desired response vector."target dimension"
% Let d = number of elements in input pattern vector. 
% An "observation" is an ordered pair of a desired response vector and an
% input pattern vector.

% NOTE: Please see routine "unpackstuff.m" for more information
% about input variable structure.

% INPUT VARIABLES:
%     betamatrix: real matrix with c-1 rows and d columns
%                 which contains parameters of learning machine.
%
%     inputvectors: real matrix with d rows and n columns

% OUTPUT VARIABLE:
%     probout: probability matrix which has c rows and d columns
%              where all elements are between zero and one.
%              The sum of the elements in each column adds up 
%              exactly equal to one. In particular, the element
%              in row i and column j of "probout" is the estimated
%              probability of outcome i given the jth input vector.

% NOTE: If you want to write the code in a non-vectorized format
% using "loops" for this project that is fine. But the software will
% be "slower" and it might be harder to debug since there will be more
% code.

% Get dimensions of "inputvectors" and "betamatrix"
[inputvectordim,nrinputvectors] = size(inputvectors);
[targdimminus1,inputvectordim] = size(betamatrix);
targetdim = targdimminus1 + 1;

% Compute Linear Response matrix "linearout".
% "linearout" is a matrix consisting of "nrtargets" rows and
% "nrinputvectors" columns. The last row of "linearout" is a row of zeros.
% The jth element of the kth column of "linearout" is equal to
% zero if j = nrtargets. If j is not equal to the number of targets,
% then the jth element of the first column of "linearout" is equal to
% a weighted sum of the elements of the kth column of "inputvectors".
linearout = [betamatrix; zeros(1,inputvectordim)]*inputvectors;

%-------------------------------------------------------------
% Compute Numerically Stable Linear Response matrix "newlinearout".
% The next piece of code is a "trick" which keeps the
% exponential functions from over-saturating...
% Basically suppose we are computing
% P = exp(A)/(exp(A) + exp(B) + exp(C))
% to make this numerically stable we should compute instead
% the following. Let D = max{A,B,C}. THEN:
% P = exp(A-D)/(exp(A-D) + exp(B-D) + exp(C-D))
% this keeps us from a situation where we are computing things
% like: exp(45) which is beyond the machine's precision
% and constrain the inputs to "exp" such that all inputs are less
% than one.
%
% NOTE: the matrix "newlinearout" is the numerically stable version
% of "linearout" which is used instead of "linearout"
maxlinear = max(linearout);
newlinearout = linearout - ones(targetdim,1)*maxlinear;

%--------------------------------------------------------------
% Compute Predicted Probabilities (compute "probout")
% "probout" is a matrix which has "nrtargets" rows
% and the number of columns in "probout" is the number of input vectors.
% Also note that the sum of the elements in each column add up to one.
%
% Using the matrix "newlinearout" compute the outcome probabilities
% returned by this routine. 
%
% ESTIMATED AMOUNT OF MATLAB CODE:
% 2 lines of vectorized MATLAB CODE with no loops and no IF statements
expoutput = exp(newlinearout);
%------------------Student Response goes here-------------
sumexpout = sum(expoutput);
probout = expoutput ./ (ones(targetdim,1)*sumexpout);
%-------------------------------------------------------------

end

