function [desiredresponse,inputvectors,betamatrix] = unpacklms(thetavector,constants,thedata)
% USAGE: [desiredresponse,inputvectors,betamatrix] = unpacklms(thetavector,constants,thedata)
eventhistory = thedata.eventhistory;
nrtargets = thedata.nrtargets;
[nrstim,nrvars] = size(eventhistory);
desiredresponse = (eventhistory(:,(1:nrtargets)))';
inputvectors = (eventhistory(:,(nrtargets+1):nrvars))'; 
betamatrix = (reshape(thetavector,length(thetavector)/nrtargets,nrtargets))';
end

