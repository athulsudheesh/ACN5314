function hessmx = hessobjfunction(xvector,constants,thedata)
% USAGE: hessmx = hessobjfunction(xvector,constants,thedata)

eventhistory = thedata.eventhistory;
[nrstim,nrvars] = size(eventhistory);
nrtargets = thedata.nrtargets;
targets = (eventhistory(:,(1:nrtargets)))';
inputvectors = (eventhistory(:,(nrtargets+1):nrvars))'; 
weightmatrix = reshape(xvector,nrtargets,length(xvector)/nrtargets);
targettype = constants.model.targettype;
switch targettype,
    case 'Linear',
        littlehessmx = 2*inputvectors*inputvectors'/(nrstim*nrtargets);
        hessmx = kron(eye(nrtargets),littlehessmx);
    case 'Logistic',
        prob = logisticsigmoid(weightmatrix*inputvectors);
        dprob = prob .* (1 - prob);
        hessmx = zeros(nrtargets*(nrvars - nrtargets));
        for i = 1:nrstim,
            hessmxi = kron(diag(dprob(:,i)),inputvectors(:,i)*inputvectors(:,i)');
            hessmx = hessmxi + hessmx;
        end;
        hessmx = hessmx / (nrstim*nrtargets);
end;
qdim = length(hessmx);
hessmx = hessmx + eye(qdim)*constants.model.penaltytermweight;




