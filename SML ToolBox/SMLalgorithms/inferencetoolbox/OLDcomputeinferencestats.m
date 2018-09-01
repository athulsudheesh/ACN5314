function [performancehistory,constants] = computeinferencestates(dodisplay,performancehistory,constants)
% USAGE: [performancehistory,constants] = computeinferencestates(dodisplay,performancehistory,constants)


perform = performancehistory;
hessmx = perform.hessmx;
opgmx = perform.opgmx;
covbeta = pinv(hessmx)*opgmx*pinv(hessmx)/nrstim;

if dodisplay,
    disp('Performance Results for Estimating Parameters on this Data Set.');
    disp(['Gradmax = ',num2str(perform.finalgradval),...
        ', Hessian Condition No. = ',num2str(perform.hesscondnum),', OPG Condition No. = ',num2str(perform.opgcondnum)]);
    disp(['Recall = ',num2str(perform.recall*100),'%, Precision = ',num2str(perform.precision*100),'%']);
    disp(['Percent Correct = ',num2str(perform.percentcorrect*100),'%']);
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
        'LogDetAhatinvB = ',num2str(logdetainvb)]);
end;

disp('-------------------------');
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

end

