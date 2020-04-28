function [fn,imagenum] = GetFileName(cat, nc, fid)  

if(cat(length(cat)) ~= '\'), cat = [cat '\']; end
str = num2str(fid); 
len = length(str);
for i = (len+1):nc.noDigit
str = ['0' str];     
end
fn = [cat nc.baseName str '.' nc.ext];
imagenum = str2double(str);

return