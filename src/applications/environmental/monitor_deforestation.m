function results = monitor_deforestation(image_before, image_after)
% MONITOR_DEFORESTATION Detect and quantify deforestation
%
% Syntax:
%   results = monitor_deforestation(image_before, image_after)
%
% Input:
%   image_before - Multispectral image before (rows x cols x bands)
%   image_after - Multispectral image after (rows x cols x bands)
%
% Output:
%   results - Structure with change map, deforestation statistics
%
% Description:
%   Environmental monitoring: Detects forest loss using change detection

    fprintf('\n=== Deforestation Monitoring ===\n');
    
    % Calculate NDVI for both images
    indices_before = calculate_vegetation_indices(image_before);
    indices_after = calculate_vegetation_indices(image_after);
    
    ndvi_before = indices_before.NDVI;
    ndvi_after = indices_after.NDVI;
    
    % Calculate NDVI change
    ndvi_change = ndvi_after - ndvi_before;
    
    % Detect forest areas (high NDVI in before image)
    forest_threshold = 0.5;
    forest_mask = ndvi_before > forest_threshold;
    
    % Detect significant decrease (deforestation)
    change_threshold = -0.2;
    deforestation_mask = (ndvi_change < change_threshold) & forest_mask;
    
    % Remove small patches (noise)
    deforestation_mask = bwareaopen(deforestation_mask, 30);
    
    % Label deforested regions
    [labeled, num_patches] = bwlabel(deforestation_mask);
    
    % Calculate statistics
    [rows, cols] = size(ndvi_before);
    forest_area = sum(forest_mask(:));
    deforested_area = sum(deforestation_mask(:));
    
    results.ndvi_before = ndvi_before;
    results.ndvi_after = ndvi_after;
    results.ndvi_change = ndvi_change;
    results.forest_mask = forest_mask;
    results.deforestation_mask = deforestation_mask;
    results.num_patches = num_patches;
    results.forest_area_pct = (forest_area / (rows*cols)) * 100;
    results.deforested_area_pct = (deforested_area / (rows*cols)) * 100;
    results.forest_loss_pct = (deforested_area / forest_area) * 100;
    
    fprintf('Forest coverage: %.2f%%\n', results.forest_area_pct);
    fprintf('Deforested area: %.2f%%\n', results.deforested_area_pct);
    fprintf('Forest loss: %.2f%%\n', results.forest_loss_pct);
    fprintf('Deforestation patches: %d\n', num_patches);
    
    % Visualize
    figure('Name', 'Deforestation Monitoring');
    
    subplot(2,3,1);
    imagesc(ndvi_before); colorbar; colormap(gca, 'jet');
    title('NDVI Before'); axis image;
    
    subplot(2,3,2);
    imagesc(ndvi_after); colorbar; colormap(gca, 'jet');
    title('NDVI After'); axis image;
    
    subplot(2,3,3);
    imagesc(ndvi_change); colorbar; colormap(gca, 'jet');
    title('NDVI Change'); axis image;
    
    subplot(2,3,4);
    imagesc(forest_mask); colormap(gca, 'gray');
    title('Original Forest'); axis image;
    
    subplot(2,3,5);
    imagesc(deforestation_mask); colormap(gca, 'hot');
    title('Deforestation'); axis image;
    
    subplot(2,3,6);
    imagesc(labeled); colorbar;
    title(sprintf('Patches (%d)', num_patches)); axis image;
    
    fprintf('Deforestation monitoring completed.\n');
end
