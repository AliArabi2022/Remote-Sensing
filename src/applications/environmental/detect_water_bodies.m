function results = detect_water_bodies(multispectral_data, threshold)
% DETECT_WATER_BODIES Detect and map water bodies
%
% Syntax:
%   results = detect_water_bodies(multispectral_data)
%   results = detect_water_bodies(multispectral_data, threshold)
%
% Input:
%   multispectral_data - Multispectral image (rows x cols x bands)
%   threshold - NDWI threshold for water detection (default: 0.3)
%
% Output:
%   results - Structure with water mask, area, and statistics
%
% Description:
%   Environmental monitoring: Detects water bodies using NDWI

    if nargin < 2
        threshold = 0.3;
    end
    
    fprintf('\n=== Water Body Detection ===\n');
    
    % Calculate NDWI
    indices = calculate_vegetation_indices(multispectral_data);
    ndwi = indices.NDWI;
    
    % Detect water (NDWI > threshold)
    water_mask = ndwi > threshold;
    
    % Remove small objects (noise reduction)
    water_mask = bwareaopen(water_mask, 50);
    
    % Label connected components
    [labeled, num_bodies] = bwlabel(water_mask);
    
    % Calculate areas
    props = regionprops(labeled, 'Area', 'Centroid');
    areas = [props.Area];
    
    % Statistics
    [rows, cols] = size(ndwi);
    total_pixels = rows * cols;
    water_pixels = sum(water_mask(:));
    
    results.water_mask = water_mask;
    results.labeled = labeled;
    results.num_water_bodies = num_bodies;
    results.water_coverage_pct = (water_pixels / total_pixels) * 100;
    results.body_areas = areas;
    results.ndwi = ndwi;
    
    fprintf('Water bodies detected: %d\n', num_bodies);
    fprintf('Water coverage: %.2f%%\n', results.water_coverage_pct);
    if num_bodies > 0
        fprintf('Largest water body: %d pixels\n', max(areas));
    end
    
    % Visualize
    figure('Name', 'Water Body Detection');
    
    subplot(2,2,1);
    imagesc(ndwi); colorbar; colormap(gca, 'jet');
    title('NDWI'); axis image;
    
    subplot(2,2,2);
    imagesc(water_mask); colormap(gca, 'gray');
    title('Water Mask'); axis image;
    
    subplot(2,2,3);
    imagesc(labeled); colorbar;
    title(sprintf('Labeled (%d bodies)', num_bodies)); axis image;
    
    subplot(2,2,4);
    if num_bodies > 0
        histogram(areas, min(20, num_bodies));
        xlabel('Area (pixels)'); ylabel('Count');
        title('Water Body Size Distribution');
    else
        text(0.5, 0.5, 'No water bodies detected', ...
             'HorizontalAlignment', 'center');
        axis off;
    end
    
    fprintf('Water body detection completed.\n');
end
