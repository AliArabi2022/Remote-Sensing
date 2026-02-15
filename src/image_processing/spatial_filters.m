% spatial_filters.m
% Apply spatial domain filters to a selected band of hyperspectral data

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');           % adjust path if needed

% Select a band to process (example)
band_num = 80;
original_band = double(squeeze(data(:,:,band_num)));

%% ================== Filter Parameters ==================
filter_type = 'gaussian';   % options: 'mean', 'median', 'gaussian', 'wiener'
window_size = 5;            % for mean/median/gaussian

%% ================== Apply Filters ==================
switch lower(filter_type)
    case 'mean'
        fprintf('Applying mean filter (%dx%d)\n', window_size, window_size);
        h = fspecial('average', window_size);
        filtered = imfilter(original_band, h, 'replicate');
        
    case 'median'
        fprintf('Applying median filter (%dx%d)\n', window_size, window_size);
        filtered = medfilt2(original_band, [window_size window_size]);
        
    case 'gaussian'
        fprintf('Applying Gaussian filter (sigma = %.1f)\n', window_size/5);
        h = fspecial('gaussian', window_size, window_size/5);
        filtered = imfilter(original_band, h, 'replicate');
        
    case 'wiener'
        fprintf('Applying Wiener adaptive filter\n');
        filtered = wiener2(original_band, [5 5]);
        
    otherwise
        error('Unknown filter type');
end

%% ================== Visualization ==================
figure('Name','Spatial Filtering Comparison','NumberTitle','off','Position',[100 100 1200 500]);

subplot(1,3,1);
imshow(mat2gray(original_band));
title(sprintf('Original - Band %d', band_num));
axis image;

subplot(1,3,2);
imshow(mat2gray(filtered));
title(sprintf('%s Filter (%d)', filter_type, window_size));
axis image;

subplot(1,3,3);
imshow(mat2gray(abs(original_band - filtered)*5));  % amplified difference
title('Amplified Difference');
colormap jet; colorbar;
axis image;

sgtitle('Spatial Domain Filtering');

disp('Spatial filtering completed.');