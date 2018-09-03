function varvalue =  decodevector(statevector,constants)
% USAGE: varvalue = decodevector(statevector,constants)

% Load Dictionary
varnames = constants.model.dictionary.varnames;
nrvarnames = length(varnames);
possiblevarvalue = constants.model.dictionary.possiblevarvalue;

% Interpret State Vector
for i = 1:nrvarnames,
    if statevector(i) == 1, 
        varvalue{i} = possiblevarvalue{i}{1}; 
    else
        varvalue{i} = possiblevarvalue{i}{2};
    end;
end;

end

