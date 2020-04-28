function [I,imagenum] = GetImage(cat, nc, fid) 
[fn,imagenum] = GetFileName(cat, nc, fid);

I = imread(fn);  
sz = size(I); 
if(length(sz) > 2)
    if(sz(3) > 1)
        I = rgb2gray(I); 
    end
end

I = double(I);
return;

end
