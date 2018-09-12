function sazout = computesazwoutputstats(xt,constants,thedata)
% USAGE: sazout = computesazwoutputstats(xt,constants,thedata) 

% Compute Predictions
funkfilename = constants.model.funkfilename;
[finalobjfunctionval,finalpredicterrormx,predictedresponses] = feval(funkfilename,xt, constants,thedata);

% Compute Classification Statistics if Number of Targets = 1
precision = NaN;
recall = NaN;
percentcorrect = NaN;
[samplesize,nrvars] = size(thedata.eventhistory); % rmg 2/6/2018
sazout.samplesize = samplesize; % rmg 2/6/2018
%samplesize = thedata.nrrecords;  % rmg 2/6/2018
sazout.nrtargets = thedata.nrtargets;
nrtargets = thedata.nrtargets;
eventhistory = thedata.eventhistory;
if nrtargets == 1,
    prob1output = predictedresponses;
    thedata.targetvectors = eventhistory(:,(1:nrtargets));
    targets = thedata.targetvectors;

    predictone =(prob1output > 0.5)';
    truepositives = predictone .* targets;
    truenegatives = (1-predictone) .* (1-targets);
    falsepositives = predictone .* (1-targets);
    falsenegatives = (1-predictone) .* targets;
    sumtotal =sum( truepositives) + sum(truenegatives) + ...
        sum(falsepositives) + sum(falsenegatives);
    precision = sum(truepositives)/(sum(predictone) + eps);
    recall = sum(truepositives)/(sum(targets) + eps);
    percentcorrect = (sum(truenegatives) + sum(truepositives))/sumtotal;
end;
sazout.precision = precision;
sazout.recall = recall;
sazout.percentcorrect = percentcorrect;


% Final Objective Function and Gradient Information
gradfilename = constants.model.gradfilename;
[finalgradvector,gmx] = feval(gradfilename,xt, constants,thedata);
gradvalmax = max(abs(finalgradvector));
sazout.gradvector = finalgradvector;
sazout.gradvalmax = gradvalmax;
sazout.insamplerror = finalobjfunctionval;
qdim = length(finalgradvector);
sazout.qdim = qdim;
bhat = (gmx*gmx')/samplesize;
eigbhat =  eig(bhat); % rmg 2/5/2018
maxhesseigbhat = max(eigbhat); % RMG 2/5/2018
minhesseigbhat = min(eigbhat); % RMG 2/5/2018
condnumopg = NaN;
if (minhesseigbhat) > 0,  % RMG 2/5/2018
    condnumopg = abs(maxhesseigbhat/minhesseigbhat);
end;
sazout.bhat = bhat;

% Calculate Hessian if available

%Initialization
maxhesseig = NaN; minhesseig=NaN;
eighessian = NaN; maxhesseig = NaN;
condnumhessian = nan;  detainvb = NaN;
ahat = NaN; ainvb = NaN; binva = NaN; stderrors = NaN;
ainvbeigvals = NaN; traceainvb = NaN;
logdetainvb = NaN; tracebinva = NaN;
traceainvbnorm = NaN; tracebinvanorm = NaN;
logdetainvbnorm = NaN; ccovmx = NaN;
specificationscore.traceainvb = NaN;
specificationscore.tracebinva = NaN;
specificationscore.logdetainvb = NaN;
outofsamplerror = NaN; binvaeigvals = NaN;
hessfilename = constants.model.hessfilename;
hessianexists = exist(hessfilename) > 0;
if hessianexists,
    hessian = feval(hessfilename,xt,constants,thedata);
    badhessian = any(any(isnan(hessian(:)))) | any(any(isinf(hessian(:))));
    if ~badhessian,
        eighessian = eig(hessian);
        maxhesseig = max(eighessian);
        minhesseig = min(eighessian);
        condnumhessian = NaN;
        if minhesseig > 0,  % rmg 2/5/2018
            condnumhessian = abs(maxhesseig/minhesseig); % rmg 2/5/2018
        end;
        ahat = hessian;
        ahatinverse = pinv(ahat);
        ainvb = ahatinverse*bhat;
        ccovmx = (ahatinverse * bhat * ahatinverse)/samplesize;
        stderrors = sqrt(diag(ccovmx));
        binva = bhat*pinv(ahat);
        ainvbeigvals = (eig(ainvb))';
        binvaeigvals = (eig(binva))';
        traceainvb = trace(ainvb);
        detainvb = det(ainvb);
        logdetainvb = log(detainvb);
        tracebinva = trace(binva);
        traceainvbnorm = traceainvb/qdim;
        tracebinvanorm = tracebinva/qdim;
        logdetainvbnorm = logdetainvb/qdim;
        specificationscore.traceainvb = traceainvb;
        specificationscore.tracebinva = tracebinva;
        specificationscore.logdetainvb = logdetainvb;
        outofsamplerror = finalobjfunctionval + traceainvb/samplesize;
    end
end;
sazout.eighession = eighessian;
sazout.maxhesseig = maxhesseig;
sazout.condnumhessian = condnumhessian;
sazout.condnumopg = condnumopg;
sazout.ahat = ahat; sazout.ainvb = ainvb; sazout.binva = binva;
sazout.covmx = ccovmx;
sazout.stderrors = stderrors;
sazout.ainvbeigvals = ainvbeigvals; sazout.binvaeigvals = binvaeigvals;
sazout.traceainvb = traceainvb; sazout.logdetainvb = logdetainvb;
sazout.tracebinva = tracebinva; sazout.traceainvbnorm = traceainvbnorm;
sazout.detainvb = detainvb;
sazout.tracebinvanorm = tracebinvanorm; 
sazout.logdetainvbnorm = logdetainvbnorm;
sazout.specificationscore = specificationscore;
sazout.outofsamplerror = outofsamplerror;
end

