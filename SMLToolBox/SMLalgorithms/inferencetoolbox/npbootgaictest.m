function npbootgaictest(initialstatemx,nrbootstraps,constants,thedata)
% USAGE: npbootgaictest(initialstatemx,nrbootstraps,constants,thedata)

originaldataset = thedata.eventhistory;
[samplesize,nrvars] = size(originaldataset);
nrtargets = thedata.nrtargets;
gradmaxcritical = 1e-4;
maxcondnum = 1e+15;

% Compute Training Error and Original GAIC on original training data
initialparameters = initialstatemx(:);
[trainparameters,performancehistory0] = sazwdescent(thedata,initialparameters,[],constants);
originaltrainerror = performancehistory0.insamplerror;
originalgaic = performancehistory0.outofsamplerror;
avgtheoreticalstderror = mean(performancehistory0.stderrors);

waithandle = waitbar(0,'Nonparametric Bootstraps in Progress. Please wait...');
testerrorlist = []; trainerrorlist = []; gaicerrorlist = [];
plottesterrorlist = []; plottrainerrorlist = []; plotgaicerrorlist = [];
thetaguess = []; parameterboothistory = []; avgbootstrapstderror = [];
for bootid = 1:nrbootstraps,
    waitbar(bootid/nrbootstraps,waithandle);
    
    % Generate Non-parametric Bootstrap Sample From Original Data Set
    % corresponding to a "training data sample"
    newtrainbootdataset = nonparboot(originaldataset);
    newtraindata = thedata;
    newtraindata.eventhistory = newtrainbootdataset;
    [newtrainparameters,performancehistory0] = sazwdescent(newtraindata,trainparameters,[],constants);
    parameterboothistory = [parameterboothistory; (newtrainparameters(:))'];
    if bootid > 1
        avgbootstrapstderror = [avgbootstrapstderror; mean(std(parameterboothistory))];
    end;
    
    % Evaluate Performance of Estimated Model on the Simulated Training Data using
    % in-sample Estimator
    trainerror = performancehistory0.insamplerror;
    
    % Evaluate Performance of Estimated Model on Simulated Training Data using
    % Out-of-Sample Estimator
    gaicerror = performancehistory0.outofsamplerror;
    
%     % Evaluate Performance of Model Estimated From the Simulated Training Data using
%     % In-Sample Estimator from a new Simulated Test Data batch from original data set.
    testbootdataset = nonparboot(originaldataset);
    testdata = thedata;
    testdata.eventhistory = testbootdataset;
    sazouttest = computesazwoutputstats(newtrainparameters,constants,testdata);
    testerror = sazouttest.insamplerror;
    
   
    
%     % Check if Bootstrap Sample is a Good Sample
%     finalgradval = sazouttest.gradvalmax; 
%     condnumhessian = sazouttest.condnumhessian;
%     goodgradval = (finalgradval < gradmaxcritical);
%     goodcondnum = (condnumhessian < maxcondnum);
%     gooderrors = ~isnan(testerror);
%     if goodgradval & goodcondnum & gooderror,

        trainerrorlist  = [trainerrorlist trainerror];
        plottrainerrorlist = [plottrainerrorlist mean(trainerrorlist)];
        
        gaicerrorlist = [gaicerrorlist gaicerror];
        plotgaicerrorlist = [plotgaicerrorlist mean(gaicerrorlist)];

        testerrorlist  = [testerrorlist testerror];
        plottesterrorlist = [plottesterrorlist mean(testerrorlist)];
        
      
%     else
%         mess = '';
%         if ~goodgradval,
%             mess=[mess,'Convergence Failure'];
%             if ~goodcondnum,
%                 mess = [mess,'Not Local Minimizer'];
%                 if ~gooderrors,
%                     mess = [mess,'Bad Errors'];
%                 end;
%             end;
%             mess = ['Bad Bootstrap Sample', mess];
%         disp('Bad Bootstrap Sample');
%         end;
%     end;
end;
nrgoodbootstraps = length(plotgaicerrorlist);
plot(1:nrgoodbootstraps,plotgaicerrorlist,'m-','LineWidth',1.5);
hold on;
plot(1:nrgoodbootstraps,plottesterrorlist,'b-','LineWidth',1.5);
hold on;
plot(1:nrgoodbootstraps,plottrainerrorlist,'y-','LineWidth',1.5);
hold on;
originaltrainerrorlist = ones(nrgoodbootstraps,1)*originaltrainerror;
originalgaiclist = ones(nrgoodbootstraps,1)*originalgaic;
plot(1:nrgoodbootstraps,originaltrainerrorlist,'k:','LineWidth',1.5);
hold on;
plot(1:nrgoodbootstraps,originalgaiclist,'r:','LineWidth',1.5);
hold on;

legend('Bootstrap GAIC Error',...
    'Bootstrap Test Error','Bootstrap Train Error','Train Error','GAIC Error','Location','Best'); 
ylabel('Average Error (Cross-Entropy)');
xlabel('Number of Bootstrap Samples');
title('Empirical Risk Information Criterion Performance');
hold off;

close(waithandle);
save('results.mat');

figure;
stdnrboots = length(avgbootstrapstderror);
plot(2:stdnrboots+1,ones(stdnrboots,1)*(avgtheoreticalstderror(:))','k:','LineWidth',1.5);
hold on
plot(2:stdnrboots+1,avgbootstrapstderror,'LineWidth',1.5);
ylabel('Average Standard Error');
xlabel('Number of Bootstrap Samples');
title('Bootstrap Versus Analytic Formula Standard Error');
% avgbootstrapstderror
% avgtheoreticalstderror

disp('try comparing to bootstrap training error...and bootstrap test error...');
