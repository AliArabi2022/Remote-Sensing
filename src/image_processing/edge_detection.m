
% Edge detection methods on a selected band

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');

band_num = 150;
band = double(squeeze(data(:,:,band_num)));

%% ================== Edge Detection ==================
% Sobel
sobel_edges = edge(band, 'Sobel');

% Prewitt
prewitt_edges = edge(band, 'Prewitt');

% Roberts
roberts_edges = edge(band, 'Roberts');

% Canny
canny_edges = edge(band, 'Canny', [0.05 0.4]);

%% ================== Visualization ==================
figure('Name','Edge Detection Comparison','NumberTitle','off','Position',[100 100 1400 800]);

subplot(2,3,1);
imshow(mat2gray(band));
title(sprintf('Original - Band %d', band_num));

subplot(2,3,2);
imshow(sobel_edges);
title('Sobel');

subplot(2,3,3);
imshow(prewitt_edges);
title('Prewitt');

subplot(2,3,4);
imshow(roberts_edges);
title('Roberts');

subplot(2,3,5);
imshow(canny_edges);
title('Canny');

sgtitle('Edge Detection Methods');