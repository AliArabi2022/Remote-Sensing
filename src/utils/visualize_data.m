function visualize_data(data, data_type, varargin)
% VISUALIZE_DATA Visualize remote sensing data
%
% Syntax:
%   visualize_data(data, data_type)
%   visualize_data(data, data_type, 'title', 'My Title')
%
% Input:
%   data - Data to visualize (2D or 3D array)
%   data_type - Type: 'multispectral', 'hyperspectral', 'radar', 'lidar'
%   varargin - Optional name-value pairs: 'title', 'colormap', 'bands'
%
% Description:
%   General purpose visualization for various remote sensing data types

    p = inputParser;
    addParameter(p, 'title', 'Remote Sensing Data', @ischar);
    addParameter(p, 'colormap', 'jet', @ischar);
    addParameter(p, 'bands', [], @isnumeric);
    parse(p, varargin{:});
    
    figure;
    
    switch lower(data_type)
        case 'multispectral'
            if ndims(data) == 3 && size(data, 3) >= 3
                % RGB composite
                if isempty(p.Results.bands)
                    rgb = data(:,:,1:3);
                else
                    rgb = data(:,:,p.Results.bands(1:3));
                end
                rgb = mat2gray(rgb);
                imshow(rgb);
            else
                imagesc(data);
                colorbar;
            end
            
        case 'hyperspectral'
            if ndims(data) == 3
                % Show RGB composite if enough bands
                if size(data, 3) >= 50
                    % Typical hyperspectral: select R, G, B bands
                    rgb = data(:,:,[30, 20, 10]);
                    rgb = mat2gray(rgb);
                    imshow(rgb);
                else
                    % Show first band
                    imagesc(data(:,:,1));
                    colorbar;
                end
            else
                imagesc(data);
                colorbar;
            end
            
        case 'radar'
            imagesc(20*log10(abs(data) + eps)); % dB scale
            colormap(gray);
            colorbar;
            title([p.Results.title ' (dB)']);
            
        case 'lidar'
            if ndims(data) == 2
                imagesc(data);
                colorbar;
                title([p.Results.title ' - Elevation']);
            else
                scatter3(data(:,1), data(:,2), data(:,3), 1, data(:,3), 'filled');
                colorbar;
                xlabel('X'); ylabel('Y'); zlabel('Z');
            end
            
        otherwise
            imagesc(data);
            colorbar;
    end
    
    if ~strcmp(data_type, 'radar') && ~strcmp(data_type, 'lidar')
        title(p.Results.title);
    end
    
    axis image;
end
