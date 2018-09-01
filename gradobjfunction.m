function [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)
% USAGE: [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)
eventhistory = thedata.eventhistory;
[nrstim,nrvars] = size(eventhistory);
nrtargets = thedata.nrtargets;
targets = (eventhistory(:,(1:nrtargets)))';
inputvectors = (eventhistory(:,(nrtargets+1):nrvars))'; 
weightmatrix = reshape(xvector,nrtargets,length(xvector)/nrtargets);
targettype =constants.model.targettype;
lambda = constants.model.penaltytermweight;
switch targettype,
    case 'Linear',
        errorvectors = -(2/nrtargets)*(targets - weightmatrix * inputvectors);
    case 'Logistic',
        prob = logisticsigmoid(weightmatrix*inputvectors);
        errorvectors = -(1/nrtargets)*(targets - prob);
end;
gmx = [];
for i = 1:nrstim,
    gradientmatrixi = errorvectors(:,i) * inputvectors(:,i)';
    gradvectori = gradientmatrixi(:) + lambda*xvector;
    gmx = [gmx gradvectori];
end;
gradientvector = mean(gmx')';
end

