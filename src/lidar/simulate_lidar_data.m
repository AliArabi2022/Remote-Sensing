function data = simulate_lidar_data(rows, cols, varargin)
% SIMULATE_LIDAR_DATA Generate synthetic LiDAR elevation data
%
% Syntax:
%   data = simulate_lidar_data(rows, cols)
%   data = simulate_lidar_data(rows, cols, 'terrain_type', 'hilly')
%
% Input:
%   rows - Number of rows
%   cols - Number of columns
%   varargin - Optional: 'terrain_type' ('flat', 'hilly', 'mountain'), 
%              'vegetation', 'buildings'
%
% Output:
%   data - LiDAR data structure with:
%          .elevation (rows x cols) - Digital Elevation Model
%          .intensity (rows x cols) - Return intensity
%          .point_cloud (optional) - 3D point cloud
%
% Description:
%   Simulates LiDAR data with terrain, vegetation, and buildings

    p = inputParser;
    addParameter(p, 'terrain_type', 'hilly', @ischar);
    addParameter(p, 'vegetation', true, @islogical);
    addParameter(p, 'buildings', 2, @isnumeric);
    addParameter(p, 'noise', 0.05, @isnumeric);
    parse(p, varargin{:});
    
    [X, Y] = meshgrid(1:cols, 1:rows);
    
    % Generate base terrain
    switch lower(p.Results.terrain_type)
        case 'flat'
            elevation = 100 + 2 * randn(rows, cols);
            
        case 'hilly'
            elevation = 100 + 20 * sin(X/30) .* cos(Y/25) + ...
                       10 * sin(X/15) .* sin(Y/20);
            
        case 'mountain'
            cx = cols/2; cy = rows/2;
            elevation = 50 + 100 * exp(-((X-cx).^2 + (Y-cy).^2) / (rows*cols/10));
            elevation = elevation + 10 * sin(X/10) .* cos(Y/10);
            
        otherwise
            elevation = 100 * ones(rows, cols);
    end
    
    % Add vegetation (random trees)
    if p.Results.vegetation
        num_trees = round(rows * cols / 100);
        for t = 1:num_trees
            tx = randi([5, cols-5]);
            ty = randi([5, rows-5]);
            tree_height = 5 + 10*rand();
            tree_radius = 2 + 3*rand();
            
            % Use bounding box for efficiency
            x_min = max(1, round(tx - tree_radius));
            x_max = min(cols, round(tx + tree_radius));
            y_min = max(1, round(ty - tree_radius));
            y_max = min(rows, round(ty + tree_radius));
            
            % Apply only within bounding box
            [X_local, Y_local] = meshgrid(x_min:x_max, y_min:y_max);
            tree_mask = ((X_local-tx).^2 + (Y_local-ty).^2) <= tree_radius^2;
            elevation(y_min:y_max, x_min:x_max) = ...
                elevation(y_min:y_max, x_min:x_max) + tree_mask * tree_height;
        end
    end
    
    % Add buildings
    for b = 1:p.Results.buildings
        bx = randi([10, cols-20]);
        by = randi([10, rows-20]);
        bw = 5 + randi([5, 15]);
        bh = 5 + randi([5, 15]);
        building_height = 10 + 20*rand();
        
        building_mask = (X >= bx) & (X <= bx+bw) & (Y >= by) & (Y <= by+bh);
        elevation(building_mask) = elevation(building_mask) + building_height;
    end
    
    % Add noise
    elevation = elevation + p.Results.noise * randn(rows, cols);
    
    % Generate intensity (return strength)
    intensity = 0.5 + 0.3*randn(rows, cols);
    intensity = max(0, min(1, intensity));
    
    % Package output
    data.elevation = elevation;
    data.intensity = intensity;
    data.type = 'LiDAR';
    data.resolution = 1.0; % meters per pixel
    
    fprintf('LiDAR data simulated: %dx%d, Terrain: %s\n', ...
            rows, cols, p.Results.terrain_type);
end
