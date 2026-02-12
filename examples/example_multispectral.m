%% Remote Sensing Multispectral Example
% This example demonstrates multispectral data processing workflow:
% 1. Data simulation
% 2. Visualization
% 3. Vegetation index calculation
% 4. Classification
% 5. Agricultural application

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Remote Sensing: Multispectral Example ===\n\n');

%% 1. Simulate Multispectral Data
fprintf('Step 1: Simulating multispectral data...\n');
rows = 200;
cols = 200;
num_bands = 6;  % Blue, Green, Red, NIR, SWIR1, SWIR2

data = simulate_multispectral_data(rows, cols, num_bands, ...
                                   'noise', 0.05, ...
                                   'classes', 4);

%% 2. Visualize Data
fprintf('\nStep 2: Visualizing data...\n');
visualize_data(data, 'multispectral', 'title', 'Simulated Multispectral Data');

%% 3. Calculate Vegetation Indices
fprintf('\nStep 3: Calculating vegetation indices...\n');
indices = calculate_vegetation_indices(data);

% Visualize indices
figure('Name', 'Vegetation Indices');
subplot(2,2,1);
imagesc(indices.NDVI); colorbar; colormap(jet);
title('NDVI'); axis image;

subplot(2,2,2);
imagesc(indices.EVI); colorbar; colormap(jet);
title('EVI'); axis image;

subplot(2,2,3);
imagesc(indices.SAVI); colorbar; colormap(jet);
title('SAVI'); axis image;

subplot(2,2,4);
imagesc(indices.NDWI); colorbar; colormap(jet);
title('NDWI'); axis image;

%% 4. Image Enhancement
fprintf('\nStep 4: Applying image enhancement...\n');
enhanced = enhance_image(data, 'contrast_stretch');

%% 5. Unsupervised Classification
fprintf('\nStep 5: Performing K-means classification...\n');
num_classes = 4;
classified = classify_kmeans(data, num_classes);

figure('Name', 'Classification Results');
imagesc(classified); colorbar;
colormap(parula(num_classes));
title('K-means Classification (4 classes)');
axis image;

%% 6. Agricultural Application - Crop Health Analysis
fprintf('\nStep 6: Analyzing crop health...\n');
results = analyze_crop_health(data);

%% Summary
fprintf('\n=== Analysis Summary ===\n');
fprintf('Data size: %d x %d x %d\n', rows, cols, num_bands);
fprintf('Mean NDVI: %.3f\n', results.stats.mean_ndvi);
fprintf('Healthy area: %.1f%%\n', results.stats.healthy_area_pct);
fprintf('Stressed area: %.1f%%\n', results.stats.stressed_area_pct);

fprintf('\nMultispectral example completed successfully!\n');
