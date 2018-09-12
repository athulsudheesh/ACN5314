function [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)
% USAGE: [gradientvector,gmx] = gradobjfunction(xvector,constants,thedata)

% MODEL CONSTANTS
temperature = constants.model.temperature;
HunitType = constants.model.hunittype; % RMG 9/6/2017
%------------------------------------------------------------------
lambda = constants.model.penaltytermweight; 
elasticweight = constants.model.elasticweightL2percent/100;
%------------------------------------------------------------------
regularizationtype = constants.model.regularizetype; % RMG 9/6/2017
SoftL1Epsilon = constants.model.SoftL1epsilon; % RMG 9/6/2017
SoftL1EpsilonSquared = SoftL1Epsilon*SoftL1Epsilon; % RMG 9/6/2017

nrhidden = constants.model.nrhidden;

% Unpack Event History
eventhistory = thedata.eventhistory;
nrtargets = thedata.nrtargets;
[nrstim,nrvars] = size(eventhistory);

% Get Desired Responses and Input Vectors
desiredresponse = eventhistory(:,(1:nrtargets));
inputvectors = eventhistory(:,(nrtargets+1):nrvars);
[nrstim,inputvectordim] = size(inputvectors);
inputvectorsT = inputvectors';

% Unpack Parameter Vector
zerosxvector = constants.model.connectmask .* xvector;
[wmatrix,vmatrix] = unpackparameters(xvector,constants,thedata);

% Now Compute Responses to Hidden Units (same as "gradobjfunction.m")
inputvectorsT = inputvectors';
netinputmx = wmatrix*inputvectorsT; % rmg 7/29/2016
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

% Compute Error Signal 
desiredresponsesT = desiredresponse';
errorsignalmx = (desiredresponsesT - predictedresponses)/nrtargets;
dphidy = -errorsignalmx;

% % Compute Derivatives wrt V and W matrix (only partially vectorized)
hideye = eye(nrhidden);
dydh = vmatrix(:,1:nrhidden);
switch HunitType, % RMG 9/6/2017
    case 'Softplus',
        dhdpsi = logisticsigmoid( netinputmx / temperature); 
    case 'Sigmoidal',
        dhdpsi = (1/temperature) * hidmx .* (1 - hidmx); 
    case 'Linear',
        dhdpsi = ones(nrhidden,nrstim);
end;

% Compute Regularization Term Derivative
switch regularizationtype,
    case 'None',
        RegularizeDerivative = 0;
    case 'SoftL1',
        RegularizeDerivative = xvector ./ sqrt((xvector .* xvector) + SoftL1EpsilonSquared);
    case 'L2',
        RegularizeDerivative = xvector;
    case 'Elastic',
        RegularizeDerivative = 2* elasticweight * xvector +  (1-elasticweight)* xvector ./ sqrt((xvector .* xvector) + SoftL1EpsilonSquared);
end;

% Compute Gradient
dphidw =  zeros(nrhidden,inputvectordim);
dphidv = zeros(nrtargets,nrhidden+1);
gmx = [];
for i = 1:nrstim,
    dphidvi = dphidy(:,i)*[hidmx(:,i)' 1];
    dphidwi = zeros(nrhidden,inputvectordim);
    inputvectori = inputvectorsT(:,i);
    for j = 1:nrhidden,
        dpsiidwj = hideye(:,j)*inputvectori';
        dhdpsii = diag(dhdpsi(:,i));
        dphidwi(j,:) = dphidy(:,i)'*dydh*dhdpsii*dpsiidwj;
    end;
    dphidwiT = dphidwi'; dphidviT = dphidvi';
    %gradi = [constants.updatemask .* dphidviT(:); constants.updatemask .* dphidwiT(:)];
    gradi = [dphidviT(:); dphidwiT(:)] + lambda * RegularizeDerivative;
    sparsegradi =constants.model.connectmask .* gradi;
    gmx = [gmx sparsegradi];
end;
gradientvectorT = mean(gmx');
gradientvector = gradientvectorT';
end

