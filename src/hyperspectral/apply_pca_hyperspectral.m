function [score, latent, explained] = apply_pca_hyperspectral(data, num_components)
% APPLY_PCA_HYPERSPECTRAL Apply PCA to hyperspectral data
%
% Syntax:
%   [score, latent, explained] = apply_pca_hyperspectral(data, num_components)
%
% Input:
%   data - Hyperspectral image (rows x cols x bands)
%   num_components - Number of principal components to retain
%
% Output:
%   score - PCA scores (rows x cols x num_components)
%   latent - Eigenvalues
%   explained - Variance explained by each component
%
% Description:
%   Applies PCA for dimensionality reduction of hyperspectral data

    [rows, cols, bands] = size(data);
    
    % Reshape to 2D matrix (pixels x bands)
    data_2d = reshape(data, rows*cols, bands);
    
    % Center the data
    data_mean = mean(data_2d, 1);
    data_centered = data_2d - data_mean;
    
    % Apply PCA
    [coeff, score_2d, latent, ~, explained] = pca(data_centered, 'NumComponents', num_components);
    
    % Reshape back to image format
    score = reshape(score_2d, rows, cols, num_components);
    
    fprintf('PCA applied: %d bands reduced to %d components\n', bands, num_components);
    fprintf('Variance explained: %.2f%%\n', sum(explained));
end
