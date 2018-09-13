function [modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betavector,perform,covbeta] = estimatebeta(data,testdata);
% USAGE: [modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betavector,perform,covbeta] = estimatebeta(data,testdata);

testmodelfits = [];
[n,nrvars] = size(data);
betavector = zeros(nrvars-1,1);
stepsize = 1; iteration = 0;
keepgoing = 1; gradcritical = 1e-6; maxiterations = 100;
maxcondnum = 1e+10;
inputvectors = data(:,2:nrvars);
[gradavg,gradmx] = dogradient(betavector,data);
theerrorval = geterror(betavector,data);
hessmx = dohessian(betavector,data);
while keepgoing,
    iteration  = iteration + 1;
    invhessmx = pinv(hessmx);
    betavector = betavector - stepsize*invhessmx*gradavg;
    [gradavg,gradmx] = dogradient(betavector,data);
    [theerrorval,perform] = geterror(betavector,data);
    hessmx = dohessian (betavector,data);
    thegradmax = max(abs(gradavg));
    gradval(iteration) = thegradmax;
    errorval(iteration) = theerrorval;
    keepgoing = (iteration <= maxiterations) & (thegradmax > gradcritical);
end;

if ~isempty(testdata),
    % Compute Error, GRAD, and Hessian with respect to TEST DATA
    % but using current parameter values. (added 8/4/2015)
    [testerror,perform] = geterror(betavector,testdata);
    [testgradavg,testgradmx] = dogradient(betavector,testdata);
    testhessmx = dohessian(betavector,testdata);
end;

% Compute final conditionnumber, gradval, and error
finalcondnum = cond(hessmx);
finalgradval = thegradmax;
finalerror = theerrorval;
strictlocalmin = (finalgradval <= gradcritical) & (finalcondnum < maxcondnum);

% Compute Covariance Matrix
opgmx = gradmx*gradmx'/n; % RMG 2/6/2018
opgmxcondnum = cond(opgmx); % August 7 2015
covbeta = pinv(hessmx)*opgmx*pinv(hessmx)/n; % Estimate Covariance Matrix of parameter estimates 5/31/2015 10am

% Compute Model Fits
modelfits = []; testmodelfits = [];
if strictlocalmin,
    modelfits = computemodelfits(finalerror,hessmx,gradmx,n);
    if ~isempty(testdata),
        testmodelfits = computemodelfits(testerror,testhessmx,testgradmx,n);
    end;
end;


    
    




