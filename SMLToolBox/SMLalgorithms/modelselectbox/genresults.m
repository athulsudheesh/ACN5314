function [trainsimresults,testsimresults] = genresults(samplesizedim,nrbootsets,simulation);
% USAGE: [trainsimresults,testsimresults] = genresults(samplesizedim,nrbootsets,simulation);

% GENERATE SIMULATION RESULTS (training data)
for j = 1:samplesizedim,
    results = zeros(9,4); % RMG 1/30/2016
    for booti = 1:nrbootsets,
        si = simulation{booti,j};
        badsample = isempty(si.A1.modelfits)| isempty(si.D1.modelfits) | ...
             isempty(si.D2.modelfits) | isempty(si.true.modelfits) ;
        %    isempty(si.A2.modelfits);
        if ~badsample,
            NNLfitrowi = [si.true.modelfits.nnll si.D1.modelfits.nnll ...
                 si.D2.modelfits.nnll si.A1.modelfits.nnll ];
            NNLchoice = choosemodel(NNLfitrowi);
            results(1,NNLchoice) = results(1,NNLchoice) + 1;

            AICfitrowi = [si.true.modelfits.aic si.D1.modelfits.aic ...
                 si.D2.modelfits.aic si.A1.modelfits.aic];
            AICchoice = choosemodel(AICfitrowi);
            results(2,AICchoice) = results(2,AICchoice) + 1;

            GAICfitrowi = [si.true.modelfits.gaic si.D1.modelfits.gaic ...
                 si.D2.modelfits.gaic si.A1.modelfits.gaic ];
            GAICchoice = choosemodel(GAICfitrowi);
            results(3,GAICchoice) = results(3,GAICchoice) + 1;

            BICfitrowi = [si.true.modelfits.bic si.D1.modelfits.bic ...
                si.D2.modelfits.bic si.A1.modelfits.bic ];
            BICchoice = choosemodel(BICfitrowi);
            results(4,BICchoice) = results(4,BICchoice) + 1;

            GBICMAPfitrowi = [si.true.modelfits.gbicmap si.D1.modelfits.gbicmap...
                 si.D2.modelfits.gbicmap si.A1.modelfits.gbicmap ];
            GBICMAPchoice = choosemodel(GBICMAPfitrowi);
            results(5,GBICMAPchoice) = results(5,GBICMAPchoice) + 1;

            GBICMMLfitrowi = [si.true.modelfits.gbicmml si.D1.modelfits.gbicmml...
                 si.D2.modelfits.gbicmml si.A1.modelfits.gbicmml ];
            GBICMMLchoice = choosemodel(GBICMMLfitrowi);
            results(6,GBICMMLchoice) = results(6,GBICMMLchoice) + 1;

            GBICPfitrowi = [si.true.modelfits.gbicp si.D1.modelfits.gbicp...
                si.D2.modelfits.gbicp si.A1.modelfits.gbicp ];
            GBICPchoice = choosemodel(GBICPfitrowi);
            results(7,GBICPchoice) = results(7,GBICPchoice) + 1;

            GBICfitrowi = [si.true.modelfits.gbic si.D1.modelfits.gbic...
                si.D2.modelfits.gbic si.A1.modelfits.gbic];
            GBICchoice = choosemodel(GBICfitrowi);
            results(8,GBICchoice) = results(8,GBICchoice) + 1;
            
            % added 1/30/2016
            IMGOFfitrowi = [si.true.modelfits.imgof si.D1.modelfits.imgof...
                si.D2.modelfits.imgof si.A1.modelfits.imgof];
            IMGOFchoice = choosemodel(IMGOFfitrowi);
            results(9,IMGOFchoice) = results(9,IMGOFchoice) + 1;
        end; % end if
    end; % end bootstrap sample index
    trainsimresults{j} = results;
end; % end samplesize index
% ----------------- end of training data simulation results


% GENERATE SIMULATION RESULTS (test data)
for j = 1:samplesizedim,
    results = zeros(9,4);  % added 1/30/2016
    for booti = 1:nrbootsets,
        si = simulation{booti,j};
        badsample = isempty(si.A1.testmodelfits)| isempty(si.D1.testmodelfits) | ...
             isempty(si.D2.testmodelfits) | isempty(si.true.testmodelfits) ;
        %    isempty(si.A2.testmodelfits);
        if ~badsample,
            NNLfitrowi = [si.true.testmodelfits.nnll si.D1.testmodelfits.nnll ...
                 si.D2.testmodelfits.nnll si.A1.testmodelfits.nnll ];
            NNLchoice = choosemodel(NNLfitrowi);
            results(1,NNLchoice) = results(1,NNLchoice) + 1;

            AICfitrowi = [si.true.testmodelfits.aic si.D1.testmodelfits.aic ...
                 si.D2.testmodelfits.aic si.A1.testmodelfits.aic];
            AICchoice = choosemodel(AICfitrowi);
            results(2,AICchoice) = results(2,AICchoice) + 1;

            GAICfitrowi = [si.true.testmodelfits.gaic si.D1.testmodelfits.gaic ...
                 si.D2.testmodelfits.gaic si.A1.testmodelfits.gaic ];
            GAICchoice = choosemodel(GAICfitrowi);
            results(3,GAICchoice) = results(3,GAICchoice) + 1;

            BICfitrowi = [si.true.testmodelfits.bic si.D1.testmodelfits.bic ...
                si.D2.testmodelfits.bic si.A1.testmodelfits.bic ];
            BICchoice = choosemodel(BICfitrowi);
            results(4,BICchoice) = results(4,BICchoice) + 1;

            GBICMAPfitrowi = [si.true.testmodelfits.gbicmap si.D1.testmodelfits.gbicmap...
                 si.D2.testmodelfits.gbicmap si.A1.testmodelfits.gbicmap ];
            GBICMAPchoice = choosemodel(GBICMAPfitrowi);
            results(5,GBICMAPchoice) = results(5,GBICMAPchoice) + 1;

            GBICMMLfitrowi = [si.true.testmodelfits.gbicmml si.D1.testmodelfits.gbicmml...
                 si.D2.testmodelfits.gbicmml si.A1.testmodelfits.gbicmml ];
            GBICMMLchoice = choosemodel(GBICMMLfitrowi);
            results(6,GBICMMLchoice) = results(6,GBICMMLchoice) + 1;

            GBICPfitrowi = [si.true.testmodelfits.gbicp si.D1.testmodelfits.gbicp...
                si.D2.testmodelfits.gbicp si.A1.testmodelfits.gbicp ];
            GBICPchoice = choosemodel(GBICPfitrowi);
            results(7,GBICPchoice) = results(7,GBICPchoice) + 1;

            GBICfitrowi = [si.true.testmodelfits.gbic si.D1.testmodelfits.gbic...
                si.D2.testmodelfits.gbic si.A1.testmodelfits.gbic];
            GBICchoice = choosemodel(GBICfitrowi);
            results(8,GBICchoice) = results(8,GBICchoice) + 1;
            
             % added 1/30/2016
            IMGOFfitrowi = [si.true.testmodelfits.imgof si.D1.testmodelfits.imgof...
                si.D2.testmodelfits.imgof si.A1.testmodelfits.imgof];
            IMGOFchoice = choosemodel(IMGOFfitrowi);
            results(9,IMGOFchoice) = results(9,IMGOFchoice) + 1;
        end; % end if
    end; % end bootstrap sample index
    testsimresults{j} = results;
end; % end samplesize index
% ----------------- end of test data simulation results
gimtresults(simulation);


