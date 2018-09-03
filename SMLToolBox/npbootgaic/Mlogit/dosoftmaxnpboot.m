function dosoftmaxlearn;
% USAGE: dosoftmaxlearn;

rng('shuffle');
close all hidden;
[constants,thedata] = setupmlogitconstants;
initialwtmag = constants.initialconditions.wtsdev;
[samplesize,nrvars] = size(thedata.eventhistory);
nrtargets = thedata.nrtargets;
initialstatemx = initialwtmag*(randn((nrtargets-1),nrvars-nrtargets));
nrbootstraps = constants.nrbootstraps;
%npbooteric(initialstatemx,nrbootstraps,constants,thedata);
npbootgaictest(initialstatemx,nrbootstraps,constants,thedata);


