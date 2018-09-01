function testlogisticregression
% USAGE: testlogisticregression

% This is a test routine intended to run logistic regression modeling
% on a data set.
disp('It is assumed first column is the dependent variable (i.e., the target)');
disp('It is assumed last column is a vector of ones corresponding to intercept..'); % 5/31/2015 10am
[filename, pathname] = uigetfile('*.xls','Pick ORIGINAL Data Set');
[originaldata,originalheader,originalraw] = xlsread(filename);
disp(['Data file "',filename,'" has been read.']);
[n,nrvars] = size(originaldata);
disp ([num2str(n),' records have been read.']);

constants = defaultconstants;
dodisplay = 1; estimationonly = 0;
selector = [2 3];
selectedvars = [1 selector nrvars];
originaldatanew = originaldata(:,selectedvars);
perform = logisticreg(dodisplay,estimationonly,originalheader,originaldata,constants);
perform
keyboard;