function [classified, accuracy] = classify_supervised(data, training_data, training_labels, method)
% CLASSIFY_SUPERVISED Supervised classification of remote sensing data
%
% Syntax:
%   [classified, accuracy] = classify_supervised(data, training_data, training_labels, method)
%
% Input:
%   data - Input data (rows x cols x bands)
%   training_data - Training samples (num_samples x bands)
%   training_labels - Training labels (num_samples x 1)
%   method - Classification method: 'svm', 'knn', 'tree'
%
% Output:
%   classified - Classification map (rows x cols)
%   accuracy - Training accuracy (if applicable)
%
% Description:
%   Performs supervised classification using various methods

    [rows, cols, bands] = size(data);
    
    % Reshape data to 2D matrix
    data_2d = reshape(data, rows*cols, bands);
    
    % Train classifier based on method
    switch lower(method)
        case 'svm'
            % Support Vector Machine
            model = fitcecoc(training_data, training_labels);
            predicted = predict(model, data_2d);
            
        case 'knn'
            % K-Nearest Neighbors
            k = 5;
            model = fitcknn(training_data, training_labels, 'NumNeighbors', k);
            predicted = predict(model, data_2d);
            
        case 'tree'
            % Decision Tree
            model = fitctree(training_data, training_labels);
            predicted = predict(model, data_2d);
            
        otherwise
            error('Unknown classification method: %s', method);
    end
    
    % Reshape to image
    classified = reshape(predicted, rows, cols);
    
    % Calculate training accuracy
    training_predicted = predict(model, training_data);
    accuracy = sum(training_predicted == training_labels) / length(training_labels);
    
    fprintf('Supervised classification completed: %s, Accuracy: %.2f%%\n', ...
            method, accuracy*100);
end
