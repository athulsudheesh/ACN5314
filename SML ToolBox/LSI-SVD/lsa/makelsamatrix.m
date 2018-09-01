function [wordlist,doclist,ahatk,cancelchoice] = makelsamatrix;

% STEP 0: Select input datafile
wordlist = ''; doclist = ''; ahatk = [];

userchoice = input('1) Input all documents as a single file, 2) Input each document as a separate file:','s');
if userchoice == 1,
    [filename, pathname, filterindex] = uigetfile('*.txt', 'Please select document text file...');
    cancelchoice = isequal(filename,0);
else
    setupcounttextdata; % RMG 4/11/2011
    pathname = pwd;
    filename = 'docdata.txt';
    cancelchoice = 0;
end;

if ~cancelchoice,
    % STEP 1: Construct term by document matrix
     [a,wordlist,doclist] = makecountmx(pathname,filename);

    % STEP 2: Display Word Dictionary and Document List
    disp('--------------------------------------');
    disp('The following documents were processed:');
    disp(doclist)
    disp('--------------------------------------');
    disp('The following "terms" were processed:');
    disp(wordlist);

    % STEP 3: Do Singular Value Decomposition of A matrix
    [u,s,v] = svd(a);

    % STEP 4: Check Accuracy of Decomposition
    ahat = u*s*v';
    ahaterror = norm(ahat(:) - a(:));
    disp(['SVD Decomposition Norm Deviation (all singular values used) = ',num2str(ahaterror)]);

    % STEP 5: Display Singular Values in a Plot
    [srowdim,scoldim] = size(s);
    diags = diag(s);
    sdim = length(diags)
    svplothandle = figure;
    set(svplothandle,'Name','Singular Value Plot');
    plot([1:sdim],diags,'kd-');
    title('Singular Value Display');
    ylabel('Singular Value');
    xlabel('Singular Value ID');

    % STEP 6: Ask user for number of Latent Factors
    sk = s;
    k = input('Number of Latent Factors?');
    for i = (k+1):srowdim,
        for j = (k+1):scoldim,
            sk(i,j) = 0;
        end;
    end;
    ahatk = u*sk*v';
    ahatkerror = norm(ahatk(:) - a(:));
    disp(['SVD Decomposition Norm Deviation (using top ',num2str(k),' singular values) = ',num2str(ahatkerror)]);

    disp('The matrix "ahatk" in the workspace is the SVD approximation to the original count matrix "a"');
    svdapproxhandle = figure;
    set(svdapproxhandle,'Name','SVD Approximation Display');
    subplot(1,2,1);
    contour(a);
    ranka = rank(a);
    title(['Original Term by Document Matrix (# singular values =',num2str(ranka),')']);
    subplot(1,2,2);
    contour(ahatk);
    title(['Term by Document Matrix (# singular values =',num2str(k),')']);

    outfilename = 'currentCountMatrix.mat';
    [outfilename, pathname] = uiputfile('*CountMatrix.mat', 'Save Workspace as:');
    save(outfilename,'ahatk','doclist','wordlist');
end;
