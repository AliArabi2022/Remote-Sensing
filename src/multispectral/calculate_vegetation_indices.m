function indices = calculate_vegetation_indices(data)
% CALCULATE_VEGETATION_INDICES Compute common vegetation indices
%
% Syntax:
%   indices = calculate_vegetation_indices(data)
%
% Input:
%   data - Multispectral data (rows x cols x bands)
%          Assumes band order: Blue, Green, Red, NIR, ...
%
% Output:
%   indices - Structure with NDVI, EVI, SAVI, NDWI
%
% Description:
%   Calculates vegetation indices from multispectral data

    if size(data, 3) < 4
        error('At least 4 bands required (Blue, Green, Red, NIR)');
    end
    
    % Extract bands
    blue = double(data(:,:,1));
    green = double(data(:,:,2));
    red = double(data(:,:,3));
    nir = double(data(:,:,4));
    
    % NDVI - Normalized Difference Vegetation Index
    indices.NDVI = (nir - red) ./ (nir + red + eps);
    
    % EVI - Enhanced Vegetation Index
    L = 1; C1 = 6; C2 = 7.5; G = 2.5;
    indices.EVI = G * (nir - red) ./ (nir + C1*red - C2*blue + L);
    
    % SAVI - Soil Adjusted Vegetation Index
    L = 0.5;
    indices.SAVI = ((nir - red) ./ (nir + red + L)) * (1 + L);
    
    % NDWI - Normalized Difference Water Index
    indices.NDWI = (green - nir) ./ (green + nir + eps);
    
    fprintf('Vegetation indices calculated: NDVI, EVI, SAVI, NDWI\n');
end
