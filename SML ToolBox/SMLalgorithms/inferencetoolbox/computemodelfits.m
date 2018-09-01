function modelfits = computemodelfits(error,hessmx,gradmx,n)
% USAGE: modelfits = computemodelfits(error,hessmx,gradmx,n)

% Compute Parameter Dimension (q=number of parameters)
q = length(hessmx);

% Compute log n;
logn = log(n);

% Compute Negative Normalized Log-Likelihood
modelfits.nnll = error;

% Compute OPG
Bhat = (1/n)*gradmx'*gradmx;

% Compute Ahat and Ahat inverse
Ahat = hessmx;
Ahatinv = pinv(hessmx);

% Compute AhatinvBhat
AhatinvBhat = Ahatinv*Bhat;

% Compute Akaike Information Criterion (AIC)
modelfits.aic = error + (q/n);

% Compute Generalized Akaike Information Criterion (GAIC) [also TIC]
modelfits.gaic = error + (1/n)*trace(AhatinvBhat);

% Compute BIC/SIC (Bayesian Information Criterion)
modelfits.bic = error + q*(logn)/(2*n);

% Compute GBIC-MAP (see Djuric, 1998) (Standard Laplace approximation)
modelfits.gbicmap = error +(1/(2*n)) * log(det(Ahat)) + (q/(2*n))*log(n/(2*pi));

% Compute GBIC-MML (Richard Golden!!)
modelfits.gbicmml = modelfits.gbicmap + (1/(2*n))*trace(AhatinvBhat);

% Compute GBIC-P
modelfits.gbicp = modelfits.bic + (1/(2*n))*trace(AhatinvBhat) +...
    -(1/(2*n))*log(det(AhatinvBhat));

% Compute GBIC
modelfits.gbic = modelfits.bic  -(1/(2*n))*log(det(AhatinvBhat));

end

