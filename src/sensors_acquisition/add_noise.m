% add_noise.m
% Add various types of noise to hyperspectral data

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');   % change path/name if needed

% Make a copy to avoid modifying original
noisy_data = double(data);

%% ================== Noise Parameters ==================
noise_type = 'gaussian';    % options: 'gaussian', 'saltpepper', 'speckle', 'poisson'
noise_level = 0.05;         % for gaussian: std dev, for salt&pepper: density, for speckle: variance

%% ================== Add Noise ==================
switch lower(noise_type)
    
    case 'gaussian'
        fprintf('Adding Gaussian noise (std = %.3f)\n', noise_level);
        noise = noise_level * randn(size(noisy_data));
        noisy_data = noisy_data + noise;
        
    case 'saltpepper'
        fprintf('Adding Salt & Pepper noise (density = %.3f)\n', noise_level);
        noisy_data = imnoise(noisy_data, 'salt & pepper', noise_level);
        
    case 'speckle'
        fprintf('Adding Speckle noise (variance = %.3f)\n', noise_level);
        % imnoise expects 2D, so apply band by band
        for b = 1:size(noisy_data,3)
            noisy_data(:,:,b) = imnoise(noisy_data(:,:,b), 'speckle', noise_level);
        end
        
    case 'poisson'
        fprintf('Adding Poisson noise (scaled)\n');
        % Poisson usually needs integer counts → scale data first
        scale_factor = 1000;
        scaled = noisy_data * scale_factor;
        noisy_scaled = poissrnd(max(scaled,0));
        noisy_data = noisy_scaled / scale_factor;
        
    otherwise
        error('Unknown noise type. Use: gaussian, saltpepper, speckle, poisson');
end

% Clip negative values (common in reflectance data)
noisy_data = max(noisy_data, 0);

%% ================== Visualization ==================
band_to_show = 50;   % example band

figure('Name','Noise Comparison','NumberTitle','off');

subplot(1,2,1);
imshow(mat2gray(squeeze(data(:,:,band_to_show))),[]);
title('Original - Band 50');
axis image;

subplot(1,2,2);
imshow(mat2gray(squeeze(noisy_data(:,:,band_to_show))),[]);
title(sprintf('Noisy (%s, level=%.3f) - Band 50', noise_type, noise_level));
axis image;

%% ================== Save if needed ==================
% Uncomment to save
% save('data/IPS200_noisy_gaussian_005.mat', 'noisy_data', 'gtm', '-v7.3');

fprintf('Noise added. New variable: noisy_data\n');