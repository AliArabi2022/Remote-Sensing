function enhanced = enhance_image(data, method, varargin)
% ENHANCE_IMAGE Apply enhancement techniques to remote sensing data
%
% Syntax:
%   enhanced = enhance_image(data, method)
%   enhanced = enhance_image(data, method, 'param', value)
%
% Input:
%   data - Input image (2D or 3D array)
%   method - Enhancement method: 'histogram_equalization', 'contrast_stretch',
%            'gaussian_filter', 'median_filter', 'adaptive_filter'
%   varargin - Method-specific parameters
%
% Output:
%   enhanced - Enhanced image
%
% Description:
%   Applies various image enhancement techniques for remote sensing

    p = inputParser;
    addParameter(p, 'sigma', 1.0, @isnumeric);
    addParameter(p, 'window_size', 5, @isnumeric);
    addParameter(p, 'clip_limit', 0.01, @isnumeric);
    parse(p, varargin{:});
    
    [rows, cols, bands] = size(data);
    enhanced = zeros(size(data));
    
    for b = 1:bands
        band = data(:,:,b);
        
        switch lower(method)
            case 'histogram_equalization'
                % Histogram equalization
                enhanced(:,:,b) = histeq(mat2gray(band));
                
            case 'contrast_stretch'
                % Linear contrast stretch
                plow = prctile(band(:), 2);
                phigh = prctile(band(:), 98);
                enhanced(:,:,b) = (band - plow) / (phigh - plow);
                enhanced(:,:,b) = max(0, min(1, enhanced(:,:,b)));
                
            case 'gaussian_filter'
                % Gaussian smoothing
                enhanced(:,:,b) = imgaussfilt(band, p.Results.sigma);
                
            case 'median_filter'
                % Median filtering
                enhanced(:,:,b) = medfilt2(band, [p.Results.window_size, p.Results.window_size]);
                
            case 'adaptive_filter'
                % Adaptive histogram equalization
                enhanced(:,:,b) = adapthisteq(mat2gray(band), 'ClipLimit', p.Results.clip_limit);
                
            case 'bilateral_filter'
                % Bilateral filter (edge-preserving)
                sigma_spatial = p.Results.sigma;
                sigma_range = 0.1;
                enhanced(:,:,b) = imbilatfilt(band, sigma_range, sigma_spatial);
                
            otherwise
                error('Unknown enhancement method: %s', method);
        end
    end
    
    fprintf('Image enhancement applied: %s\n', method);
end
