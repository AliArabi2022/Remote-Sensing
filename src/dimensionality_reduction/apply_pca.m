function [reduced, transform] = apply_pca(data, num_components)
% APPLY_PCA Apply Principal Component Analysis for dimensionality reduction
%
% Syntax:
%   [reduced, transform] = apply_pca(data, num_components)
%
% Input:
%   data - Input data (rows x cols x bands)
%   num_components - Number of components to retain
%
% Output:
%   reduced - Reduced data (rows x cols x num_components)
%   transform - Transformation structure with eigenvectors and explained variance
%
% Description:
%   Applies PCA to reduce dimensionality while retaining maximum variance

    [rows, cols, bands] = size(data);
    
    % Reshape to 2D matrix
    data_2d = reshape(data, rows*cols, bands);
    
    % Standardize data
    data_mean = mean(data_2d, 1);
    data_std = std(data_2d, 0, 1);
    data_standardized = (data_2d - data_mean) ./ (data_std + eps);
    
    % Compute PCA
    [coeff, score, latent, ~, explained] = pca(data_standardized, 'NumComponents', num_components);
    
    % Reshape back to image format
    reduced = reshape(score, rows, cols, num_components);
    
    % Store transformation
    transform.coeff = coeff;
    transform.latent = latent;
    transform.explained = explained;
    transform.mean = data_mean;
    transform.std = data_std;
    
    fprintf('PCA applied: %d -> %d components, %.2f%% variance retained\n', ...
            bands, num_components, sum(explained));
end
