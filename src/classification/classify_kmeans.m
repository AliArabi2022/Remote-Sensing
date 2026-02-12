function classified = classify_kmeans(data, num_classes, varargin)
% CLASSIFY_KMEANS K-means unsupervised classification
%
% Syntax:
%   classified = classify_kmeans(data, num_classes)
%   classified = classify_kmeans(data, num_classes, 'iterations', 100)
%
% Input:
%   data - Input data (rows x cols x bands)
%   num_classes - Number of classes
%   varargin - Optional: 'iterations', 'replicates'
%
% Output:
%   classified - Classification map (rows x cols)
%
% Description:
%   Performs k-means clustering for unsupervised classification

    p = inputParser;
    addParameter(p, 'iterations', 100, @isnumeric);
    addParameter(p, 'replicates', 3, @isnumeric);
    parse(p, varargin{:});
    
    [rows, cols, bands] = size(data);
    
    % Reshape to 2D matrix
    data_2d = reshape(data, rows*cols, bands);
    
    % Remove NaN values
    valid_idx = ~any(isnan(data_2d), 2);
    data_valid = data_2d(valid_idx, :);
    
    % Perform k-means clustering
    [idx, ~] = kmeans(data_valid, num_classes, ...
                      'MaxIter', p.Results.iterations, ...
                      'Replicates', p.Results.replicates, ...
                      'Display', 'off');
    
    % Map back to image
    classified_1d = nan(rows*cols, 1);
    classified_1d(valid_idx) = idx;
    classified = reshape(classified_1d, rows, cols);
    
    fprintf('K-means classification completed: %d classes\n', num_classes);
end
