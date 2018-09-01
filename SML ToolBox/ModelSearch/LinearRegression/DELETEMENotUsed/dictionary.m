function constants = dictionary(constants)
% USAGE: constants = dictionary(constants);

% DEFINE VARIABLE NAMES
varnames = {...
    'ART','RICK','SAM','RALPH','LANCE','HARRY','Gangmember','NotGangmember','Pusher','Burglar','Bookie',...
    'BlackHair','BlondeHair','GreyHair','Tall','Medium','Short','Adult','Teenager','GoodCitizen'};
nrvarnames = length(varnames);

% DEFINE VARIABLE VALUES (Each variable can have a different
% number of values but this example just considers the 2-valued case)
% With more than 2-values then the mathematics becomes slightly
% more complicated when deriving algorithm details.
possiblevarvalue{1} = {'ART',''};
possiblevarvalue{2} = {'RICK',''};
possiblevarvalue{3} = {'SAM',''};
possiblevarvalue{4} = {'RALPH',''};
possiblevarvalue{5} = {'LANCE',''};
possiblevarvalue{6} = {'HARRY',''};
possiblevarvalue{7} = {'Gangmember',''};
possiblevarvalue{8} = {'NotGangmember',''};
possiblevarvalue{9} = {'Pusher',''};
possiblevarvalue{10} = {'Burglar',''};
possiblevarvalue{11} = {'Bookie',''};
possiblevarvalue{12} = {'BlackHair',''};
possiblevarvalue{13} = {'BlondeHair',''};
possiblevarvalue{14} = {'GreyHair',''};
possiblevarvalue{15} = {'Tall',''};
possiblevarvalue{16} = {'Medium',''};
possiblevarvalue{17} = {'Short',''};
possiblevarvalue{18} = {'Adult',''};
possiblevarvalue{19} = {'Teenager',''};
possiblevarvalue{20} = {'GoodCitizen',''};

% Load results into constants
constants.model.dictionary.varnames = varnames;
constants.model.dictionary.possiblevarvalue = possiblevarvalue;

end

