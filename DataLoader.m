function  [trainingdata, testingdata]= DataLoader()
% loads the train & test dataset
trainingdata = userinputdataset('Training Data','Training Data Filename?:');
testingdata = userinputdataset('Test Data','Test Data Filename?:');
end

