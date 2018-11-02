function [parameters, constants] = w_update(trainingdata,constants)
    % Initialize Parameters to Random Values
    nrhidden = constants.model.nrhidden;
    nrtargets = trainingdata.nrtargets
    inputvectordim = trainingdata.inputvectordim;
    nrvars = trainingdata.nrvars;
    initialwtmag = constants.initialconditions.wtsdev;
    weightdensity = constants.model.weightdensity;
    hunittype = constants.model.hunittype;
    vmatrix = initialwtmag * randn(nrtargets,nrhidden+1);
    wmatrix = initialwtmag * randn(nrhidden,(nrvars-nrtargets));
    wmatrixT = wmatrix';
    vmatrixT = vmatrix';
    parameters = [vmatrixT(:); wmatrixT(:)];

    % Construct Random Connectivity Matrix and Update Parameter Values
    paramdim = length(parameters);
    constants.model.connectmask = rand(paramdim,1) > 1 - constants.model.weightdensity;
    parameters = parameters .* constants.model.connectmask;
end