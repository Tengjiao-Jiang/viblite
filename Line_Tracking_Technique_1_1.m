%% A Vision-Based Line-Tracking Technique V 1.1
%
% Line-tracking technique is an image-processing technique and is designed for detecting  
% and tracking a linear object, e.g. a railway catenary wire, from a noisy background.  
% The technique is based on a coarse subset and line search and a subpixel centerline 
% detection, and it can obtain a displacement response of the linear object. 
%
% -------------------------------------------------------------------------+
% 
% Please cite the following article and code if used in research.
%
% Principles are described in detail in the article:
%
% [1] Tengjiao Jiang, Gunnstein Thomas Froseth, Anders Ronnquist, Egil Fagerholt.
%     A Robust Line-Tracking Photogrammetry Method for Uplift Measurements of 
%     Railway Catenary Systems in Noisy Backgrounds, Machanical Systems and 
%     Signal Processing. 144 (2020) 106888. https://doi.org/10.1016/j.ymssp.2020.106888.
%
% [2] Tengjiao Jiang, Gunnstein Thomas Frøseth, Anders Rønnquist, Egil Fagerholt. 
%     A vision-based line-tracking technique, Zenodo, 2020, Version 1.1. 
%     http://doi.org/10.5281/zenodo.3685219.
%
% -------------------------------------------------------------------------
%
% Instructions for use:
% 1 - Input the folder location of images.
% 2 - Input parameters for line tracking.
% 3 - Run code to start line tracking.
%
% -------------------------------------------------------------------------
%
% Author:       Tengjiao Jiang
% Email:        tengjiao.jiang@ntnu.no
% Affiliation:  Norwegian University of Science and Technology (NTNU), Trondheim, Norway
% Website:      https://www.ntnu.edu/employees/tengjiao.jiang
% ORCID:        https://orcid.org/0000-0002-3349-1577
%
% -------------------------------------------------------------------------
% Version:                      1.1
% Last modified:                April 11, 2020
% Check the latest version:     http://doi.org/10.5281/zenodo.3685219
% -------------------------------------------------------------------------

%%
clear
close all
clc
addpath([pwd '\Function'])

%% Input the folder location of images. 
% Note that all images filenames should be in numerical order and placed in a separate folder

%folder = 'E:\EXPERIMENTS\20200128_LineTrackingTechnique\Cam1';
folder = [pwd '\Example'];

[nc, fids] = AutoFindImages(folder);
noImgs = length(fids); %Number of images in sequence
[refI,refImageNum] = GetImage(folder, nc, fids(1)); %Reference image for correlation
cys_ImageNum = zeros(1,length(fids)+1);
cys_ImageNum(1) = refImageNum;
refI_double = double(refI);
sz = size(refI);
height = sz(1);     %Height of the image 
width = sz(2);      %width of the image


%% Input parameters for line tracking. 
%frequency:         Camera sampling frequency (Hz)
%threshold_Get:     The grayscale intensity threshold for the coarse subsetsearch Get. For 8-bit gray image, intensity is [0,255]
%threshold_Gel:     The grayscale intensity threshold for the coarse line search Gel. Usually, Gel >= Get
%subwidth_left:     The left subset width in the coarse search
%subwidth_right:    The left subset width in the coarse search
%subset_height:     The height of the subset for both coarse search and subpixel centreline detection
                    %ROI: region of interest; User defined search rectangle area in image; 
%roi_x_left:        roi_x_left is the minimum x of the rectangle area, such as roi_x_left = 1;
%roi_x_right:       roi_x_right is the maximum x of the rectangle area, such as roi_x_right = width;
%roi_y_upper:       roi_y_upper is the minimum y of the rectangle area, such as roi_y_upper = 1;
%roi_y_lower:       roi_y_lower is the maximum y of the rectangle area, such as roi_y_lower = height;
%subpixel_step:     Vertical step of the subpixel interpolation in the subpixel centerline detection
%x0:                User-defined x coordinate of the tracking point in pixels
%dia_pixel_real:    Real diameter of the wire in pixels

