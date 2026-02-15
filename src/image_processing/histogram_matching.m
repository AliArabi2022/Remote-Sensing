
% Histogram equalization and matching for a band

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');

band_src_num = 50;
band_ref_num = 120;

src = double(squeeze(data(:,:,band_src_num)));
ref = double(squeeze(data(:,:,band_ref_num)));

%% ================== Processing ==================
% Histogram equalization (adaptive)
eq_adapt = adapthisteq(mat2gray(src), 'ClipLimit', 0.01);

% Standard histogram equalization
eq_hist = histeq(mat2gray(src));

% Histogram matching (match src to ref)
matched = imhistmatch(mat2gray(src), mat2gray(ref), 256);

%% ================== Visualization ==================
figure('Name','Histogram Processing','NumberTitle','off','Position',[200 200 1400 800]);

subplot(2,4,1); imshow(mat2gray(src)); title('Original');
subplot(2,4,2); imshow(eq_hist); title('Histogram Equalization');
subplot(2,4,3); imshow(eq_adapt); title('Adaptive Equalization');
subplot(2,4,4); imshow(matched); title('Histogram Matching');

subplot(2,4,5); imhist(uint8(mat2gray(src)*255)); title('Original Hist');
subplot(2,4,6); imhist(uint8(eq_hist*255)); title('Equalized Hist');
subplot(2,4,7); imhist(uint8(eq_adapt*255)); title('Adaptive Hist');
subplot(2,4,8); imhist(uint8(matched*255)); title('Matched Hist');

sgtitle(sprintf('Histogram Processing - Band %d → Band %d', band_src_num, band_ref_num));