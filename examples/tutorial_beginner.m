%% Beginner Tutorial: Your First Remote Sensing Analysis
% This tutorial walks you through a complete remote sensing workflow
% Perfect for first-time users!

clear; close all; clc;

fprintf('=== Beginner Tutorial: Remote Sensing Analysis ===\n\n');
fprintf('This tutorial will guide you through:\n');
fprintf('1. Creating synthetic remote sensing data\n');
fprintf('2. Visualizing the data\n');
fprintf('3. Calculating vegetation health\n');
fprintf('4. Creating a simple classification\n\n');
fprintf('Press any key to continue...\n');
pause;

% Add source directories to path
addpath(genpath('../src'));

%% Part 1: Understanding Remote Sensing Data
fprintf('\n--- Part 1: Understanding Remote Sensing Data ---\n');
fprintf('Remote sensing data contains multiple "bands" or channels.\n');
fprintf('Each band captures light at different wavelengths.\n\n');

fprintf('We will create a small image with 4 bands:\n');
fprintf('- Band 1: Blue light (450nm)\n');
fprintf('- Band 2: Green light (550nm)\n');
fprintf('- Band 3: Red light (650nm)\n');
fprintf('- Band 4: Near-Infrared (850nm)\n\n');

% Create synthetic data (small for learning)
rows = 100;
cols = 100;
num_bands = 4;

fprintf('Creating %d x %d pixel image with %d bands...\n', rows, cols, num_bands);
data = simulate_multispectral_data(rows, cols, num_bands, 'classes', 3);

fprintf('Data created! Shape: %d x %d x %d\n', size(data,1), size(data,2), size(data,3));
fprintf('\nPress any key to visualize the data...\n');
pause;

%% Part 2: Visualizing the Data
fprintf('\n--- Part 2: Visualizing the Data ---\n');
fprintf('We can visualize the data in different ways.\n\n');

% Show RGB composite
figure('Name', 'Tutorial Part 2: Data Visualization');

subplot(2,3,1);
rgb = data(:,:,[3,2,1]);  % Red, Green, Blue bands
rgb = mat2gray(rgb);      % Normalize to 0-1
imshow(rgb);
title('RGB Composite (True Color)');

% Show individual bands
band_names = {'Blue', 'Green', 'Red', 'Near-Infrared'};
for i = 1:4
    subplot(2,3,i+1);
    imagesc(data(:,:,i));
    colorbar;
    colormap(gca, gray);
    title(['Band ', num2str(i), ': ', band_names{i}]);
    axis image;
end

subplot(2,3,6);
text(0.1, 0.5, {'Notice:', '', 'Vegetation appears', 'dark in RGB but', 'bright in NIR!'}, ...
     'FontSize', 12);
axis off;

fprintf('Figure 1 created!\n');
fprintf('Notice how vegetation (healthy plants) appears bright in the NIR band.\n');
fprintf('This is because plants reflect a lot of near-infrared light!\n\n');
fprintf('Press any key to continue to vegetation analysis...\n');
pause;

%% Part 3: Calculate Vegetation Health
fprintf('\n--- Part 3: Calculating Vegetation Health ---\n');
fprintf('We use the NDVI (Normalized Difference Vegetation Index).\n');
fprintf('NDVI = (NIR - Red) / (NIR + Red)\n');
fprintf('NDVI values:\n');
fprintf('  < 0.2: Bare soil, rocks, water\n');
fprintf('  0.2-0.4: Sparse vegetation\n');
fprintf('  0.4-0.6: Moderate vegetation\n');
fprintf('  > 0.6: Dense, healthy vegetation\n\n');

% Calculate vegetation indices
indices = calculate_vegetation_indices(data);
ndvi = indices.NDVI;

% Classify health levels
health_categories = zeros(size(ndvi));
health_categories(ndvi < 0.2) = 1;
health_categories(ndvi >= 0.2 & ndvi < 0.4) = 2;
health_categories(ndvi >= 0.4 & ndvi < 0.6) = 3;
health_categories(ndvi >= 0.6) = 4;

% Calculate statistics
fprintf('NDVI Statistics:\n');
fprintf('  Mean: %.3f\n', mean(ndvi(:), 'omitnan'));
fprintf('  Min:  %.3f\n', min(ndvi(:)));
fprintf('  Max:  %.3f\n', max(ndvi(:)));

% Visualize
figure('Name', 'Tutorial Part 3: Vegetation Health');

subplot(1,3,1);
imshow(rgb);
title('Original Image (RGB)');

subplot(1,3,2);
imagesc(ndvi);
colorbar;
colormap(gca, jet);
caxis([-0.2, 0.8]);
title('NDVI (Vegetation Index)');
axis image;

subplot(1,3,3);
imagesc(health_categories);
colorbar;
colormap(gca, parula(4));
caxis([1, 4]);
title('Health Categories (1=poor, 4=excellent)');
axis image;

fprintf('\nFigure 2 created!\n');
fprintf('The NDVI map shows vegetation health using colors.\n');
fprintf('Press any key to continue to classification...\n');
pause;

%% Part 4: Automatic Classification
fprintf('\n--- Part 4: Automatic Land Cover Classification ---\n');
fprintf('We can use machine learning to automatically identify\n');
fprintf('different types of land cover (vegetation, soil, water, etc.)\n\n');

fprintf('Running K-means clustering (unsupervised learning)...\n');
num_classes = 3;
classified = classify_kmeans(data, num_classes);

% Analyze classes
fprintf('\nClassification complete! Found %d classes.\n', num_classes);
for c = 1:num_classes
    pixels = sum(classified(:) == c);
    percentage = (pixels / numel(classified)) * 100;
    fprintf('  Class %d: %d pixels (%.1f%%)\n', c, pixels, percentage);
end

% Visualize
figure('Name', 'Tutorial Part 4: Classification');

subplot(1,3,1);
imshow(rgb);
title('Original Image');

subplot(1,3,2);
imagesc(classified);
colorbar;
colormap(gca, parula(num_classes));
title('Classification Map');
axis image;

subplot(1,3,3);
% Create overlay
overlay = label2rgb(classified, 'jet', 'k', 'shuffle');
h = imshow(overlay);
set(h, 'AlphaData', 0.5);  % Semi-transparent
hold on;
imshow(rgb);
alpha(0.5);
title('Overlay on Original');

fprintf('\nFigure 3 created!\n');
fprintf('Each color represents a different land cover type.\n\n');

%% Summary
fprintf('\n=== Tutorial Complete! ===\n\n');
fprintf('What you learned:\n');
fprintf('1. ✓ Remote sensing data has multiple bands\n');
fprintf('2. ✓ Different materials reflect different wavelengths\n');
fprintf('3. ✓ NDVI measures vegetation health\n');
fprintf('4. ✓ Machine learning can classify land cover automatically\n\n');

fprintf('Next steps:\n');
fprintf('- Run other examples: example_agriculture, example_environmental\n');
fprintf('- Try changing parameters in this tutorial\n');
fprintf('- Explore the documentation in docs/\n');
fprintf('- Apply these techniques to real data!\n\n');

fprintf('Happy analyzing! 🛰️\n');
