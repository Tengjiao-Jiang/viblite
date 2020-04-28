function greyvalue_max = findSubMaxGray(img,subwidth,subhight,start_x,start_y,blackgrayscale)
greyvalue = 0;
sign = 0;
for k = start_x:start_x+subwidth
    for l = round(start_y-1/2*subhight):round(start_y+1/2*subhight),
        grey = img(l,k);
        if grey > blackgrayscale
            sign = 1;
            greyvalue_max = 255;
            break;
        elseif ( grey > greyvalue),
            greyvalue = grey;
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
