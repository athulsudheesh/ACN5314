function reportdata = domodelselection;
% USAGE: reportdata = domodelselection;

disp('Minor tweaks on 2/7/2018 by RMG');


disp('*****************************************************');
disp('**********August 8 (11am) 2015 version of program *******');
disp('Delete LEAST and second LEAST significant predictors to form 2 competing models');
disp('Combine least and 2nd least significant predictors to form an additional interaction for 3rd competing model.');
disp('*****************************************************');


disp('--------------------------------');
disp('Software Update Notes (May 31, 11am)');
disp('added misspecification noise to data generating process near line 72 of this file...');
disp('added control parameter stdnoisevar around lines 16-18 of this file...');
disp(' ');
disp('This program assumes that you have at least 4 predictors not including the intercept...');

disp('-------------------------------------------');

% Addition of Additive Gaussian noise (added May 31, 8am)
stdnoisevar = 0; % this makes program work before the May 31, 8am software update
%stdnoisevar = 1; % this adds misspecification noise so that all models are misspecified.
if stdnoisevar > 0, disp('Adding misspecification noise...'); end;

% Specify Sample Size Percentages
samplesizepercentages = [10 20 30 40 50 60 70 80 90 100];
samplesizepercentages = [20 40 60 80 100];
samplesizedim = length(samplesizepercentages);

% Specify Number of Bootstrap Data Samples
nrbootsets = 100;
disp(['Number of Bootstrap Samples = ',num2str(nrbootsets)]);

% Compute the "true beta vector" first.
% Load the Original Data Set
disp('It is assumed first column is the dependent variable (i.e., the target)');
disp('It is assumed last column is a vector of ones corresponding to intercept..'); % 5/31/2015 10am
[filename, pathname] = uigetfile('*.xls','Pick ORIGINAL Data Set');
[originaldata,originalheader,originalraw] = xlsread(filename);
disp(['Data file "',filename,'" has been read.']);
[n,nrvars] = size(originaldata);
disp ([num2str(n),' records have been read.']);

% Do initial parameter estimation
starttime = tic;
[modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betatrue,perform,covbeta] = estimatebeta(originaldata,[]); % 8/4/2015
finaltime = toc(starttime);
disp('Performance Results for Estimating Parameters on this Data Set.');
disp(['Computation Time: ',num2str(finaltime),' seconds.']);
disp(['Gradmax = ',num2str(finalgradval),', Hessian Condition No. = ',num2str(finalcondnum),', OPG Condition No. = ',num2str(opgmxcondnum)]);
disp(['Recall = ',num2str(perform.recall*100),'%, Precision = ',num2str(perform.precision*100),'%']);
disp(['Percent Correct = ',num2str(perform.percentcorrect*100),'%']);
disp(' ');
disp('******************* Note that model misspecification is indicated if Hessian and OPG Condition Numbers are different!');
disp('******************* Asymptotic Theory requires both Hessian and OPG Condition Numbers to be finite! ****');

disp('this section added 5/31/2015 at 1041am...by rmg'); disp('also modified estimatebeta.m');
nrbetas = length(covbeta);
pvalues = [];
for betaindex= 1:nrbetas,
    betalabel = originalheader{betaindex+1};
    perform.beta(betaindex).label = betalabel;
    perform.beta(betaindex).beta = (betatrue(betaindex))';
    stderror = sqrt(covbeta(betaindex,betaindex));
    perform.beta(betaindex).stderror = stderror;
    betazscore = betatrue(betaindex)/(stderror + eps);
    perform.beta(betaindex).zscore = betazscore;
    thepvalue = 1 - gammainc((betazscore)^2/2,1/2); %2-sided confidence interval
    perform.beta(betaindex).pvalue = thepvalue;
    pvalues = [pvalues thepvalue];
    disp([betalabel,' Beta = ',num2str(betatrue(betaindex)),', Z=',num2str(betazscore),', p=',num2str(thepvalue)]);
end;
pvaluesnointercept = pvalues(1:(nrbetas-1));
[dum,firstminpvalueindex] = min(pvaluesnointercept);
pvalueswithoutbest = pvaluesnointercept;
pvalueswithoutbest(firstminpvalueindex) = 1;
[dum,secondminpvalueindex] = min(pvalueswithoutbest);
[dum,maxpvalueindex] = max(pvaluesnointercept);
pvalueswithoutworst = pvaluesnointercept;
pvalueswithoutworst(maxpvalueindex) = 0; % Bug in software found 8/8/2015
[dum,secondmaxpvalueindex] = max(pvalueswithoutworst);

D1pmax = maxpvalueindex + 1;
D2pmax = secondmaxpvalueindex + 1;
D1pmin = firstminpvalueindex + 1;
D2pmin = secondminpvalueindex + 1;
%disp(['MOST Significant Pvalue: ',originalheader{D1pmin}]);
%disp(['Second Most Significant Pvalue: ',originalheader{D2pmin}]);
disp(['Least Significant Pvalue: ',originalheader{D1pmax}]);
disp(['Second Least Significant Pvalue: ',originalheader{D2pmax}]);
A1index = [D1pmax, D2pmax]; % define the interaction term
keepgoing = input('Type any key to begin simulation study...','s');

datageneratormodel.modelfits = modelfits;
datageneratormodel.finalgradval = finalgradval;
datageneratormodel.finalcondnum = finalcondnum;
datageneratormodel.opgmxcondnum = opgmxcondnum;
datageneratormodel.datafilename = filename;
datageneratormodel.samplesize = n;

datageneratormodel.nrbootsets = nrbootsets;
 
