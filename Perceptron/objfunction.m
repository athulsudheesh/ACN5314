function [objfunctionval,errorsignalmxdisplay,predictedresponses] = objfunction(xvector,constants,thedata)
% USAGE: [objfunctionval,errorsignalmxdisplay,predictedresponses] = objfunction(xvector,constants,thedata)

% MODEL CONSTANTS (same as "gradobjfunction.m")
nrhidden = constants.model.nrhidden;
temperature = constants.model.temperature;
HunitType = constants.model.hunittype; % RMG 9/6/2017
regularizationtype = constants.model.regularizetype; % RMG 9/6/2017
SoftL1Epsilon = constants.model.SoftL1epsilon; % RMG 9/6/2017
SoftL1EpsilonSquared = SoftL1Epsilon*SoftL1Epsilon; % RMG 9/6/2017

%---------------------------------------------------------------
lambda = constants.model.penaltytermweight;
elasticweight = constants.model.elasticweightL2percent/100;
%---------------------------------------------------------------

% Unpack Event History (same as "gradobjfunction.m")
eventhistory = thedata.eventhistory;
nrtargets = thedata.nrtargets;
[nrstim,nrvars] = size(eventhistory);

% Get Desired Responses and Input Vectors (same as "gradobjfunction.m")
desiredresponse = eventhistory(:,(1:nrtargets));
inputvectors = eventhistory(:,(nrtargets+1):nrvars);
[nrstim,inputvectordim] = size(inputvectors);

% Unpack parameter values
zerosxvector = constants.model.connectmask .* xvector;
[wmatrix,vmatrix] = unpackparameters(xvector,constants,thedata);

% Now Compute Responses to Hidden Units (same as "gradobjfunction.m")
inputvectorsT = inputvectors';
netinputmx = wmatrix*inputvectorsT;
switch HunitType, % RMG 9/6/2017
    case 'Softplus',
        hidmx = temperature*softplusfunk(wmatrix*inputvectorsT/temperature);
    case 'Sigmoidal',
        hidmx = logisticsigmoid(wmatrix*inputvectorsT/temperature);
    case 'Linear',
        hidmx = wmatrix*inputvectorsT;
end;

% Now compute output unit responses (i.e., predicted responses)
TargetType = constants.model.targettype;
linearresponses = vmatrix * [hidmx; ones(1,nrstim)];
switch TargetType,
    case 'Logistic',
        predictedresponses = logisticsigmoid(linearresponses);    
    case 'Linear',
        predictedresponses = linearresponses;
end;

% Compute Error Signal MX 
desiredresponsesT = desiredresponse';
errorsignalmx = -(desiredresponsesT - predictedresponses)/nrtargets;

% Interpretation Threshold (if absolute prediction error on binary target)
errorsignalmxdisplay = errorsignalmx;

% Compute PHI Objective Function 
targettype = constants.model.targettype;
switch targettype,
    case 'Logistic',
        phimatrix = -desiredresponsesT .* mylog(predictedresponses) - (1-desiredresponsesT) .* mylog(1-predictedresponses);
    case 'Linear',
        phimatrix = (1/2)*(desiredresponsesT - predictedresponses).^2;
end;

% COMPUTE OBJ FUNCTION VALUE
switch regularizationtype,
    case 'None',
        RegularizeTerm = 0;
    case 'SoftL1',
        RegularizeTerm = sum(sqrt((xvector .* xvector) + SoftL1EpsilonSquared));
    case 'L2',
        RegularizeTerm = (1/2)*sum(xvector .* xvector);
    case 'Elastic',
        RegularizeTerm = elasticweight*sum(xvector .* xvector) + ...
            (1-elasticweight) * sum(sqrt((xvector .* xvector) + SoftL1EpsilonSquared));
end;
objfunctionval = lambda*RegularizeTerm + sum(sum(phimatrix))/nrstim;

