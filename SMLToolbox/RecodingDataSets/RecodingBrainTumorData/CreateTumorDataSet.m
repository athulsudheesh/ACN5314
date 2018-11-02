function CreateTumorDataSet(nrfeatures);
% Select Image files for processing in local directory
disp('IMAGE DATA FILES IN MATLAB FORMAT ARE DOWNLOADED FROM https://figshare.com/articles/brain_tumor_dataset/1512427');
disp('All IMAGE FILES IN MATLAB FORMAT should be placed in folder "imageData"');
[imagefilelist, pathname] = uigetfile('imageData/*.mat', 'Select 2 or MORE image files of type MAT:','Multiselect','On');

% number of largest eigenvalues to use. Also dimension
% of feature space (number of features in a recoded vector)
%nrfeatures = 3; 
%nrfeatures = 15;
%nrfeatures = 30;
%nrfeatures = 50;

% Display Coding Process with a 3 second delay per image
% displayon = 1 turns it on. displayon = 0 turns it off
displayon = 1;

% Working with Gray Scale Images to keep things simple.
%
% Setup Data and Compute Mean Image 
% Note using the Mean Image assumes all images cluster in a ball
% in image space so this assumption need to be examined in practice.
figure;
nrimagefiles = length(imagefilelist);
sumgrayimage = 0;
for i = 1:nrimagefiles,
    imagefilename = imagefilelist{i};
    [imagename,leftover] = strtok(imagefilename,'.');
    imagefiletype = strtok(leftover,'.');
    tumorimagefilename = ['imageData\',imagefilename];
    [tumorlabel,grayimagedata] = gettumorimagedata(tumorimagefilename,displayon);
    grayimagedatalist{i} = grayimagedata;
    sumgrayimage = sumgrayimage + grayimagedata;
    targetvector(i) = tumorlabel; % SET UP DESIRED RESPONSE VECTOR
end;
meangrayimage = double(sumgrayimage/nrimagefiles);

% Do SVD of average gray image so we are basically doing a singular
% value decomposition of the center of the image cluster. Then we will
% use the left and right eigenvectors as a basis for projecting the
% other images into a common subspace.
[imagerowdim,imagecoldim] = size(meangrayimage);
nrfeatures = min([nrfeatures, imagerowdim, imagecoldim]);
[umatrix,smatrix,vmatrix] = svds(meangrayimage,nrfeatures);


% Now we will construct the training data set by projecting each 
% image into the common subspace
for i = 1:nrimagefiles,
    for k = 1:nrfeatures,
        doublematrix = double(grayimagedatalist{i});
        featuredataset(i,k) = umatrix(:,k)'*doublematrix * vmatrix(:,k);
    end; % end loop k through features
    recodedvector = featuredataset(i,:)/(norm(featuredataset(i,:))+eps);
    reconstructedimage = umatrix * diag(featuredataset(i,:)) * vmatrix';
    recodedvector = recodedvector/(norm(recodedvector) + eps);
    recodedvector = [recodedvector(2:nrfeatures) 1]; % DELETE DOMINANT FEATURE AND ADD INTERCEPT
    normfeaturedataset(i,:) = recodedvector;
    
% Now we will display the results as we construct the feature data set
% if the "displayon" flag is set equal to 1.
    if displayon,
        subplot(1,3,1);
        grayimagedata = grayimagedatalist{i};
        dispgrayimage(grayimagedata);  % Display Black and white image
        title('Gray Scale Image');
        
        subplot(1,3,2);  % Reconstructed Image
        dispgrayimage(reconstructedimage);
        title('Reconstructed Image');
        
        subplot(1,3,3); % Recoded Vector
        bar(recodedvector);
        ylabel('Feature Value');
        xlabel('Feature Id');
        title(['Recoded Vector #',num2str(i)]);
        
        % Pause for 2 seconds for display
        disp(['Displaying Image #',num2str(i)]);
        pause(1);
    end;
end; % end loop i through images

% Insert first column with "label" for the image
normfeaturedataset = [targetvector(:) normfeaturedataset];

% Generate Labels
[nrvectors,fdim] = size(normfeaturedataset);
fdimless2 = fdim - 2;
featurelabels = {'Target'};
for k = 1:fdimless2,
    thelabel{k} = ['f',num2str(k)];
    featurelabels = [featurelabels thelabel{k}];
end;
featurelabels{fdimless2+2} = 'Intercept';

% Write a spreadsheet where each row is an image
% and each column is a feature
outputfilename = 'codedimagedata.xlsx';
if exist(outputfilename),
    delete(outputfilename);
end;
cellfeaturedataset = num2cell(normfeaturedataset);
outputimage = [featurelabels; cellfeaturedataset];
xlswrite(outputfilename,outputimage);
disp(['Recoded Data has been saved to the spreadsheet "',outputfilename,'"']);