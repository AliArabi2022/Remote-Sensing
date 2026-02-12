function data = simulate_hyperspectral_data(rows, cols, num_bands, varargin)
% SIMULATE_HYPERSPECTRAL_DATA Generate synthetic hyperspectral data
%
% Syntax:
%   data = simulate_hyperspectral_data(rows, cols, num_bands)
%   data = simulate_hyperspectral_data(rows, cols, num_bands, 'wavelengths', [400:10:2500])
%
% Input:
%   rows - Number of rows
%   cols - Number of columns
%   num_bands - Number of spectral bands (typically 100-200+)
%   varargin - Optional: 'noise', 'wavelengths', 'classes'
%
% Output:
%   data - Simulated hyperspectral data structure with:
%          .image (rows x cols x num_bands)
%          .wavelengths (1 x num_bands)
%
% Description:
%   Simulates hyperspectral imagery similar to IPS200 format

    p = inputParser;
    addParameter(p, 'noise', 0.02, @isnumeric);
    addParameter(p, 'classes', 5, @isnumeric);
    addParameter(p, 'wavelengths', linspace(400, 2500, num_bands), @isnumeric);
    parse(p, varargin{:});
    
    wavelengths = p.Results.wavelengths;
    if length(wavelengths) ~= num_bands
        wavelengths = linspace(min(wavelengths), max(wavelengths), num_bands);
    end
    
    % Initialize
    image = zeros(rows, cols, num_bands);
    
    % Create spatial classes
    num_classes = p.Results.classes;
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
    
    % Generate realistic spectral signatures
    for c = 1:num_classes
        % Create spectral signature based on material type
        signature = generate_spectral_signature(wavelengths, c);
        
        % Apply to all pixels of this class
        mask = (class_map == c);
        for b = 1:num_bands
            band = image(:,:,b);
            band(mask) = signature(b);
            image(:,:,b) = band;
        end
    end
    
    % Add spatial smoothing
    for b = 1:num_bands
        image(:,:,b) = imgaussfilt(image(:,:,b), 1.5);
    end
    
    % Add noise
    image = image + p.Results.noise * randn(size(image));
    image = max(0, min(1, image));
    
    % Package output
    data.image = image;
    data.wavelengths = wavelengths;
    data.type = 'hyperspectral';
    
    fprintf('Hyperspectral data simulated: %dx%dx%d (IPS200 compatible)\n', ...
            rows, cols, num_bands);
end

function signature = generate_spectral_signature(wavelengths, class_type)
    % Generate realistic spectral signatures for different materials
    
    num_bands = length(wavelengths);
    signature = zeros(1, num_bands);
    
    switch mod(class_type-1, 5) + 1
        case 1 % Green vegetation
            for i = 1:num_bands
                wl = wavelengths(i);
                if wl < 700
                    signature(i) = 0.05 + 0.05 * (wl - 400) / 300;
                elseif wl < 1300
                    signature(i) = 0.4 + 0.1 * sin((wl - 700) / 100);
                else
                    signature(i) = 0.3 + 0.05 * cos((wl - 1300) / 200);
                end
            end
            
        case 2 % Dry vegetation
            for i = 1:num_bands
                wl = wavelengths(i);
                signature(i) = 0.2 + 0.15 * (wl - 400) / 2100;
            end
            
        case 3 % Soil
            for i = 1:num_bands
                wl = wavelengths(i);
                signature(i) = 0.15 + 0.2 * (wl - 400) / 2100 + ...
                              0.05 * sin(wl / 200);
            end
            
        case 4 % Water
            for i = 1:num_bands
                wl = wavelengths(i);
                if wl < 900
                    signature(i) = 0.05 + 0.02 * (wl - 400) / 500;
                else
                    signature(i) = max(0.01, 0.07 - 0.06 * (wl - 900) / 1600);
                end
            end
            
        case 5 % Urban/Concrete
            for i = 1:num_bands
                wl = wavelengths(i);
                signature(i) = 0.25 + 0.05 * sin(wl / 300);
            end
    end
    
    signature = max(0, min(1, signature));
end
