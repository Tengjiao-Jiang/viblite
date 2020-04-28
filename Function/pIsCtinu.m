function subCandEdge_new = pIsCtinu(subCandEdge)
sz = size(subCandEdge);
num = sz(1);
point = [];
subCandEdge_new = [];
i = 1;
sum_p = 0;
y = 0;

%% In case only one point
if (num == 1)   
    subCandEdge_new = subCandEdge;
end

%% Not only one point
while i < num
    sum_p = subCandEdge(i,2);
    for j = (i+1):num
        b = subCandEdge(j,2);
        a = subCandEdge(j-1,2);
    
        if (( b - a) == 1) && (j ~= num)
            sum_p = sum_p + b;
        elseif (( b - a) == 1) && (j == num)
            sum_p = sum_p + b;
            y = sum_p / (j-i+1);
            subCandEdge_new = [subCandEdge_new; [subCandEdge(i,1),y]];
            i = num+1;
            break;
        elseif (( b - a) ~= 1) && (j == num)
            y = sum_p / (j-i);
            subCandEdge_new = [subCandEdge_new; [subCandEdge(i,1),y]];
            subCandEdge_new = [subCandEdge_new; [subCandEdge(j,1),subCandEdge(j,2)]];
            i = num+1;
            break;
        else
            y = sum_p / (j-i);
            subCandEdge_new = [subCandEdge_new; [subCandEdge(i,1),y]];
            i = j;
            break;
        end
    end
       
end
end





