function [finesubCand_left, finesubCand_right, fineLineCord,error] = subpixelcenterline(img,subset_height,dia_pixel_real,blackgrayscale,subwidth_left,subwidth_right,startx_left,startx_right,subCandlineCord,subpixel_step)
finesubCand_left = [];
finesubCand_right = [];
fineLineCord = [];
h = size(subCandlineCord,1);
error = 0;

for i = 1:h/2
    
    sum_y = 0;
    num = 0;
    start_left_y = subCandlineCord(2*i-1,2) - dia_pixel_real + subset_height/2;
    end_left_y = subCandlineCord(2*i-1,2) + dia_pixel_real - subset_height/2;
    y = start_left_y;
    while y < end_left_y
        greyvalue_max = 0;
        sign = 0;
        for x = startx_left:(startx_left+subwidth_left)
            for ys = (y-subset_height/2):subpixel_step:(y+subset_height/2)
                gs = interp2(img, x, ys,'cubic');
                if gs > blackgrayscale
                     sign = 1; % if gs > blackgrayscale, then don't need to compair later max value
                     greyvalue_max = 255;
                     break;
                elseif gs > greyvalue_max
                    greyvalue_max = gs;
                end
            end
            
            if sign == 1
                break;
            end
            
        end
        if greyvalue_max < blackgrayscale
            sum_y = sum_y + y;
            num = num + 1;
        end
        y = y + subpixel_step;
    end
    if num > 0
        finesubCand_left = [finesubCand_left;[startx_left,sum_y/num]];
    else
        error = 1;
        disp('Dont find left fine subset!');
        return;
    end
    
    
    sum_y = 0;
    num = 0;
    start_right_y = subCandlineCord(2*i,2) - dia_pixel_real + subset_height/2;
    end_right_y = subCandlineCord(2*i,2) + dia_pixel_real - subset_height/2;
    y = start_right_y;
    while y < end_right_y
        greyvalue_max = 0;
        sign = 0;
        for x = (startx_right-subwidth_right):(startx_right)
            for ys = (y-subset_height/2):subpixel_step:(y+subset_height/2)
                gs = interp2(img, x, ys,'cubic');
                if gs > blackgrayscale
                     sign = 1; % if gs > blackgrayscale, then don't need to compair later max value
                     greyvalue_max = 255;
                     break;
                elseif gs > greyvalue_max
                    greyvalue_max = gs;
                end
            end
            
            if sign == 1
                break;
            end
            
        end

        if greyvalue_max < blackgrayscale
            sum_y = sum_y + y;
            num = num + 1;
        end
        y = y + subpixel_step;
    end
    if num > 0
        finesubCand_right = [finesubCand_right;[startx_right,sum_y/num]]; 
    else
        error = 1;
        disp('Dont find right fine subset!');
        return;
    end
    
    
    
    
    if size(finesubCand_left,1) == size(finesubCand_right,1)
        for i = 1:size(finesubCand_left,1)
            fineLineCord = [fineLineCord;[finesubCand_left(i,1),finesubCand_left(i,2)]];
            fineLineCord = [fineLineCord;[finesubCand_right(i,1),finesubCand_right(i,2)]];
        end
    else
        error = 1;
        disp('len(fineSubCand_left) != len(fineSubCand_right)');
        return;
    end
    
end


end