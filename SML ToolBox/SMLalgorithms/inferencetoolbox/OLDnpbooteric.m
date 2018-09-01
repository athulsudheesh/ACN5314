function npbooteric(initialstatemx,nrbootstraps,constants,thedata)
% USAGE: npbooteric(initialstatemx,nrbootstraps,constants,thedata)

originaldataset = thedata.eventhistory;
[samplesize,nrvars] = size(originaldataset);
nrtargets = thedata.nrtargets;
gradmaxcritical = 1e-4;
maxcondnum = 1e+15;

% Compute Training Error and Original GAIC on original training data
initialparameters = initialstatemx(:);
[trainparameters,performancehistory0] = sazwdescent(thedata,initialparameters,[],constants);
%[originaltrainerror,errorsignalmx,predictedresponses] = objfunction(trainparameters,constants,thedata);
originaltrainerror = performancehistory0.insamplerror;
originalgaic = performancehistory0.outofsamplerror;
%originalgaic = originaltrainerror + performancehistory0.traceainvb/samplesize;


waithandle = waitbar(0,'Nonparametric Bootstraps in Progress. Please wait...');
testbooterror = []; trainbooterror = []; theoreticalerrorlist = [];
testplotbootdata = []; trainplotbootdata = []; theoreticalbootdata = [];
thetaguess = [];
for bootid = 1:nrbootstraps,
    waitbar(bootid/nrbootstraps,waithandle);
    
    % Generate Non-parametric Bootstrap Sample From Original Data Set
    testbootdataset = nonparboot(originaldataset);
    
    % Evaluate Performance of Estimated Model on the Test Data
    trainbootdataset = nonparboot(originaldataset); % added by RMG 3/26/2018;
    traindata = thedata;
    traindata.eventhistory = trainbootdataset; 
    initialparameters = initialstatemx(:);
    [trainparameters,performancehistory1] = sazwdescent(traindata,initialparameters,[],constants);
    finalgradval = performancehistory1.finalgradval;
    testbootdataset = nonparboot(originaldataset);
    testdata = thedata; 
%     testdata.eventhistory = testbootdataset;
%     [testparameters,performancehistory2] = sazwdescent(testdata,initialparameters,[],constants); %Check that test sample use usable...
%     finalgradval2 = performancehistory2.finalgradval; %Check that test sample use usable...
%     condnum1 = performancehistory1.finalcondnumhessian; condnum2 = performancehistory2.finalcondnumhessian;
    [trainerror,errorsignalmx,predictedresponses] = objfunction(trainparameters,constants,traindata);
    [testerror,errorsignalmx,predictedresponses] = objfunction(trainparameters,constants,testdata);
    trainerror = performancehistory1.insamplerror;
    theoreticalerror = performancehistory1.outofsamplerror;
   % theoreticalerror = trainerror + (performancehistory1.traceainvb/samplesize); 
%     goodgradvals = (finalgradval < gradmaxcritical) & (finalgradval2 < gradmaxcritical);
% %     condnum1
% %     condnum2
%     goodcondnums = (condnum1 < maxcondnum) & (condnum2 < maxcondnum);
%     gooderrors = ~isnan(trainerror) & ~isnan(testerror) & ~isnan(theoreticalerror);
%     if goodgradvals & goodcondnums & gooderrors,
        trainbooterror = [trainbooterror trainerror];
        trainplotbootdata = [trainplotbootdata mean(trainbooterror)];
 
        theoreticalerrorlist = [theoreticalerrorlist theoreticalerror];
        theoreticalbootdata = [theoreticalbootdata mean(theoreticalerrorlist)];
    
        testbooterror  = [testbooterror testerror];
        testplotbootdata = [testplotbootdata mean(testbooterror)];
%     else
%         mess = '';
%         if ~goodgradvals,
%             mess=[mess,'Convergence Failure'];
%             if ~goodcondnums,
%                 mess = [mess,'Not Local Minimizer'];
%                 if ~gooderrors,
%                     mess = [mess,'Bad Errors'];
%                 end;
%             end;
%             mess = ['Bad Bootstra Sample', mess];
%         disp('Bad Bootstrap Sample');
%         end;
%     end;
% trainplotbootdata
% theoreticalbootdata
% testplotbootdata
end;
nrgoodbootstraps = length(trainplotbootdata);
plot(1:nrgoodbootstraps,trainplotbootdata,'k-','LineWidth',2);
hold on;
plot(1:nrgoodbootstraps,theoreticalbootdata,'r-','LineWidth',2);
hold on;
plot(1:nrgoodbootstraps,testplotbootdata,'b-','LineWidth',2);
hold on;

%figure
%title('All Non-Parametric Bootrap Estimators');
% hold off;
% figure;
% nrgoodbootstraps = length(trainbooterror);
originaltrainerrorlist = ones(nrgoodbootstraps,1)*originaltrainerror;
originalgaiclist = ones(nrgoodbootstraps,1)*originalgaic;
plot(1:nrgoodbootstraps,originaltrainerrorlist,'k:','LineWidth',1.5);
hold on;
plot(1:nrgoodbootstraps,originalgaiclist,'r:','LineWidth',1.5);
hold on;

legend('Bootstrap Training Error','Cross-Validation Test Error (Analytic Formula)',...
    'Cross-Validation Test Error (Bootstrap)','Training Error','Cross-Validation Test Error (Analytic Formula)','Location','Best'); 
ylabel('Average Error (Cross-Entropy)');
xlabel('Number of Bootstrap Samples');
title('Empirical Risk Information Criterion Performance');
hold off;

close(waithandle);
save('results.mat');