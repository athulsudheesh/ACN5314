function [tumorlabel,imagematrix] = gettumorimagedata(filename,displayimage);
% USAGE: [tumorlabel,imagematrix] = gettumorimagedata(filename,displayimage);
load(filename);
tumorlabel = cjdata.label;
imagematrix = cjdata.image;
if displayimage,
    dispgrayimage(imagematrix);
    set(gcf,'Name',['    Filename = "',filename,'"       Label = ',num2str(tumorlabel)]);
    pause(0.5);
end;
end

