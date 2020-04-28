function [subCandlineCord,subCordline_KBXY,subCandEdge_new_left,subCandEdge_new_right,error] = coarseSearch(refI,subwidth_left,subwidth_right,dia_pixel,startx_left,startx_right,starty_up,starty_down,linegrayscale,blackgrayscale,x0)
%Start Detect candidate contact wire
subCandEdge_left = [];
subCandEdge_right = [];
error = 0; % decide if don't find subset or other errors, error = 1;

%% Calculate right subset
for p = round(1/2*dia_pixel+starty_up):round(starty_down-1/2*dia_pixel-1)
    submaxgrey_right = findSubMaxGray(refI,subwidth_right,dia_pixel,(startx_right-subwidth_right),p,blackgrayscale);
    if (submaxgrey_right < blackgrayscale)
        subCandEdge_right = [subCandEdge_right;[startx_right,p]];
    end
end
if isempty(subCandEdge_right)
    error = 1;
    disp('Do not find right subset!');
end

%% Calculate left subset
for q = round(1/2*dia_pixel+starty_up):round(starty_down-1/2*dia_pixel-1)
    submaxgrey_left = findSubMaxGray(refI,subwidth_left,dia_pixel,startx_left,q,blackgrayscale);
    if ( submaxgrey_left < blackgrayscale)
        subCandEdge_left = [subCandEdge_left;[startx_left,q]];
    end
end
if isempty(subCandEdge_left)
    error = 1;
    disp('Do not find left subset!');
end

%% reduce continue points
if error == 0
    subCandEdge_new_left = pIsCtinu(subCandEdge_left);
    subCandEdge_new_right = pIsCtinu(subCandEdge_right);
    %Start Line search 
    [subCandlineCord,subCordline_KBXY] = lineSearch(refI,subwidth_left,subwidth_right,startx_left,startx_right,dia_pixel,linegrayscale,subCandEdge_new_left,subCandEdge_new_right,x0);
    if (isempty(subCandlineCord)|| isempty(subCordline_KBXY))
        error = 1;
    end        
else
    subCandEdge_new_left = [];
    subCandEdge_new_right = [];
    subCandlineCord = [];
    subCordline_KBXY = [];
end


end


