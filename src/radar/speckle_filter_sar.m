function filtered = speckle_filter_sar(amplitude, filter_type, window_size)
% SPECKLE_FILTER_SAR Apply speckle filtering to SAR data
%
% Syntax:
%   filtered = speckle_filter_sar(amplitude, filter_type, window_size)
%
% Input:
%   amplitude - SAR amplitude image
%   filter_type - 'lee', 'frost', 'kuan', 'median'
%   window_size - Filter window size (odd number, default 5)
%
% Output:
%   filtered - Speckle-filtered amplitude image
%
% Description:
%   Applies various speckle reduction filters for SAR data

    if nargin < 3
        window_size = 5;
    end
    if nargin < 2
        filter_type = 'lee';
    end
    
    [rows, cols] = size(amplitude);
    filtered = amplitude;
    pad = floor(window_size/2);
    
    switch lower(filter_type)
        case 'lee'
            % Lee filter
            coeff_var = 0.25; % Coefficient of variation
            for i = pad+1:rows-pad
                for j = pad+1:cols-pad
                    window = amplitude(i-pad:i+pad, j-pad:j+pad);
                    mean_w = mean(window(:));
                    var_w = var(window(:));
                    W = var_w / (mean_w^2 * coeff_var^2 + var_w);
                    filtered(i,j) = mean_w + W * (amplitude(i,j) - mean_w);
                end
            end
            
        case 'frost'
            % Frost filter
            K = 1.0; % Damping factor
            for i = pad+1:rows-pad
                for j = pad+1:cols-pad
                    window = amplitude(i-pad:i+pad, j-pad:j+pad);
                    mean_w = mean(window(:));
                    var_w = var(window(:));
                    Ci = sqrt(var_w) / mean_w;
                    [X, Y] = meshgrid(-pad:pad, -pad:pad);
                    D = sqrt(X.^2 + Y.^2);
                    W = exp(-K * Ci * D);
                    W = W / sum(W(:));
                    filtered(i,j) = sum(sum(W .* window));
                end
            end
            
        case 'kuan'
            % Kuan filter
            coeff_var = 0.25;
            for i = pad+1:rows-pad
                for j = pad+1:cols-pad
                    window = amplitude(i-pad:i+pad, j-pad:j+pad);
                    mean_w = mean(window(:));
                    var_w = var(window(:));
                    Ci = sqrt(var_w) / mean_w;
                    W = (1 - coeff_var^2/Ci^2) / (1 + coeff_var^2);
                    W = max(0, W);
                    filtered(i,j) = mean_w + W * (amplitude(i,j) - mean_w);
                end
            end
            
        case 'median'
            % Median filter
            filtered = medfilt2(amplitude, [window_size window_size]);
            
        otherwise
            error('Unknown filter type: %s', filter_type);
    end
    
    fprintf('Speckle filtering applied: %s filter\n', filter_type);
end
