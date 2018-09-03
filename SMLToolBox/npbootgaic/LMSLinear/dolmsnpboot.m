function dolmsnpboot;
% USAGE: dolmsnpboot;

rng('shuffle');
close all hidden;
[constants,thedata] = setuplmsconstants;
%originaldataset = constants.data.eventhistory;
% [nrrecords,patterndim] = size(originaldataset);
% permuteddataset = permutedataset(originaldataset)
% reduceddim = round(nrrecords/10);
% smallerdataset = permuteddataset(1:reduceddim,:);
% constants.data.eventhistory = smallerdataset;
initialwtmag = constants.initialconditions.wtsdev;
[samplesize,nrvars] = size(thedata.eventhistory);
nrtargets = thedata.nrtargets;
initialstatemx = initialwtmag*(randn(nrtargets,nrvars-nrtargets));
nrbootstraps = constants.nrbootstraps;
%npbooteric(initialstatemx,nrbootstraps,constants,thedata);
npbootgaictest(initialstatemx,nrbootstraps,constants,thedata);

