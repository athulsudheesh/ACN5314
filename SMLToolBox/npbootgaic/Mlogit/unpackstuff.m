function [desiredresponse,inputvectors,betamatrix] = unpackstuff(thetavector,constants,thedata)
% USAGE: [desiredresponse,inputvectors,betamatrix] = unpackstuff(thetavector,constants,thedata)
%
% EVENTHISTORY: This is a matrix where each row vector is a 
% "pattern vector" and the number of row vectors is the number of
% "pattern vectors". The learning machine learns the pattern vectors.
% 
% The transpose of a pattern rwo vector has the following format:
% [y,s,1] where y is a k-dimensional row vector which is the "desired
% response". y is a row vector from a k-dimensional identity matrix.
% s is the input pattern vector. The last element is the number "1"
% indicating an "intercept" or "bias". k= is the "number of targets".
eventhistory = thedata.eventhistory;
nrtargets =thedata.nrtargets;
[nrstim,nrvars] = size(eventhistory);
desiredresponse = (eventhistory(:,1:nrtargets))';
inputvectors = (eventhistory(:,(nrtargets+1):nrvars))';
[inputvectordim,nrinputvectors] = size(inputvectors);
[nrtargets,nrinputvectors] = size(desiredresponse);

% The parameters of the learning machine are "unpacked" from the
% vector "xvector"...after unpacking we get a matrix which has
% "nrtargets-1" rows and "inputvectordim" columns.
betamatrix = [];
nrtargetsminus1 = nrtargets - 1;
for i = 1:nrtargetsminus1,
    j = (i-1)*inputvectordim;
    betarowvector = thetavector((j+1):(j+inputvectordim))';
    betamatrix = [betamatrix; betarowvector ];
end;