%--------------------------------------------
% Added by RMG 2/9/2018
%


% The total number of simulated data sets is "nrbootsets".
% Start the Simulation
waithandle = waitbar(0,'Please wait...');
for j = 1:samplesizedim,
    waitmessage = ['Sample Size ',num2str(samplesizepercentages(j)),'%'];
    for i = 1:nrbootsets,
        waitbar(i/nrbootsets,waithandle,waitmessage);
        
        % Generate Samplesize of training and test data samples
        samplesize = round(samplesizepercentages(j)*n/100);
        
        % Generate Bootstrap Data Set for Parameter Estimation 8/4/2015
        % Covariates are sampled using non-parametric bootstrap
        % Target is sampled using parametric bootstrap
        selectedrows = randi(n,samplesize,1);
        newbootdata = originaldata(selectedrows,:);
        predictors = newbootdata(:,2:nrvars);
        phi = predictors*betatrue;
        if stdnoisevar > 0, phi = phi + stdnoisevar*randn(samplesize,1);end;
        prob=1 ./(1 + exp(-phi));
        targets = rand(samplesize,1) < prob;
        dataseti = [targets predictors]; %this is used for training data (same format as "original")
        
        % Generate Bootstrap Data Set for Testing 8/4/2015
        % Covariates are sampled using non-parametric bootstrap
        % Target is sampled using parametric bootstrap
        selectedrows = randi(n,samplesize,1);
        newbootdata = originaldata(selectedrows,:);
        predictors = newbootdata(:,2:nrvars);
        phi = predictors*betatrue;
        if stdnoisevar > 0, phi = phi + stdnoisevar*randn(samplesize,1);end;
        prob=1 ./(1 + exp(-phi));
        targets = rand(samplesize,1) < prob;
        testdataseti = [targets predictors]; %this is used for testing data (same format as "original") % RMG 2/7/2018

        % Fit Data to the Model from which it was generated
        [modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betai,Xperform,Xcovbeta] = estimatebeta(dataseti,testdataseti);
        simulation{i,j}.true.modelfits = modelfits;
        simulation{i,j}.true.testmodelfits = testmodelfits; % August 4, 2015
        simulation{i,j}.true.finalgradval = finalgradval;
        simulation{i,j}.true.finalcondnum = finalcondnum;

        % Construct a "DECOY MODEL" which is like correct model
        % but most significant predictor is deleted.
        D1selector = [1:(D1pmax-1),(D1pmax+1):nrvars];
        D1dataseti = dataseti(:,D1selector);
        D1testdatai = testdataseti(:,D1selector); % 8/4/2015
        [modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betaD1i,Xperform,Xcovbeta] = estimatebeta(D1dataseti,D1testdatai); % 8/4/2015
        simulation{i,j}.D1.modelfits = modelfits;
        simulation{i,j}.D1.testmodelfits = testmodelfits; % August 4, 2015
        simulation{i,j}.D1.finalgradval = finalgradval;
        simulation{i,j}.D1.finalcondnum = finalcondnum;

        % Construct a "DECOY MODEL" which is like correct model
        % but second most significant predictor is deleted.
        D2selector = [1:(D2pmax-1),(D2pmax+1):nrvars];
%         D2selector = [];
%         for k = 1:nrvars,
%             if ~ismember(k,D2index),
%                 D2selector = [D2selector k];
%             end;
%         end;
        D2dataseti = dataseti(:,D2selector);
        D2testdataseti = testdataseti(:,D2selector); % 8/4/2015
        [modelfits,testmodelfits,finalgradval,finalcondnum,opgmxcondnum,betaD2i,Xperform,Xcovbeta] = estimatebeta(D2dataseti,D2testdataseti); % 8/4/2015
        simulation{i,j}.D2.modelfits = modelfits;
        simulation{i,j}.D2.testmodelfits = testmodelfits; % 8/4/2015
        simulation{i,j}.D2.finalgradval = finalgradval;
        simulation{i,j}.D2.finalcondnum = finalcondnum;

        % Construct a "DECOY MODEL" which is like correct model
        % but adds 1 predictor which is an interaction term.
        A1selector = [];
        for k = 1:nrvars,
            if ~ismember(k,A1index),
                A1selector = [A1selector k];
            end;
        end;
        newpredictor = dataseti(:,A1index(1,1)) .* dataseti(:,A1index(1,2));
        A1dataseti = [dataseti,newpredictor];
        newpredictortest = testdataseti(:,A1index(1,1)) .* testdataseti(:,A1index(1,2)); % 8/4/2015
        A1testdataseti = [testdataseti,newpredictortest]; % 8/4/2015
        [modelfits,testmodelfits, finalgradval,finalcondnum,opgmxcondnum,betaA1,Xperform,Xcovbeta] = estimatebeta(A1dataseti,A1testdataseti); % 8/4/2015
        simulation{i,j}.A1.modelfits = modelfits;
        simulation{i,j}.A1.testmodelfits = testmodelfits; % 8/4/2015
        simulation{i,j}.A1.finalgradval = finalgradval;
        simulation{i,j}.A1.finalcondnum = finalcondnum;  
    end; % end of for loop for bootset data index
end; % end of for loop for sample size index
close(waithandle);

% Report Results
[trainsimresults,testsimresults] = genresults(samplesizedim,nrbootsets,simulation);

% Print Spreadsheets
printspreadsheet(trainsimresults,['TRAIN',filename],samplesizedim,samplesizepercentages);
printspreadsheet(testsimresults,['TEST',filename],samplesizedim,samplesizepercentages);



    
            
        

