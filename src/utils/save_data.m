function save_data(data, filename, format)
% SAVE_DATA Save remote sensing data to file
%
% Syntax:
%   save_data(data, filename, format)
%
% Input:
%   data - Data to save
%   filename - Output file path
%   format - Output format: 'mat', 'tiff', 'csv'
%
% Description:
%   Universal data saving function for remote sensing data

    if nargin < 3
        [~, ~, ext] = fileparts(filename);
        format = ext(2:end);
    end
    
    switch lower(format)
        case 'mat'
            save(filename, 'data');
        case {'tif', 'tiff'}
            imwrite(data, filename);
        case 'csv'
            writetable(data, filename);
        otherwise
            error('Unsupported format: %s', format);
    end
    
    fprintf('Data saved successfully to: %s\n', filename);
end
