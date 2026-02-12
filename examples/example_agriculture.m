%% Remote Sensing Agricultural Application Example
% This comprehensive example demonstrates agricultural applications:
% 1. Multispectral data acquisition
% 2. Crop health analysis
% 3. Yield estimation
% 4. Precision agriculture recommendations

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Agricultural Application Example ===\n\n');

%% 1. Simulate Agricultural Field
fprintf('Step 1: Simulating agricultural field data...\n');
rows = 300;
cols = 300;
num_bands = 6;  % Blue, Green, Red, NIR, SWIR1, SWIR2

% Simulate field with varied crop health
field_data = simulate_multispectral_data(rows, cols, num_bands, ...
                                        'noise', 0.08, ...
                                        'classes', 5);

fprintf('Field simulated: %d x %d pixels\n', rows, cols);

%% 2. Crop Health Analysis
fprintf('\nStep 2: Analyzing crop health...\n');
health_results = analyze_crop_health(field_data);

%% 3. Yield Estimation
fprintf('\nStep 3: Estimating crop yield...\n');
field_area_ha = 50;  % 50 hectares
yield_results = estimate_yield(field_data, field_area_ha);

%% 4. Identify Problem Areas
fprintf('\nStep 4: Identifying problem areas...\n');

% Areas with low vegetation vigor
stressed_mask = health_results.health_map == 1;
low_vigor_mask = health_results.health_map == 2;

% Label problem regions
[labeled_stressed, num_stressed] = bwlabel(bwareaopen(stressed_mask, 50));
[labeled_low, num_low] = bwlabel(bwareaopen(low_vigor_mask, 50));

fprintf('Stressed regions: %d\n', num_stressed);
fprintf('Low vigor regions: %d\n', num_low);

% Visualize problem areas
figure('Name', 'Problem Area Identification');

subplot(2,2,1);
rgb = field_data(:,:,1:3);
rgb = mat2gray(rgb);
imshow(rgb);
title('RGB Composite');

subplot(2,2,2);
imagesc(health_results.indices.NDVI); colorbar; colormap(gca, jet);
title('NDVI Map');
axis image;

subplot(2,2,3);
overlay = zeros(rows, cols, 3);
overlay(:,:,1) = mat2gray(field_data(:,:,1));
overlay(:,:,2) = mat2gray(field_data(:,:,2));
overlay(:,:,3) = mat2gray(field_data(:,:,3));
overlay(:,:,1) = overlay(:,:,1) + double(stressed_mask) * 0.5;
imshow(overlay);
title('Stressed Areas (Red Overlay)');

subplot(2,2,4);
imagesc(yield_results.yield_map); colorbar; colormap(gca, jet);
title('Yield Prediction Map');
axis image;

%% 5. Generate Management Zones
fprintf('\nStep 5: Creating management zones...\n');

% Create management zones based on yield potential
management_zones = zeros(rows, cols);
management_zones(yield_results.yield_map < 2) = 1;  % Low yield
management_zones(yield_results.yield_map >= 2 & yield_results.yield_map < 4) = 2;  % Medium
management_zones(yield_results.yield_map >= 4 & yield_results.yield_map < 6) = 3;  % High
management_zones(yield_results.yield_map >= 6) = 4;  % Very high

figure('Name', 'Management Zones');
imagesc(management_zones); colorbar;
colormap(parula(4));
title('Management Zones');
axis image;

% Calculate zone statistics
for zone = 1:4
    zone_area = sum(management_zones(:) == zone) / (rows*cols) * field_area_ha;
    fprintf('Zone %d area: %.2f ha\n', zone, zone_area);
end

%% 6. Recommendations
fprintf('\n=== Precision Agriculture Recommendations ===\n');

% Water stress areas
water_stress = health_results.indices.NDWI > 0.1;  % Inverted logic for demo
water_stress_pct = sum(water_stress(:)) / numel(water_stress) * 100;

% Nutrient deficiency (low EVI areas with moderate NDVI)
nutrient_deficient = (health_results.indices.EVI < 0.3) & ...
                    (health_results.indices.NDVI > 0.3);
nutrient_deficient_pct = sum(nutrient_deficient(:)) / numel(nutrient_deficient) * 100;

fprintf('\n--- Field Assessment ---\n');
fprintf('Total field area: %.1f ha\n', field_area_ha);
fprintf('Total estimated yield: %.2f tons\n', yield_results.total_yield_tons);
fprintf('Average yield: %.2f tons/ha\n', yield_results.average_yield_tons_per_ha);
fprintf('\n--- Problem Areas ---\n');
fprintf('Stressed vegetation: %.1f%% (%.2f ha)\n', ...
        health_results.stats.stressed_area_pct, ...
        health_results.stats.stressed_area_pct/100 * field_area_ha);
fprintf('Water stress indicators: %.1f%%\n', water_stress_pct);
fprintf('Nutrient deficiency indicators: %.1f%%\n', nutrient_deficient_pct);

fprintf('\n--- Recommendations ---\n');
if health_results.stats.stressed_area_pct > 10
    fprintf('- Priority irrigation needed in %d stressed regions\n', num_stressed);
end
if nutrient_deficient_pct > 15
    fprintf('- Variable rate fertilizer application recommended\n');
end
if yield_results.average_yield_tons_per_ha < 4
    fprintf('- Overall yield below average - investigate soil conditions\n');
end
fprintf('- Apply precision farming techniques in 4 management zones\n');

%% Summary
fprintf('\n=== Analysis Complete ===\n');
fprintf('Agricultural monitoring and analysis completed successfully.\n');
fprintf('Use results for precision agriculture decision making.\n');
