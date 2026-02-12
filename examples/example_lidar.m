%% Remote Sensing LiDAR Example
% This example demonstrates LiDAR data processing workflow:
% 1. LiDAR data simulation
% 2. Visualization (DEM, hillshade)
% 3. Feature extraction (slope, aspect, curvature)
% 4. Terrain analysis

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Remote Sensing: LiDAR Example ===\n\n');

%% 1. Simulate LiDAR Data
fprintf('Step 1: Simulating LiDAR data...\n');
rows = 250;
cols = 250;

data = simulate_lidar_data(rows, cols, ...
                          'terrain_type', 'hilly', ...
                          'vegetation', true, ...
                          'buildings', 3, ...
                          'noise', 0.05);

%% 2. Visualize Elevation Data
fprintf('\nStep 2: Visualizing LiDAR data...\n');
visualize_data(data.elevation, 'lidar', 'title', 'LiDAR DEM');

% Create 3D surface plot
figure('Name', 'LiDAR 3D Terrain');
surf(data.elevation, 'EdgeColor', 'none', 'FaceColor', 'interp');
colormap(terrain);
colorbar;
xlabel('X'); ylabel('Y'); zlabel('Elevation (m)');
title('3D Terrain Model');
view(45, 30);
lighting gouraud;
camlight;

%% 3. Extract Terrain Features
fprintf('\nStep 3: Extracting terrain features...\n');
features = extract_lidar_features(data.elevation);

% Visualize features
figure('Name', 'LiDAR Terrain Features');

subplot(2,3,1);
imagesc(data.elevation); colorbar; colormap(gca, terrain);
title('Elevation (m)'); axis image;

subplot(2,3,2);
imagesc(features.slope); colorbar; colormap(gca, hot);
title('Slope (degrees)'); axis image;
caxis([0, 45]);

subplot(2,3,3);
imagesc(features.aspect); colorbar; colormap(gca, hsv);
title('Aspect (degrees)'); axis image;

subplot(2,3,4);
imagesc(features.hillshade); colorbar; colormap(gca, gray);
title('Hillshade'); axis image;

subplot(2,3,5);
imagesc(features.roughness); colorbar; colormap(gca, jet);
title('Surface Roughness'); axis image;

subplot(2,3,6);
imagesc(features.curvature); colorbar; colormap(gca, jet);
title('Curvature'); axis image;
caxis([-0.5, 0.5]);

%% 4. Terrain Classification
fprintf('\nStep 4: Classifying terrain...\n');

% Stack features for classification
feature_stack = cat(3, data.elevation, features.slope, features.roughness);

num_classes = 5;
classified = classify_kmeans(feature_stack, num_classes);

figure('Name', 'Terrain Classification');
imagesc(classified); colorbar;
colormap(parula(num_classes));
title('Terrain Classification (5 classes)');
axis image;

%% 5. Analyze Slope Distribution
fprintf('\nStep 5: Analyzing slope distribution...\n');

% Calculate statistics
slope_stats.mean = mean(features.slope(:));
slope_stats.std = std(features.slope(:));
slope_stats.max = max(features.slope(:));

% Slope categories
flat_area = sum(features.slope(:) < 5) / numel(features.slope) * 100;
moderate_area = sum(features.slope(:) >= 5 & features.slope(:) < 15) / numel(features.slope) * 100;
steep_area = sum(features.slope(:) >= 15) / numel(features.slope) * 100;

figure('Name', 'Slope Analysis');
subplot(1,2,1);
histogram(features.slope(:), 50);
xlabel('Slope (degrees)');
ylabel('Frequency');
title('Slope Distribution');
grid on;

subplot(1,2,2);
categories = {'Flat (<5°)', 'Moderate (5-15°)', 'Steep (>15°)'};
areas = [flat_area, moderate_area, steep_area];
bar(areas);
set(gca, 'XTickLabel', categories);
ylabel('Area (%)');
title('Slope Categories');
grid on;

%% Summary
fprintf('\n=== Analysis Summary ===\n');
fprintf('Data size: %d x %d\n', rows, cols);
fprintf('Elevation range: %.1f - %.1f m\n', min(data.elevation(:)), max(data.elevation(:)));
fprintf('Mean slope: %.2f degrees\n', slope_stats.mean);
fprintf('Max slope: %.2f degrees\n', slope_stats.max);
fprintf('Flat area: %.1f%%\n', flat_area);
fprintf('Moderate slope area: %.1f%%\n', moderate_area);
fprintf('Steep area: %.1f%%\n', steep_area);

fprintf('\nLiDAR example completed successfully!\n');
