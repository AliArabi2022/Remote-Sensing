%% Remote Sensing Environmental Monitoring Example
% This comprehensive example demonstrates environmental monitoring:
% 1. Multi-temporal analysis
% 2. Water body detection
% 3. Deforestation monitoring
% 4. Change detection

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Environmental Monitoring Example ===\n\n');

%% 1. Simulate Multi-Temporal Data
fprintf('Step 1: Simulating multi-temporal data...\n');
rows = 250;
cols = 250;
num_bands = 6;

% Time 1 (Before)
fprintf('Generating baseline image (Time 1)...\n');
image_t1 = simulate_multispectral_data(rows, cols, num_bands, ...
                                       'noise', 0.05, ...
                                       'classes', 4);

% Time 2 (After) - with some changes
fprintf('Generating later image (Time 2)...\n');
image_t2 = simulate_multispectral_data(rows, cols, num_bands, ...
                                       'noise', 0.05, ...
                                       'classes', 4);

% Simulate deforestation in a region
deforest_region = false(rows, cols);
deforest_region(50:120, 50:120) = true;
deforest_region = imgaussfilt(double(deforest_region), 10) > 0.3;

% Apply deforestation effect
for b = 1:num_bands
    band = image_t2(:,:,b);
    if b == 4  % NIR band - reduce significantly
        band(deforest_region) = band(deforest_region) * 0.3;
    else
        band(deforest_region) = band(deforest_region) * 0.7;
    end
    image_t2(:,:,b) = band;
end

%% 2. Water Body Detection
fprintf('\nStep 2: Detecting water bodies...\n');
water_results_t1 = detect_water_bodies(image_t1, 0.3);
water_results_t2 = detect_water_bodies(image_t2, 0.3);

% Compare water coverage
fprintf('Water coverage change: %.2f%% -> %.2f%%\n', ...
        water_results_t1.water_coverage_pct, ...
        water_results_t2.water_coverage_pct);

%% 3. Deforestation Monitoring
fprintf('\nStep 3: Monitoring deforestation...\n');
deforest_results = monitor_deforestation(image_t1, image_t2);

%% 4. General Change Detection
fprintf('\nStep 4: Performing change detection...\n');

% Calculate change vector magnitude
change_vector = zeros(rows, cols);
for b = 1:num_bands
    diff = image_t2(:,:,b) - image_t1(:,:,b);
    change_vector = change_vector + diff.^2;
end
change_magnitude = sqrt(change_vector);

% Threshold for significant change
change_threshold = prctile(change_magnitude(:), 95);
significant_change = change_magnitude > change_threshold;

% Remove small changes
significant_change = bwareaopen(significant_change, 30);

figure('Name', 'Change Detection');

subplot(2,3,1);
rgb1 = image_t1(:,:,[3,2,1]);
imshow(mat2gray(rgb1));
title('Time 1 (Before)');

subplot(2,3,2);
rgb2 = image_t2(:,:,[3,2,1]);
imshow(mat2gray(rgb2));
title('Time 2 (After)');

subplot(2,3,3);
imagesc(change_magnitude); colorbar; colormap(gca, hot);
title('Change Magnitude');
axis image;

subplot(2,3,4);
imagesc(significant_change); colormap(gca, hot);
title('Significant Changes');
axis image;

subplot(2,3,5);
imagesc(deforest_results.deforestation_mask); colormap(gca, hot);
title('Deforestation Areas');
axis image;

subplot(2,3,6);
% Combined change map
combined = zeros(rows, cols, 3);
combined(:,:,1) = mat2gray(image_t2(:,:,3));  % Base: Red band
combined(:,:,2) = mat2gray(image_t2(:,:,2));  % Base: Green band
combined(:,:,3) = mat2gray(image_t2(:,:,1));  % Base: Blue band
combined(:,:,1) = combined(:,:,1) + double(deforest_results.deforestation_mask);
imshow(combined);
title('RGB with Deforestation Overlay');

%% 5. Land Cover Change Statistics
fprintf('\nStep 5: Calculating land cover change statistics...\n');

% Classify both time periods
num_classes = 5;
class_t1 = classify_kmeans(image_t1, num_classes);
class_t2 = classify_kmeans(image_t2, num_classes);

% Change matrix
change_matrix = zeros(num_classes, num_classes);
for i = 1:num_classes
    for j = 1:num_classes
        change_matrix(i,j) = sum(class_t1(:) == i & class_t2(:) == j);
    end
end

% Normalize to percentages
change_matrix_pct = change_matrix / numel(class_t1) * 100;

fprintf('\nLand Cover Change Matrix (%% of total area):\n');
fprintf('From\\To: ');
for j = 1:num_classes
    fprintf('Class%d  ', j);
end
fprintf('\n');
for i = 1:num_classes
    fprintf('Class%d:  ', i);
    for j = 1:num_classes
        fprintf('%6.2f  ', change_matrix_pct(i,j));
    end
    fprintf('\n');
end

%% 6. Environmental Impact Assessment
fprintf('\n=== Environmental Impact Assessment ===\n');

total_change_area = sum(significant_change(:)) / numel(significant_change) * 100;
forest_loss = deforest_results.forest_loss_pct;
water_change = water_results_t2.water_coverage_pct - water_results_t1.water_coverage_pct;

fprintf('\n--- Change Summary ---\n');
fprintf('Total area with significant change: %.2f%%\n', total_change_area);
fprintf('Forest loss: %.2f%%\n', forest_loss);
fprintf('Water coverage change: %+.2f%%\n', water_change);
fprintf('Deforestation patches detected: %d\n', deforest_results.num_patches);

fprintf('\n--- Environmental Concerns ---\n');
if forest_loss > 5
    fprintf('! HIGH: Significant forest loss detected (%.1f%%)\n', forest_loss);
    fprintf('  Recommendation: Immediate investigation and conservation action\n');
elseif forest_loss > 2
    fprintf('! MEDIUM: Moderate forest loss detected (%.1f%%)\n', forest_loss);
    fprintf('  Recommendation: Monitor and assess causes\n');
end

if abs(water_change) > 2
    if water_change > 0
        fprintf('! Water bodies increased by %.1f%%\n', water_change);
        fprintf('  Possible causes: Flooding, reservoir filling\n');
    else
        fprintf('! Water bodies decreased by %.1f%%\n', abs(water_change));
        fprintf('  Possible causes: Drought, water extraction\n');
    end
end

%% Summary
fprintf('\n=== Monitoring Complete ===\n');
fprintf('Environmental monitoring and change detection completed.\n');
fprintf('Regular monitoring recommended for sustainable management.\n');
