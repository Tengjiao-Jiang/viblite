function [] = PlotLine( subCandlineCord )

for i = 1:(size(subCandlineCord,1)/2)
    plot([subCandlineCord(2*i-1,1) subCandlineCord(2*i,1)],[subCandlineCord(2*i-1,2) subCandlineCord(2*i,2)],'y--','LineWidth',1);%[x1 x2] [y1 y2] 'y:' 'y-.' 'y--'
end


end