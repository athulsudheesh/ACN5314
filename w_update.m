function [parameters] = w_update(trainingdata,constants)
% updating weight parameters 
nrtargets = trainingdata.nrtargets;
inputvectordim = trainingdata.inputvectordim;
nrvars = trainingdata.nrvars;
initialwtmag = constants.initialconditions.wtsdev;
wmatrix = initialwtmag * randn(nrtargets,nrvars-nrtargets);
parameters = wmatrix(:);
end

