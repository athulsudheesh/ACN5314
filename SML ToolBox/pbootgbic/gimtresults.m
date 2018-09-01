function gimtresults(simulation)
% USAGE: gimtresults(simulation);

% Compute Dimensions
[nrboots,samplesize] = size(simulation);

% Compute GIMT statistics
truemodel = [];
decoy1 = [];
decoy2 = [];
decoy3 = [];
for bootid = 1:nrboots,
    si = simulation{bootid,samplesize};
    badsample = isempty(si.A1.modelfits)| isempty(si.D1.modelfits) | ...
             isempty(si.D2.modelfits) | isempty(si.true.modelfits) ;
    if badsample, 
        disp(['Bootstrap #',num2str(booti), 'for samplesize = 100% is Ill-Conditioned']);
    else
        truegimt = si.true.testmodelfits.gimt;
        truemodel = [truemodel; truegimt.traceainvb truegimt.tracebinva truegimt.logdetainvb];
        
        decoy1gimt = si.D1.testmodelfits.gimt;
        decoy1 = [decoy1; decoy1gimt.traceainvb decoy1gimt.tracebinva decoy1gimt.logdetainvb];
        
        decoy2gimt = si.D2.testmodelfits.gimt;
        decoy2 = [decoy2; decoy2gimt.traceainvb decoy2gimt.tracebinva decoy2gimt.logdetainvb];
        
        decoy3gimt = si.A1.testmodelfits.gimt;
        decoy3 = [decoy3; decoy3gimt.traceainvb decoy3gimt.tracebinva decoy3gimt.logdetainvb];
    end;
end;

disp(' TRUE MODEL: TraceAinvB     TraceBinvA     LogDetAinvB');
meantrue = mean(truemodel);
stderrortrue = std(truemodel);
simerrortrue = stderrortrue / sqrt(nrboots);
disp(['TRUE = ',num2str(meantrue),', ERROR = ',num2str(stderrortrue),' SIM-ERROR=',num2str(simerrortrue)]);
disp(' ');
disp(' DECOY 1: TraceAinvB     TraceBinvA     LogDetAinvB');
meanD1 = mean(decoy1);
stderrorD1 = std(decoy1);
simerrorD1 = stderrorD1 / sqrt(nrboots);
disp(['DECOY1 = ',num2str(meanD1),', ERROR = ',num2str(stderrorD1),' SIM-ERROR=',num2str(simerrorD1)]);
disp(' ');
disp(' DECOY 2: TraceAinvB     TraceBinvA     LogDetAinvB');
meanD2 = mean(decoy2);
stderrorD2 = std(decoy2);
simerrorD2 = stderrorD2 / sqrt(nrboots);
disp(['DECOY 2 = ',num2str(meanD2),', ERROR = ',num2str(stderrorD2),' SIM-ERROR=',num2str(simerrorD2)]);
disp(' ');
disp(' DECOY 3: TraceAinvB     TraceBinvA     LogDetAinvB');
meanD3 = mean(decoy3);
stderrorD3 = std(decoy3);
simerrorD3 = stderrorD3 / sqrt(nrboots);
disp(['DECOY 3 = ',num2str(meanD3),', ERROR = ',num2str(stderrorD3),' SIM-ERROR=',num2str(simerrorD3)]);
