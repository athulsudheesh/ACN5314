function localprobs = computelocalprobs(statevector,constants,temperature)
% USAGE: localprobs = computelocalprobs(statevector,constants,temperature)

funkfile = constants.objectivefunctionfile;
dim = length(statevector);
localprobs = zeros(dim,1);
for k = 1:dim,
    statevector1 = statevector;
    statevector0 = statevector;
    statevector1(k) = 1;
    statevector0(k) = 0;
    funkval1 = feval(funkfile,statevector0,constants);
    funkval0 = feval(funkfile,statevector1,constants);
    localprobs(k) = logisticsigmoid(0.5*(funkval1 - funkval0)/temperature);
end

