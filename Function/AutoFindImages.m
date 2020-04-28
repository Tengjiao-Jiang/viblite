function [nameConvention, fids] = AutoFindImages(cat)

nameConvention = struct('baseName',[], 'ext',[], 'noDigit', []);

if(cat(length(cat)) ~= '\'), cat = [cat '\']; end

a = dir([cat '*.png']);
b = dir([cat '*.bmp']);
c = dir([cat '*.tif']);
%c = dir([cat '*.jpg']);
files = [a;b;c;];

noDigCount = [];
baseNames = struct('bn',[]);
baseNamesCount = [];
exts = struct('ext',[]);
extsCount = [];

for i = 1:length(files),
    fn = files(i).name;
    f = strfind(fn,'.');
    if(length(f) ~= 1), continue; end
    post = fn(f+1:length(fn));
    pre = fn(1:f-1);
    if((length(post) < 1) || (length(pre) < 1)), continue; end
    files(i).ext = post;
    [baseName, noDig, fid] = GetFileNameInfo(pre);
    files(i).baseName = baseName;
    files(i).noDig = noDig;
    files(i).fid = fid;
    
    if(noDig > 0)
        if(noDig > length(noDigCount))
            noDigCount(noDig) = 1;
        else
            noDigCount(noDig) = noDigCount(noDig) + 1;
        end
    end
    
    if(~isempty(baseName))
        foundIdx = -1;
        for j = 1:length(baseNames)
            if(strcmp(baseName, baseNames(j).bn)), foundIdx = j; break; end
        end
        if(foundIdx < 0),
            idx = length(baseNames) + 1;
            baseNames(idx).bn = baseName; 
            baseNamesCount(idx) = 1; 
        else, 
            baseNamesCount(foundIdx) = baseNamesCount(foundIdx) + 1;
        end
    end
    
    if(~isempty(post))
        foundIdx = -1;
        for j = 1:length(exts)
            if(strcmp(post, exts(j).ext)), foundIdx = j; break; end
        end
        if(foundIdx < 0),
            idx = length(exts) + 1;
            exts(idx).ext = post; 
            extsCount(idx) = 1; 
        else, 
            extsCount(foundIdx) = extsCount(foundIdx) + 1;
        end
    end
end
% At this point 'files' contain all image files.
% Must remove images that dont fit to the criteria

[val, noDig] = max(noDigCount);
nameConvention(1).noDigit = noDig;
[val, idx] = max(extsCount);
nameConvention(1).ext = exts(idx).ext;
[val, idx] = max(baseNamesCount);
nameConvention(1).baseName = baseNames(idx).bn;

fids = [];
for i = 1:length(files)
    if(files(i).noDig ~= noDig), continue; end
    if(~strcmp(files(i).ext, nameConvention(1).ext)), continue; end
    if(~strcmp(files(i).baseName, nameConvention(1).baseName)), continue; end
    fids(length(fids) + 1) = files(i).fid;
end

fids = sort(fids);

end

function [baseName, noDig, fid] = GetFileNameInfo(fileNameWithoutExt)

baseName = []; noDig = -1; fid = -1;

for i = 1:length(fileNameWithoutExt),
    ii = length(fileNameWithoutExt) - i + 1;
    if(~CharIsNumber(fileNameWithoutExt(ii))), break; end
end
baseName = fileNameWithoutExt(1:ii);

numString = fileNameWithoutExt(ii+1:length(fileNameWithoutExt));
if((length(baseName) < 1) || (length(numString) < 1)), return; end

noDig = length(numString);
fid = str2double(numString);

return;

end

function chk = CharIsNumber(ch),

chk = 0;
if(strcmp(ch,'0'))
    chk = 1; return;
elseif(strcmp(ch,'1'))
    chk = 1; return;
elseif(strcmp(ch,'2'))
    chk = 1; return;
elseif(strcmp(ch,'3'))
    chk = 1; return;
elseif(strcmp(ch,'4'))
    chk = 1; return;
elseif(strcmp(ch,'5'))
    chk = 1; return;
elseif(strcmp(ch,'6'))
    chk = 1; return;
elseif(strcmp(ch,'7'))
    chk = 1; return;
elseif(strcmp(ch,'8'))
    chk = 1; return;
elseif(strcmp(ch,'9'))
    chk = 1; return;
end

return;
end
