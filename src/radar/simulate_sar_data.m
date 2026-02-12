function data = simulate_sar_data(rows, cols, varargin)
% SIMULATE_SAR_DATA Generate synthetic SAR (Synthetic Aperture Radar) data
%
% Syntax:
%   data = simulate_sar_data(rows, cols)
%   data = simulate_sar_data(rows, cols, 'polarization', 'VV')
%
% Input:
%   rows - Number of rows
%   cols - Number of columns
%   varargin - Optional: 'polarization' ('VV', 'HH', 'VH', 'HV'), 'speckle', 'targets'
%
% Output:
%   data - Complex SAR data structure with:
%          .amplitude (rows x cols)
%          .phase (rows x cols)
%          .polarization
%
% Description:
%   Simulates SAR imagery with different polarizations and speckle noise

    p = inputParser;
    addParameter(p, 'polarization', 'VV', @ischar);
    addParameter(p, 'speckle', 0.5, @isnumeric);
    addParameter(p, 'targets', 3, @isnumeric);
    parse(p, varargin{:});
    
    % Create base backscatter pattern
    [X, Y] = meshgrid(1:cols, 1:rows);
    backscatter = 0.3 * ones(rows, cols);
    
    % Add terrain features
    terrain = 0.2 * sin(X/20) .* cos(Y/15);
    backscatter = backscatter + terrain;
    
    % Add point targets (strong reflectors)
    for t = 1:p.Results.targets
        cx = randi([20, cols-20]);
        cy = randi([20, rows-20]);
        target = exp(-((X-cx).^2 + (Y-cy).^2) / 25);
        backscatter = backscatter + 2 * target;
    end
    
    % Adjust backscatter based on polarization
    switch upper(p.Results.polarization)
        case 'VV'
            backscatter = backscatter * 1.0;
        case 'HH'
            backscatter = backscatter * 0.9;
        case 'VH'
            backscatter = backscatter * 0.3;
        case 'HV'
            backscatter = backscatter * 0.3;
    end
    
    % Generate speckle noise (multiplicative)
    speckle = sqrt(p.Results.speckle) * (randn(rows, cols) + 1i*randn(rows, cols)) / sqrt(2);
    
    % Complex SAR signal
    amplitude = backscatter .* (1 + real(speckle));
    amplitude = max(0, amplitude);
    
    phase = 2*pi*rand(rows, cols) + angle(speckle);
    
    % Package output
    data.amplitude = amplitude;
    data.phase = phase;
    data.complex = amplitude .* exp(1i * phase);
    data.polarization = p.Results.polarization;
    data.type = 'SAR';
    
    fprintf('SAR data simulated: %dx%d, Polarization: %s\n', ...
            rows, cols, p.Results.polarization);
end
