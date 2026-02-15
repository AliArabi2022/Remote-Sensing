% band_visualization.m
% Select and display any spectral band from the Indian Pines hyperspectral dataset
% Assumes data is loaded as 'data' (145x145x200) and gtm (ground truth)

clear; clc; close all;

% Load dataset (change path if needed)
load('D:/work/Remote Sensing/data/IPS200.mat');   % or indian_pines_corrected.mat, etc.
% If your file has different variable names, rename accordingly:
% data = indian_pines_corrected;   % example

[Nx, Ny, Nb] = size(data);
fprintf('Dataset loaded: %dx%d pixels, %d bands\n', Nx, Ny, Nb);

% User input: select band
band_num = input(sprintf('Enter band number to visualize (1 to %d): ', Nb));

if band_num < 1 || band_num > Nb
    error('Invalid band number. Must be between 1 and %d.', Nb);
end

% Extract the selected band
band_image = squeeze(data(:, :, band_num));

% Normalize for better visualization (0-1 range)
band_norm = mat2gray(band_image);

% Display
figure('Name', sprintf('Band %d Visualization', band_num), 'NumberTitle', 'off');
imshow(band_norm, []);
title(sprintf('Indian Pines - Band %d', band_num));
xlabel('Column'); ylabel('Row');
colormap gray; colorbar;
axis image;

% Optional: show with ground truth overlay (semi-transparent)
figure('Name', sprintf('Band %d with Ground Truth Overlay', band_num), 'NumberTitle', 'off');
imshow(band_norm); hold on;
h = imagesc(gtm); 
set(h, 'AlphaData', (gtm > 0) * 0.4);   % transparent where background
colormap jet; colorbar;
title(sprintf('Band %d + Ground Truth (classes 1-16)', band_num));
hold off;