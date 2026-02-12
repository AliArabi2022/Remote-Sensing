function data = simulate_multispectral_data(rows, cols, num_bands, varargin)
% SIMULATE_MULTISPECTRAL_DATA Generate synthetic multispectral data
%
% Syntax:
%   data = simulate_multispectral_data(rows, cols, num_bands)
%   data = simulate_multispectral_data(rows, cols, num_bands, 'noise', 0.1)
%
% Input:
%   rows - Number of rows
%   cols - Number of columns
%   num_bands - Number of spectral bands (typically 4-12)
%   varargin - Optional: 'noise' (noise level 0-1), 'classes' (number of classes)
%
% Output:
%   data - Simulated multispectral data (rows x cols x num_bands)
%
% Description:
%   Simulates multispectral imagery with multiple land cover classes

    p = inputParser;
    addParameter(p, 'noise', 0.05, @isnumeric);
    addParameter(p, 'classes', 4, @isnumeric);
    parse(p, varargin{:});
    
    % Initialize data
    data = zeros(rows, cols, num_bands);
    
    % Create different land cover regions
    num_classes = p.Results.classes;
    [X, Y] = meshgrid(1:cols, 1:rows);
    
    % Generate class map using Voronoi-like regions
    class_centers = rand(num_classes, 2);
    class_centers(:,1) = class_centers(:,1) * rows;
    class_centers(:,2) = class_centers(:,2) * cols;
    
    class_map = zeros(rows, cols);
    for i = 1:rows
        for j = 1:cols
            distances = sqrt((class_centers(:,1) - i).^2 + (class_centers(:,2) - j).^2);
            [~, class_map(i,j)] = min(distances);
        end
    end
    
    % Define spectral signatures for each class
    % Typical values for vegetation, water, soil, urban
    signatures = [
        0.1, 0.15, 0.3, 0.5, 0.4, 0.3;  % Vegetation (low visible, high NIR)
        0.05, 0.08, 0.1, 0.05, 0.03, 0.02; % Water (low reflectance)
        0.3, 0.35, 0.4, 0.35, 0.3, 0.25;   % Soil (moderate, increasing)
        0.2, 0.25, 0.28, 0.25, 0.22, 0.20  % Urban (moderate, flat)
    ];
    
    % Extend or reduce signatures to match num_bands
    if num_bands ~= size(signatures, 2)
        signatures_new = zeros(num_classes, num_bands);
        for c = 1:num_classes
            signatures_new(c,:) = interp1(linspace(1, num_bands, size(signatures,2)), ...
                                          signatures(c,:), 1:num_bands, 'pchip');
        end
        signatures = signatures_new;
    end
    
    % Fill data based on class map
    for b = 1:num_bands
        band = zeros(rows, cols);
        for c = 1:num_classes
            if c <= size(signatures, 1)
                band(class_map == c) = signatures(c, b);
            else
                band(class_map == c) = rand();
            end
        end
        
        % Add spatial smoothing
        band = imgaussfilt(band, 2);
        
        % Add noise
        band = band + p.Results.noise * randn(rows, cols);
        band = max(0, min(1, band));
        
        data(:,:,b) = band;
    end
    
    fprintf('Multispectral data simulated: %dx%dx%d\n', rows, cols, num_bands);
end
