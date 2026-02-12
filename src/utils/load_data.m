function data = load_data(filename, data_type)
% LOAD_DATA Load remote sensing data from file
%
% Syntax:
%   data = load_data(filename, data_type)
%
% Input:
%   filename - Path to data file
%   data_type - Type of data: 'multispectral', 'hyperspectral', 'radar', 'lidar'
%
% Output:
%   data - Loaded data structure
%
% Description:
%   Universal data loading function for various remote sensing data types

    if nargin < 2
        data_type = 'auto';
    end
    
    [~, ~, ext] = fileparts(filename);
    
    switch lower(ext)
        case {'.mat'}
            data = load(filename);
        case {'.tif', '.tiff'}
            data.image = imread(filename);
            data.type = data_type;
        case '.csv'
            data.table = readtable(filename);
            data.type = data_type;
        otherwise
            error('Unsupported file format: %s', ext);
    end
    
    fprintf('Data loaded successfully from: %s\n', filename);
end
