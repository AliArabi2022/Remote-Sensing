function [reduced, noise] = apply_mnf(data, num_components)
% APPLY_MNF Apply Minimum Noise Fraction transformation
%
% Syntax:
%   [reduced, noise] = apply_mnf(data, num_components)
%
% Input:
%   data - Input data (rows x cols x bands)
%   num_components - Number of components to retain
%
% Output:
%   reduced - MNF-transformed data (rows x cols x num_components)
%   noise - Noise covariance estimate
%
% Description:
%   Applies MNF transformation to separate signal from noise

    [rows, cols, bands] = size(data);
    
    % Reshape to 2D matrix
    data_2d = reshape(data, rows*cols, bands);
    
    % Estimate noise covariance using shift difference
    noise_samples = [];
    for b = 1:bands
        band = data(:,:,b);
        % Horizontal differences
        diff_h = band(:, 2:end) - band(:, 1:end-1);
        noise_samples = [noise_samples; diff_h(:)];
    end
    noise_cov = cov(noise_samples) / 2; % Divide by 2 for shift difference
    
    % Data covariance
    data_cov = cov(data_2d);
    
    % Generalized eigenvalue problem
    [V, D] = eig(data_cov, noise_cov + eye(size(noise_cov))*1e-6);
    
    % Sort by eigenvalues (SNR)
    [~, idx] = sort(diag(D), 'descend');
    V = V(:, idx);
    
    % Transform data
    transformed = data_2d * V(:, 1:num_components);
    
    % Reshape back
    reduced = reshape(transformed, rows, cols, num_components);
    noise = noise_cov;
    
    fprintf('MNF applied: %d -> %d components\n', bands, num_components);
end
