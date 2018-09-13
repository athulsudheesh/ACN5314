function varvalue =  decodevector(statevector,constants)
% USAGE: varvalue = decodevector(statevector,constants)

% Load Dictionary
varnames = constants.model.dictionary.varnames;
nrvarnames = length(varnames);
nrpredictors = nrvarnames - 1;
for i = 1:nrpredictors,
    predictornames{i} = varnames{i+1};
end;

% Interpret State Vector
for i = 1:nrpredictors,
    if statevector(i) == 1, 
        varvalue{i} = predictornames{i}; 
    else
        varvalue{i} = '';
    end;
end;

end

