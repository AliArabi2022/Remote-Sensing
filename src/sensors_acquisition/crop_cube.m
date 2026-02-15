% crop_cube.m
% Crop a spatial region from the hyperspectral cube

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');

%% ================== Crop Parameters ==================
% Define crop region [row_start row_end; col_start col_end]
% Example: central region of Indian Pines
row_start = 30;
row_end   = 110;
col_start = 40;
col_end   = 120;

% Or use interactive selection (uncomment if preferred)
% [x,y,w,h] = imcrop(mat2gray(data(:,:,50)));
% But for script reproducibility → fixed values are better

%% ================== Perform Crop ==================
cropped_data = data(row_start:row_end, col_start:col_end, :);
cropped_gtm  = gtm (row_start:row_end, col_start:col_end);

[Nr_new, Nc_new, Nb] = size(cropped_data);
fprintf('Cropped cube size: %d × %d × %d\n', Nr_new, Nc_new, Nb);

%% ================== Visualization ==================
band_example = 80;

figure('Name','Crop Comparison','NumberTitle','off');

subplot(1,2,1);
imshow(mat2gray(squeeze(data(:,:,band_example))),[]);
title('Original Image');
hold on;
rectangle('Position',[col_start, row_start, col_end-col_start+1, row_end-row_start+1], ...
          'EdgeColor','r','LineWidth',2.5);
hold off;
axis image;

subplot(1,2,2);
imshow(mat2gray(squeeze(cropped_data(:,:,band_example))),[]);
title('Cropped Region');
axis image;

% Ground truth comparison
figure('Name','Ground Truth - Cropped','NumberTitle','off');
subplot(1,2,1); imagesc(gtm);  title('Original GT'); axis image;
subplot(1,2,2); imagesc(cropped_gtm); title('Cropped GT'); axis image;

%% ================== Save Cropped Data (optional) ==================
% save('data/IPS200_cropped_30-110_40-120.mat', 'cropped_data', 'cropped_gtm', '-v7.3');

disp('Crop completed. Variables: cropped_data, cropped_gtm');