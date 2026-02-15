% histogram_and_stats.m
% Display histogram and compute statistics for any band

clear; clc; close all;

% Load dataset
load('D:/work/Remote Sensing/data/IPS200.mat');

[Nx, Ny, Nb] = size(data);

% User input
band = input(sprintf('Enter band number (1-%d): ', Nb));

if band < 1 || band > Nb
    error('Invalid band.');
end

% Extract band
band_data = double(squeeze(data(:, :, band)));
band_vec = band_data(:);   % vector for statistics

% Statistics
mean_val = mean(band_vec);
var_val  = var(band_vec);
std_val  = std(band_vec);
skew_val = skewness(band_vec);
min_val  = min(band_vec);
max_val  = max(band_vec);

fprintf('\nStatistics for Band %d:\n', band);
fprintf('Mean     = %.2f\n', mean_val);
fprintf('Variance = %.2f\n', var_val);
fprintf('Std Dev  = %.2f\n', std_val);
fprintf('Skewness = %.3f\n', skew_val);
fprintf('Min      = %.2f\n', min_val);
fprintf('Max      = %.2f\n', max_val);

% Normalized image for display
band_norm = mat2gray(band_data);

% Histogram (normalized image 0-255)
figure('Name', sprintf('Histogram - Band %d', band), 'NumberTitle', 'off');
imhist(uint8(band_norm * 255));
title(sprintf('Histogram of Band %d (normalized)', band));
xlabel('Intensity Value'); ylabel('Frequency');
grid on;

% Show the band image
figure('Name', sprintf('Band %d Image', band), 'NumberTitle', 'off');
imshow(band_norm); 
title(sprintf('Band %d', band));
colorbar; axis image;