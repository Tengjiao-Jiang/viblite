function [adapt_line,line_kb] = lineSearch(img,subwidth_left,subwidth_right,startx_left,startx_right,dia_pixel,linegrayscale,subCandEdge_new_left,subCandEdge_new_right,x)
sz_left = size(subCandEdge_new_left);
num_left = sz_left(1);
sz_right = size(subCandEdge_new_right);
num_right = sz_right(1);

adapt_line = [];
line_kb = [];
    
for i = 1:num_left
    for j = 1:num_right
        if ((subCandEdge_new_left(i,1) - subCandEdge_new_right(j,1)) == 0)
            fprintf('x1 - x2 == 0 !!!');
            continue;
        else
            k = (subCandEdge_new_left(i,2) - subCandEdge_new_right(j,2)) / (subCandEdge_new_left(i,1) - subCandEdge_new_right(j,1));
            b = subCandEdge_new_left(i,2) - k*(subCandEdge_new_left(i,1));
            if (isempty(k)|| isempty(b))
                disp('k or b is empty'); 
                continue; 
            end
            maxgray = lineMaxgray(img,subwidth_right,startx_left,startx_right,dia_pixel,k,b,linegrayscale);
            if maxgray < linegrayscale
                adapt_line = [adapt_line; [subCandEdge_new_left(i,1),subCandEdge_new_left(i,2)]];
                adapt_line = [adapt_line; [subCandEdge_new_right(j,1),subCandEdge_new_right(j,2)]];
                y = k*x+b;
                line_kb = [line_kb; [k,b,x,y]];
                %fprintf('Find the adapted line %d-%d! MaxGray: %.2f \n',i,j,maxgray);
            %else
                %fprintf('line %d-%d Failure! MaxGray: %.2f \n',i,j,maxgray);
            end
        end
    end
end


end
                

function greyvalue_max = lineMaxgray(img,subwidth_right,startx_left,startx_right,dia_pixel,k,b,linegrayscale)
    greyvalue = 0;
    sign = 0;
    %for x = 1:width
    for x = startx_left:startx_right
        y = round(k*x + b);
        for py = round(y - dia_pixel/2):round(y + dia_pixel/2)
            if img(py,x) > linegrayscale
                sign = 1;
                break;
            elseif (img(py,x) > greyvalue)
                greyvalue = img(py,x);
            end
        end
        if sign == 1
            break;
        end
    end
    
    if sign == 1
        greyvalue_max = 255;
    else
        greyvalue_max = greyvalue;
    end
       
end 
                