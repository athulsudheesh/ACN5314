function democodingplan
% USAGE: democodingplan

% This program illustrates some of the recoding sofware which is using
% for feature extraction...

% This first example begins with file "car_TEST1.xlsx"
% whose first column is the desired binary response and remaining columns
% are the predictor variables.
% Then when you run this program the first variable "buying" is recoded
% using "reference cell" coding.
% The second predictor variable "doors" is recoded using "categorical"
% coding.
% Remaining variables are not recoded.
datafilename = 'car_TEST1.xlsx'; % This has eight columns of data
codingplan{1} = 'binary'; % "CLASS"
codingplan{2} = ''  % "buying"  % Do not change this variable
codingplan{3} = 'categorical' %'maint'; 
codingplan{4} = 'reference-cell'; % "doors"
codingplan{5} = ''; % "persons" % Do not change this variable
codingplan{6} = 'numeric'; % "lugbolt"
codingplan{7} = ''; % "Safety" % Do not change this variable
codingplan{8} = ''; % "Intercept"% Do not change this variable
[newspreadsheet,recodeddata,recodeddatalabels,datatransforms] = recodedata(datafilename,codingplan);
disp(['output file written to : "recoded_',datafilename,'"']);