
% Select Image files for processing in local directory
[filelist, pathname] = uigetfile('*.jpg', 'Select 2 or MORE image files of type JPG:','Multiselect','On');

% number of largest eigenvalues to use. Also dimension
% of feature space (number of features in a recoded vector)
%nrfeatures = 3; 
nrfeatures = 15;
%nrfeatures = 30;
%nrfeatures = 50;

% Display Coding Process with 5 second delay per image
% displayon = 1 turns it on. displayon = 0 turns it off
displayon = 1;

% Do SVD of average gray image so we are basically doing a singular
% value decomposition of the center of the image cluster. Then we will
% use the left and right eigenvectors as a basis for projecting the
% other images into a common subspace. Using gray images to keep things
% simple.
normfeaturedataset = imagerecoder(filelist,nrfeatures,displayon);


% Write a spreadsheet where each row is an image
% and each column is a feature
outputfilename = 'codedimagedata.xlsx';
if exist(outputfilename),
    delete(outputfilename);
end;
xlswrite(outputfilename,normfeaturedataset,displayon);
disp(['Recoded Data has been saved to the spreadsheet "',outputfilename,'"']);