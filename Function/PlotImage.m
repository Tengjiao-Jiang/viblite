function [ ] = PlotImage(figNo,I)

figure(figNo)
subplot('position', [0 0 1 1]);
imagesc(I)
hold on
colormap gray

end

