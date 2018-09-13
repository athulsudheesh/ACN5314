function textdata = readtextfile(filename)
% USAGE: textdata = readtextfile(filename)

textdata = textread(filename,'%s','delimiter','\n','whitespace','');