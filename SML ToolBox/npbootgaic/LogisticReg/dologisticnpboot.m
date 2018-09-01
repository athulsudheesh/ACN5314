function dologisticnpboot;
% USAGE: dologisticnpboot;

rng('shuffle');
close all hidden;
[constants,thedata] = setuplogisticconstants;
initialwtmag = constants.initialconditions.wtsdev;
[samplesize,nrvars] = size(thedata.eventhistory);
nrtargets = thedata.nrtargets;
initialstatemx = initialwtmag*(randn(nrtargets,nrvars-nrtargets));
nrbootstraps = constants.nrbootstraps;
npbootgaictest(initialstatemx,nrbootstraps,constants,thedata);
%npbooteric(initialstatemx,nrbootstraps,constants,thedata);

