%% Remote Sensing Radar (SAR) Example
% This example demonstrates SAR data processing workflow:
% 1. SAR data simulation
% 2. Visualization
% 3. Speckle filtering
% 4. Multi-polarization analysis

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Remote Sensing: SAR (Radar) Example ===\n\n');

%% 1. Simulate SAR Data - VV Polarization
fprintf('Step 1: Simulating SAR data (VV polarization)...\n');
rows = 200;
cols = 200;

data_vv = simulate_sar_data(rows, cols, ...
                           'polarization', 'VV', ...
                           'speckle', 0.5, ...
                           'targets', 3);

%% 2. Visualize SAR Data
fprintf('\nStep 2: Visualizing SAR amplitude...\n');
visualize_data(data_vv.amplitude, 'radar', 'title', 'SAR Amplitude (VV)');

% Visualize phase
figure('Name', 'SAR Phase');
imagesc(data_vv.phase); colorbar; colormap(hsv);
title('SAR Phase (VV)');
axis image;

%% 3. Speckle Filtering
fprintf('\nStep 3: Applying speckle filters...\n');

% Apply different filters
filtered_lee = speckle_filter_sar(data_vv.amplitude, 'lee', 5);
filtered_frost = speckle_filter_sar(data_vv.amplitude, 'frost', 5);
filtered_median = speckle_filter_sar(data_vv.amplitude, 'median', 5);

% Compare filters
figure('Name', 'Speckle Filtering Comparison');

subplot(2,2,1);
imagesc(20*log10(data_vv.amplitude + eps)); colormap(gray); colorbar;
title('Original (dB)'); axis image;

subplot(2,2,2);
imagesc(20*log10(filtered_lee + eps)); colormap(gray); colorbar;
title('Lee Filter (dB)'); axis image;

subplot(2,2,3);
imagesc(20*log10(filtered_frost + eps)); colormap(gray); colorbar;
title('Frost Filter (dB)'); axis image;

subplot(2,2,4);
imagesc(20*log10(filtered_median + eps)); colormap(gray); colorbar;
title('Median Filter (dB)'); axis image;

%% 4. Multi-Polarization Analysis
fprintf('\nStep 4: Simulating multi-polarization data...\n');

% Simulate different polarizations
data_hh = simulate_sar_data(rows, cols, 'polarization', 'HH', 'speckle', 0.5);
data_vh = simulate_sar_data(rows, cols, 'polarization', 'VH', 'speckle', 0.5);

% Create RGB composite
rgb_composite = zeros(rows, cols, 3);
rgb_composite(:,:,1) = mat2gray(data_vv.amplitude);  % R: VV
rgb_composite(:,:,2) = mat2gray(data_hh.amplitude);  % G: HH
rgb_composite(:,:,3) = mat2gray(data_vh.amplitude);  % B: VH

figure('Name', 'Multi-Polarization RGB');
imshow(rgb_composite);
title('RGB Composite (R:VV, G:HH, B:VH)');

%% 5. Simple Land Cover Classification
fprintf('\nStep 5: Classifying SAR data...\n');

% Stack polarizations
multi_pol_data = cat(3, filtered_lee, data_hh.amplitude, data_vh.amplitude);

% Classify
num_classes = 4;
classified = classify_kmeans(multi_pol_data, num_classes);

figure('Name', 'SAR Classification');
imagesc(classified); colorbar;
colormap(parula(num_classes));
title('K-means Classification (4 classes)');
axis image;

%% Summary
fprintf('\n=== Analysis Summary ===\n');
fprintf('Data size: %d x %d\n', rows, cols);
fprintf('Polarizations: VV, HH, VH\n');
fprintf('Speckle filters applied: Lee, Frost, Median\n');
fprintf('Classification: %d classes\n', num_classes);

fprintf('\nSAR example completed successfully!\n');
