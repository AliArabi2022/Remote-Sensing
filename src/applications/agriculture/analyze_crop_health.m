function results = analyze_crop_health(multispectral_data)
% ANALYZE_CROP_HEALTH Analyze crop health using multispectral data
%
% Syntax:
%   results = analyze_crop_health(multispectral_data)
%
% Input:
%   multispectral_data - Multispectral image (rows x cols x bands)
%                        Expected bands: Blue, Green, Red, NIR
%
% Output:
%   results - Structure with vegetation indices, health map, statistics
%
% Description:
%   Agricultural application: Analyzes crop health using vegetation indices

    fprintf('\n=== Crop Health Analysis ===\n');
    
    % Calculate vegetation indices
    indices = calculate_vegetation_indices(multispectral_data);
    
    % NDVI-based health classification
    ndvi = indices.NDVI;
    health_map = zeros(size(ndvi));
    
    % Classify health levels
    health_map(ndvi < 0.2) = 1;  % Bare soil / stressed
    health_map(ndvi >= 0.2 & ndvi < 0.4) = 2;  % Low vigor
    health_map(ndvi >= 0.4 & ndvi < 0.6) = 3;  % Moderate vigor
    health_map(ndvi >= 0.6) = 4;  % High vigor
    
    % Calculate statistics
    stats.mean_ndvi = mean(ndvi(:), 'omitnan');
    stats.std_ndvi = std(ndvi(:), 'omitnan');
    stats.healthy_area_pct = sum(health_map(:) >= 3) / numel(health_map) * 100;
    stats.stressed_area_pct = sum(health_map(:) == 1) / numel(health_map) * 100;
    
    % Package results
    results.indices = indices;
    results.health_map = health_map;
    results.stats = stats;
    results.health_labels = {'Stressed', 'Low Vigor', 'Moderate Vigor', 'High Vigor'};
    
    % Display results
    fprintf('Mean NDVI: %.3f\n', stats.mean_ndvi);
    fprintf('Healthy area: %.1f%%\n', stats.healthy_area_pct);
    fprintf('Stressed area: %.1f%%\n', stats.stressed_area_pct);
    
    % Visualize
    figure('Name', 'Crop Health Analysis');
    
    subplot(2,2,1);
    imagesc(indices.NDVI); colorbar; colormap(gca, 'jet');
    title('NDVI'); axis image;
    
    subplot(2,2,2);
    imagesc(indices.EVI); colorbar; colormap(gca, 'jet');
    title('EVI'); axis image;
    
    subplot(2,2,3);
    imagesc(health_map); colorbar;
    colormap(gca, parula(4));
    title('Health Map'); axis image;
    
    subplot(2,2,4);
    histogram(ndvi(:), 50);
    xlabel('NDVI'); ylabel('Frequency');
    title('NDVI Distribution');
    
    fprintf('Crop health analysis completed.\n');
end
