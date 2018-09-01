function [objfunctionval,predicterrormx,predictedresponses] = objfunction(xvector,constants,thedata)
% USAGE: [objfunctionval,predicterrormx,predictedresponses] = objfunction(xvector,constants,thedata)
eventhistory = thedata.eventhistory;
[nrstim,nrvars] = size(eventhistory);
nrtargets = thedata.nrtargets;
targets = (eventhistory(:,(1:nrtargets)))';
inputvectors = (eventhistory(:,(nrtargets+1):nrvars))'; 
weightmatrix = reshape(xvector,nrtargets,length(xvector)/nrtargets);
targettype =constants.model.targettype;
switch targettype,
    case 'Linear',
        predictedresponses = weightmatrix * inputvectors;
        errorvectors = (targets - weightmatrix * inputvectors);
        objfunctionval = sum( sum(errorvectors .* errorvectors))/(nrstim*nrtargets); 
    case 'Logistic',
        prob = logisticsigmoid(weightmatrix*inputvectors);
        predictedresponses = prob;
        errorvectors = -( targets .* mylog(prob) + (1-targets) .* mylog(1-prob));
        objfunctionval = sum(sum(errorvectors))/(nrstim*nrtargets);
end;
predicterrormx = errorvectors;
objfunctionval = objfunctionval + (constants.model.penaltytermweight/2) * sum(xvector .* xvector);