frequency = 200;                         
threshold_Get = 50;                      
threshold_Gel = 100;                     
subwidth_left = 5;                       
subwidth_right = 5;                      
subset_height = 2;                       
roi_x_left = 5;                                
roi_x_right = width-5;    
roi_y_upper = 150;          
roi_y_lower = 260;         
subpixel_step = 0.3;                     
x0 = 270;                                
dia_pixel_real = 13;



%% Start line tracking/detection 

[subCandlineCord,subCordline_KBXY,subCandEdge_new_left,subCandEdge_new_right] = coarseSearch(refI,subwidth_left,subwidth_right,subset_height,roi_x_left,roi_x_right,roi_y_upper,roi_y_lower,threshold_Gel,threshold_Get,x0);
[finesubCand_left, finesubCand_right, fineLineCord] = subpixelcenterline(refI,subset_height,dia_pixel_real,threshold_Get,subwidth_left,subwidth_right,roi_x_left,roi_x_right,subCandlineCord,subpixel_step);

track_Point_y = [];
PlotImage(1, refI);
hold on
text(roi_x_left+20,roi_y_upper-10,'Region of Interest','FontSize',10,'Color','b')
rectangle('Position',[roi_x_left roi_y_upper (roi_x_right-roi_x_left) (roi_y_lower-roi_y_upper)],'EdgeColor','b','LineWidth',1)
plot(finesubCand_left(1),finesubCand_left(2),'r.','MarkerSize',20);
plot(finesubCand_right(1),finesubCand_right(2),'r.','MarkerSize',20);
[line_k,line_b] = k_b_of_line(finesubCand_left, finesubCand_right);
track_Point_y(1) = line_k * x0 + line_b;
plot(x0,track_Point_y(1),'r.','MarkerSize',20);


PlotLine(fineLineCord);
text(20,40,'Click in the image to continue the line tracking...','FontSize',10,'Color','b')
disp('Click in figure/image to continue...'); waitforbuttonpress;


for i = 2:length(fids)
    fid = fids(i); disp(['Fid ' num2str(fid)])
    [I,imagenum] = GetImage(folder, nc, fid);%Get current image
    I_double = double(I); %Get double array of Image
    
    [subCandlineCord,subCordline_KBXY,subCandEdge_new_left,subCandEdge_new_right] = coarseSearch(I,subwidth_left,subwidth_right,subset_height,roi_x_left,roi_x_right,roi_y_upper,roi_y_lower,threshold_Gel,threshold_Get,x0);
    
    [finesubCand_left, finesubCand_right, fineLineCord] = subpixelcenterline(I,subset_height,dia_pixel_real,threshold_Get,subwidth_left,subwidth_right,roi_x_left,roi_x_right,subCandlineCord,subpixel_step);

    hold off
    PlotImage(1, I);
    hold on
    text(roi_x_left+20,roi_y_upper-10,'Region of Interest','FontSize',10,'Color','b')
    rectangle('Position',[roi_x_left roi_y_upper (roi_x_right-roi_x_left) (roi_y_lower-roi_y_upper)],'EdgeColor','b','LineWidth',1)
    PlotLine(fineLineCord);
    plot(finesubCand_left(1),finesubCand_left(2),'r.','MarkerSize',20);
    plot(finesubCand_right(1),finesubCand_right(2),'r.','MarkerSize',20);
    [line_k,line_b] = k_b_of_line(finesubCand_left, finesubCand_right);
    track_Point_y(i) = line_k * x0 + line_b;
    plot(x0,track_Point_y(i),'r.','MarkerSize',20);
    
    cys_ImageNum(i) = imagenum;
    
    pause(0.01);
end


%% Finally, plot y of the tracking point

figure()
plot(track_Point_y(1) - track_Point_y, 'r'); 
legend('Displacement')       
xlabel('Image number')
ylabel('Displacement [pixels]')

