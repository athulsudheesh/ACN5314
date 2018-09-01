function demolsa
% golsa
addpath([pwd,'\lsa'],'-end');
% Get User Request
doclist = ''; wordlist = ''; ahatk = [];
keepgoing = 1;
while keepgoing,
    userchoice = menu('LSA Analysis Demo (Version: 4/10/2011)',...
              'Create LSA Matrix',...
              'Load LSA Matrix',...
              'Term Generation','Term Meaning and Similarity','Document Retrieval/Information Filtering',...
              'Document Scoring and Similarity','Quit');
    if (userchoice ~= 7) & (userchoice > 2) & (isempty(doclist) | isempty(wordlist) | isempty(ahatk)),
        warnhandle = warndlg('You need to CREATE or LOAD an LSA matrix to do this function!');
        waitfor(warnhandle);
        userchoice = 1;
    end;
    switch userchoice,
        case 1, % Create LSA Matrix
            [wordlist,doclist,ahatk,cancelchoice] = makelsamatrix;
            if ~cancelchoice,
                [nrwords,nrdocuments] = size(ahatk);
                nrsingvals = rank(ahatk);
                disp(['Count Matrix with ',num2str(nrwords),' words and ',num2str(nrdocuments),' documents loaded.']);
                disp(['Number of Singular Values = ',num2str(nrsingvals),'.']);
            end;
        case 2, % Load LSA Matrix
            % STEP 0: Identify file with Count Matrix Data
            [countmatrixfilename, pathname, filterindex] = uigetfile('*CountMatrix.mat', 'Select Term by Document Matrix Data...');
            load(countmatrixfilename);
            [nrwords,nrdocuments] = size(ahatk);
            nrsingvals = rank(ahatk);
            disp(['Count Matrix with ',num2str(nrwords),' words and ',num2str(nrdocuments),' documents loaded.']);
            disp(['Number of Singular Values = ',num2str(nrsingvals),'.']);
        case 3, % Term Generation
            [doclistid,okchoice] = listdlg('PromptString','Select Document',...
                      'SelectionMode','single',...
                      'ListString',doclist);
            if okchoice,
                documentvector = zeros(nrdocuments,1);
                documentvector(doclistid) = 1;
                termvector = ahatk*documentvector;
                termids = find(termvector > 0);
                nrtermids = length(termids);
                disp(['---> Term Generation for Document "',strtrim(doclist(doclistid,:)),'"  <---']);
                clear anglevalue selectedwordlist;
                selectedwordlist = ''; 
                for i = 1:nrtermids,
                    selectedwordlist = strvcat(selectedwordlist,wordlist(termids(i),:));
                    anglevalue(i) = getangle(documentvector,ahatk(termids(i),:));
                end;
                [dum,sortindex] = sort(anglevalue,'ascend');
                for i = 1:nrtermids,
                    disp([selectedwordlist(sortindex(i),:),'    Angular Separation = ',num2str(anglevalue(sortindex(i))),' degrees.']);
                end;
                disp(' ');
                disp('**********************************************************************');
                disp(' ');
            end;
        case 4, % Term Similarity
           [termids,okchoice] = listdlg('PromptString','Select 2 or More Terms',...
                      'SelectionMode','multiple',...
                      'ListString',wordlist);
            if okchoice,
                nrtermids = length(termids);
                disp(['---> Term Similarity  <---']);
                k = 0; clear angleij displayout;
                for i = 1:nrtermids,
                    for j = (i+1):nrtermids,
                        k = k + 1;
                        angleij(k) = getangle(ahatk(termids(i),:),ahatk(termids(j),:));
                        if (angleij(k) == 0), identicaldisplay = 'Identical Match!!!'; else identicaldisplay = ''; end;
                        displayoutput{k} = ['"',wordlist(termids(i),:),'" and "',wordlist(termids(j),:),'" = ',num2str(angleij(k),'%6.3f'),' degrees.    ', identicaldisplay];
                    end;
                end;
                [dum,sortindex] = sort(angleij,'ascend');
                nrlines = length(displayoutput);
                for k = 1:nrlines,
                    disp(displayoutput{sortindex(k)});
                end;
                disp(' ');
                disp('**********************************************************************');
                disp(' ');
            end;
        case 5, % Document Retrieval
            [termids,okchoice] = listdlg('PromptString','Select 1 or More Terms',...
                      'SelectionMode','multiple',...
                      'ListString',wordlist);
            if okchoice,
                termvector = zeros(nrwords,1);
                termvector(termids) = 1;
                disp(['Terms Selected by User:']);
                disp(wordlist(termids,:));  
                disp(' ');
                disp(['Documents Retrieved:']);
                nrdocids = length(doclist);
                clear anglevalue selecteddoclist;
                selecteddoclist = ''; 
                for i = 1:nrdocids,
                    selecteddoclist = strvcat(selecteddoclist,doclist(i,:));
                    anglevalue(i) = getangle(termvector,ahatk(:,i));
                end;
                nrselecteddocs = length(selecteddoclist);
                [dum,sortindex] = sort(anglevalue,'ascend');
                for i = 1:nrselecteddocs,
                    disp([selecteddoclist(sortindex(i),:),'    Angular Separation = ',num2str(anglevalue(sortindex(i))),' degrees.']);
                end;
                disp(' ');
                disp('**********************************************************************');
                disp(' ');
            end;
        case 6, % Document Scoring and Similarity
            [docids,okchoice] = listdlg('PromptString','Select 2 or More Documents',...
                      'SelectionMode','multiple',...
                      'ListString',doclist);
            if okchoice,
                nrdocids = length(docids);
                disp(['---> Document Similarity  <---']);
                clear angleij displayoutput;
                displayoutput = ''; k = 0; 
                for i = 1:nrdocids,
                    for j = (i+1):nrdocids,
                        k = k + 1;
                        angleij(k) = getangle(ahatk(:,docids(i)),ahatk(:,docids(j)));
                        if (angleij(k) == 0), identicaldisplay = 'Identical Match!!!'; else identicaldisplay = ''; end;
                        displayoutput{k} = ['"',doclist(docids(i),:),'" and "',doclist(docids(j),:),'" = ',num2str(angleij(k),'%6.3f'),' degrees.    ', identicaldisplay];
                    end;
                end;
                [dum,sortindex] = sort(angleij,'ascend');
                nrlines = length(displayoutput);
                for k = 1:nrlines,
                    disp(displayoutput{sortindex(k)});
                end;
                disp(' ');
                disp('**********************************************************************');
                disp(' ');
            end;
        case 7, % Quit
            keepgoing = 0;
    end;
end;