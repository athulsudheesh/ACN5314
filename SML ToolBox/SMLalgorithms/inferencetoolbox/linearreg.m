function perform = linearreg(dodisplay,estimationonly,varnames,dataset,constants)
% USAGE: perform = linearreg(dodisplay,estimationonly,varnames,dataset,constants)

NUMZERO = 1e-16;
% Do initial parameter estimation
starttime = tic;

% Do Parameter Estimation
%---- Estimate Model Parameters
[nrstim,nrvars] = size(dataset);
targ = (dataset(:,1))';
inputvectors = (dataset(:,2:nrvars))';
betavector = zeros(nrvars-1,1);
stepsize = 1; iteration = 0;
gradcritical = constants.stoppingcriteria.gradmax;
maxiterations = constants.stoppingcriteria.maxiterations;
maxcondnum = constants.inference.maxcondnum;
keepgoing = 1; 
while keepgoing,
    iteration  = iteration + 1;
    
    % Compute Response 
    ypredicted = betavector'*inputvectors;
    
    % Compute Gradient Vector
    errorsignal = -(targ - ypredicted);  % this is a row vector
    errorsignalmx = ones(nrvars-1,1)*errorsignal;
    gradmx = errorsignalmx .* inputvectors;
    gradaverage = (mean(gradmx'))';
    
    % Check stopping Criteria
    thegradmax = max(abs(gradaverage));
    keepgoing = (iteration <= maxiterations) & (thegradmax > gradcritical);
    
    % Compute Hessian
    hessmx = (1/nrstim)*inputvectors*inputvectors';
    invhessmx = pinv(hessmx);
    
    % Update Using Modified Newton if keepgoing
    if keepgoing,
        betavector = betavector - stepsize*invhessmx*gradaverage;
    end; 
    
    % Compute Error at each iteration and display estimation status
    if dodisplay,
        %errorsignals = -(   targ .* mylog(prob) + ((1-targ) .* mylog(1 - prob))  );
        errorsignals = (   targ - ypredicted) .* (targ - ypredicted);
        theerror = mean(errorsignals);
        disp(['Iteration #',num2str(iteration),', Error = ',num2str(theerror),', grad-norm = ',num2str(thegradmax)]);
    end;
end;

% Compute Final Error and Load Basic Statistics
%errorsignals = -(   targ .* mylog(prob) + ((1-targ) .* mylog(1 - prob))  );
errorsignals = (   targ - ypredicted) .* (targ - ypredicted);
finalerror = mean(errorsignals);
perform.finalerror = finalerror;
% perform.prob = prob;
perform.hessmx = hessmx;
perform.gradaverage = gradaverage;
perform.betavector = betavector;

if ~estimationonly,
    % Compute final conditionnumber, gradval, and error
    hesscondnum = cond(hessmx);
    finalgradval = thegradmax;
    strictlocalmin = (finalgradval <= gradcritical) & (hesscondnum < maxcondnum);

    % Compute Covariance Matrix
    opgmx = gradmx*gradmx'/nrstim;
    opgcondnum = cond(opgmx); % August 7 2015
    covbeta = pinv(hessmx)*opgmx*pinv(hessmx)/nrstim; % Estimate Covariance Matrix of parameter estimates 5/31/2015 10am

    % Compute Model Fits
    modelfits = []; 
    if strictlocalmin,
        modelfits = computemodelfits(finalerror,hessmx,gradmx,nrstim);
    end;
    perform.modelfits = modelfits;

    % Compute Specification Score
    logdetopgmx = log(det(hessmx));
    logdethessmx = log(det(opgmx));
    imscore = 100*(logdetopgmx-logdethessmx)/logdethessmx;

    % Load Performance Statistics
    perform.finalgradval = finalgradval;
    perform.hesscondnum = hesscondnum;
    perform.opgcondnum = opgcondnum;
    perform.imscore = imscore;
%     predictone =(prob > 0.5);
%     truepositives = predictone .* targ;
%     truenegatives = (1-predictone) .* (1-targ);
%     perform.precision = sum(truepositives)/(sum(predictone) + eps);
%     perform.recall = sum(truepositives)/(sum(targ) + eps);
%     perform.percentcorrect = mean(truepositives + truenegatives);
    
    if dodisplay,
        disp('Performance Results for Estimating Parameters on this Data Set.');
        disp(['Gradmax = ',num2str(finalgradval),', Hessian Condition No. = ',num2str(hesscondnum),', OPG Condition No. = ',num2str(opgcondnum)]);
%         disp(['Recall = ',num2str(perform.recall*100),'%, Precision = ',num2str(perform.precision*100),'%']);
%         disp(['Percent Correct = ',num2str(perform.percentcorrect*100),'%']);
        disp(' ');
        disp(['Model Fit: Error = ',num2str(modelfits.nnll),', ',...
              'GAIC = ',num2str(modelfits.gaic),', ',...
               'BIC = ',num2str(modelfits.bic)]);
        traceAhatinvBhat = modelfits.gimt.traceainvb;
        traceBhatinvAhat = modelfits.gimt.tracebinva;
        logdetainvb = modelfits.gimt.logdetainvb;
        disp(['IM Scores: ',...
            'TraceAinvB = ',num2str(traceAhatinvBhat),', ',...
            'TraceBinvA = ',num2str(traceBhatinvAhat),', ',...
            'DetAhatinvB = ',num2str(exp(logdetainvb))]);
    end;

    % Load Beta Weights and Beta Weight Standard Errors and P-values
    nrbetas = length(covbeta);
    pvalues = [];
    for betaindex= 1:nrbetas,
        betalabel = varnames{betaindex+1};
        perform.beta(betaindex).label = betalabel;
        perform.beta(betaindex).beta = (betavector(betaindex))';
        stderror = sqrt(covbeta(betaindex,betaindex));
        perform.beta(betaindex).stderror = stderror;
        betazscore = betavector(betaindex)/(stderror + eps);
        perform.beta(betaindex).zscore = betazscore;
        thepvalue = 1 - gammainc((betazscore)^2/2,1/2); %2-sided confidence interval
        perform.beta(betaindex).pvalue = thepvalue;
        pvalues = [pvalues thepvalue];
        if dodisplay,
            disp([betalabel,' Beta = ',num2str(betavector(betaindex)),', Z=',num2str(betazscore),', p=',num2str(thepvalue)]);
        end;
    end;
end;
finaltime = toc(starttime);
perform.finaltime = finaltime;
if dodisplay,
    disp(['Linear Regression: Computation Time: ',num2str(finaltime),' seconds.']);
end;

