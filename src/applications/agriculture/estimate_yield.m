function results = estimate_yield(multispectral_data, field_area_ha)
% ESTIMATE_YIELD Estimate crop yield using remote sensing data
%
% Syntax:
%   results = estimate_yield(multispectral_data, field_area_ha)
%
% Input:
%   multispectral_data - Multispectral image (rows x cols x bands)
%   field_area_ha - Field area in hectares
%
% Output:
%   results - Structure with yield estimates and spatial distribution
%
% Description:
%   Agricultural application: Estimates crop yield based on vegetation indices

    fprintf('\n=== Crop Yield Estimation ===\n');
    
    % Calculate NDVI
    indices = calculate_vegetation_indices(multispectral_data);
    ndvi = indices.NDVI;
    
    % Empirical yield model (example: wheat)
    % Yield (tons/ha) = a + b * NDVI
    a = 0.5;  % Baseline yield
    b = 8.0;  % NDVI coefficient
    
    % Calculate pixel-wise yield
    yield_per_pixel = a + b * ndvi;
    yield_per_pixel(ndvi < 0.2) = 0;  % No crop in bare areas
    yield_per_pixel = max(0, yield_per_pixel);
    
    % Calculate total yield
    [rows, cols] = size(ndvi);
    pixel_area_ha = field_area_ha / (rows * cols);
    total_yield = sum(yield_per_pixel(:) * pixel_area_ha);
    
    % Statistics
    results.yield_map = yield_per_pixel;
    results.total_yield_tons = total_yield;
    results.average_yield_tons_per_ha = mean(yield_per_pixel(:), 'omitnan');
    results.field_area_ha = field_area_ha;
    
    fprintf('Total estimated yield: %.2f tons\n', total_yield);
    fprintf('Average yield: %.2f tons/ha\n', results.average_yield_tons_per_ha);
    
    % Visualize
    figure('Name', 'Yield Estimation');
    
    subplot(1,2,1);
    imagesc(yield_per_pixel); colorbar;
    colormap(gca, 'jet');
    title('Yield Map (tons/ha)'); axis image;
    
    subplot(1,2,2);
    histogram(yield_per_pixel(:), 30);
    xlabel('Yield (tons/ha)'); ylabel('Frequency');
    title('Yield Distribution');
    
    fprintf('Yield estimation completed.\n');
end
