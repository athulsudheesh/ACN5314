function reportresults(reporttitle,performancehistory,constants)
%USAGE: reportresults(reporttitle,performancehistory,constants)

% Compute Percentage Correct Classifications
interpretationthreshold = constants.interpretationthreshold;
errormatrix = abs(performancehistory.predicterrormx) < interpretationthreshold;
[nrtargets,nrevents] = size(errormatrix);
percentcorrectclassifications = mean( mean(errormatrix))*100;
paramdim = length(constants.initialstate);
traceainvb = performancehistory.traceainvb
logdetainvb = performancehistory.logdetainvb
mess0 = reporttitle;
mess1 = ['(Interpretation Threshold = ',num2str(interpretationthreshold),')'];
mess2 = ['Iterations = ',num2str(performancehistory.numberiterations)];
mess3 = ['Grad Infinity Norm = ',num2str(performancehistory.finalgradval),', ',...
         'Condition Number = ',num2str(performancehistory.finalcondnumhessian)];
mess4 = ['Objective Function Value = ',num2str(performancehistory.finalobjfunctionval),', ', ...
         'Correct Percentage Classifications = ',num2str(percentcorrectclassifications),'%'];
overfitobjval = performancehistory.finalobjfunctionval + performancehistory.traceainvb/nrevents;
mess5 = ['Overfit-Corrected Objective Function Value = ',num2str(overfitobjval)];
v = (traceainvb - paramdim)^2 + (logdetainvb)^2;
IMGOF = exp(-v);
mess6 = ['Information Matrix Goodness-of-Fit = ',num2str(IMGOF),' (0=poor fit, 1=good fit)'];
disp(strvcat(mess0,mess1,mess2,mess3,mess4,mess5,mess6));
waithandle = msgbox(strvcat(mess0,mess1,mess2,mess3,mess4,mess5,mess6));
waitfor(waithandle);

end

