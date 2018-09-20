function normfeaturedataset = imagerecoder(imagefilelist,nrfeatures,displayon)
% UAGE: normfeaturedataset =  imagerecoder(imagefilelist,nrfeatures,displayon)

%
% Working with Gray Scale Images to keep things simple.
%
% Setup Data and Compute Mean Image 
% Note using the Mean Image assumes all images cluster in a ball
% in image space so this assumption need to be examined in practice.
nrimagefiles = length(imagefilelist);
sumgrayimage = 0;
for i = 1:nrimagefiles,
    imagefilename = imagefilelist{i};
    [imagename,leftover] = strtok(imagefilename,'.');
    imagefiletype = strtok(leftover,'.');
    imagedata = imread(imagename,imagefiletype);
    imagedatalist{i} = imagedata;
    [imagerowdim,imagecoldim] = size(imagedata);
    grayimagedata = double(rgb2gray(imagedata)); % Convert To Gray Scale Image represented by matrix
    grayimagedatalist{i} = grayimagedata;
    sumgrayimage = sumgrayimage + grayimagedata;
end;
meangrayimage = sumgrayimage/nrimagefiles;

% Do SVD of average gray image so we are basically doing a singular
% value decomposition of the center of the image cluster. Then we will
% use the left and right eigenvectors as a basis for projecting the
% other images into a common subspace.
nrfeatures = min([nrfeatures, imagerowdim, imagecoldim]);
[umatrix,smatrix,vmatrix] = svds(meangrayimage,nrfeatures);

% Now we will construct the training data set by projecting each 
% image into the common subspace
for i = 1:nrimagefiles,
    for k = 1:nrfeatures,
        featuredataset(i,k) = umatrix(:,k)'*grayimagedatalist{i} * vmatrix(:,k);
    end; % end loop k through features
    normfeaturedataset(i,:) = featuredataset(i,:)/(norm(featuredataset(i,:))+eps);
    reconstructedimage = umatrix * diag(featuredataset(i,:)) * vmatrix';
    
% Now we will display the results as we construct the feature data set
% if the "displayon" flag is set equal to 1.
    if displayon,
        subplot(2,2,1);
        image(imagedatalist{i});
        axis('image');axis off;
        title('Original Image'); % display color image
        
        subplot(2,2,2);
        grayimagedata = grayimagedatalist{i};
        dispgrayimage(grayimagedata);  % Display Black and white image
        title('Gray Scale Image');
        
        subplot(2,2,3);  % Reconstructed Image
        dispgrayimage(reconstructedimage);
        title('Reconstructed Image');
        
        subplot(2,2,4); % Recoded Vector
        recodedvector = normfeaturedataset(i,:);
        bar(recodedvector);
        ylabel('Feature Value');
        xlabel('Feature Id');
        title(['Recoded Vector #',num2str(i)]);
        
        % Pause for 5 seconds for display
        disp(['Displaying Image #',num2str(i)]);
        pause(5);
    end;
end; % end loop i through images




