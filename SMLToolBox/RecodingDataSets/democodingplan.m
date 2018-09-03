function democodingplan
% USAGE: democodingplan

datafilename = 'Comp-Clean.xlsx'; % This has eight columns of data
codingplan{1} = 'reference-cell' %'binary'; % "Daypart"
codingplan{2} = 'binary' %'numeric'; % "Duration"
codingplan{3} = 'reference-cell'%'Format'; % "maint"
codingplan{4} = ''; % "Diff"
codingplan{5} = ''; "Intercept"
[newspreadsheet,recodeddata,recodeddatalabels,datatransforms] = recodedata(datafilename,codingplan)