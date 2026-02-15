
% Example Application: Soil Moisture Monitoring using Spectral Indices
%
% Focus:
%   - Indirect soil moisture estimation via vegetation/soil water content proxies
%   - Common indices: NDWI, NDMI, MSI
%   - Simple rule-based soil moisture status classification
%
% Suitable for: agriculture, drought monitoring, precision farming
% Uses Indian Pines hyperspectral data as example

clear; clc; close all;

%% ================== Configuration ==================
data_file = 'D:/work/Remote Sensing/data/IPS200.mat';          % adjust path if needed

% Approximate band numbers for Indian Pines (wavelengths ~400-2500 nm)
% NIR   ~ 800-900 nm   → band ~50
% SWIR1 ~ 1600-1700 nm → band ~110-120
% SWIR2 ~ 2100-2300 nm → band ~160-180
nir_band   = 50;     % Near-Infrared
swir1_band = 115;    % Shortwave Infrared 1 (~1610 nm)
swir2_band = 170;    % Shortwave Infrared 2 (~2200 nm)

%% ================== Load Data ==================
fprintf('Loading hyperspectral dataset...\n');
load(data_file);

data = double(data);
[Nr, Nc, Nb] = size(data);

fprintf('Dataset loaded: %d × %d pixels, %d bands\n', Nr, Nc, Nb);

%% ================== Extract Bands ==================
NIR   = squeeze(data(:,:,nir_band));
SWIR1 = squeeze(data(:,:,swir1_band));
SWIR2 = squeeze(data(:,:,swir2_band));

% Normalize to [0,1] for index calculation (robust to scaling)
NIR   = mat2gray(NIR);
SWIR1 = mat2gray(SWIR1);
SWIR2 = mat2gray(SWIR2);

%% ================== Compute Soil/Vegetation Moisture Indices ==================

% 1. NDWI - Normalized Difference Water Index (Gao 1996 style)
%    Sensitive to vegetation water content
%    NDWI = (NIR - SWIR) / (NIR + SWIR)
NDWI = (NIR - SWIR1) ./ (NIR + SWIR1 + eps);

% 2. NDMI - Normalized Difference Moisture Index (also called NDWI in some contexts)
%    Commonly used for canopy/soil moisture monitoring
NDMI = (NIR - SWIR2) ./ (NIR + SWIR2 + eps);

% 3. MSI - Moisture Stress Index
%    Sensitive to moisture stress in vegetation/soil
MSI = SWIR1 ./ (NIR + eps);

%% ================== Simple Soil Moisture Status Map (rule-based) ==================
% Very basic proxy classification (empirical thresholds - adjust for your data!)
moisture_map = zeros(Nr, Nc);

for i = 1:Nr
    for j = 1:Nc
        ndmi_val = NDMI(i,j);
        msi_val  = MSI(i,j);
        
        % Higher NDMI + lower MSI → wetter
        if ndmi_val > 0.25 && msi_val < 0.8
            moisture_map(i,j) = 3;   % Wet / High moisture
        elseif ndmi_val > 0.0 && msi_val < 1.2
            moisture_map(i,j) = 2;   % Moderate moisture
        elseif ndmi_val > -0.2
            moisture_map(i,j) = 1;   % Dry / Low moisture
        else
            moisture_map(i,j) = 0;   % Very dry / Bare soil
        end
    end
end

%% ================== Visualization ==================
figure('Name','Soil Moisture Indices & Status Map','NumberTitle','off','Position',[150 150 1400 900]);

% Indices
subplot(2,3,1); imshow(NDWI, [-0.5 0.5]); title('NDWI'); colorbar; axis image;
subplot(2,3,2); imshow(NDMI, [-0.5 0.5]); title('NDMI'); colorbar; axis image;
subplot(2,3,3); imshow(MSI,  [0 2]);      title('MSI');  colorbar; axis image;

% Reference true color (approximate)
true_color = cat(3, mat2gray(squeeze(data(:,:,29))), ...
                    mat2gray(squeeze(data(:,:,20))), ...
                    mat2gray(squeeze(data(:,:,10))));
subplot(2,3,4); imshow(true_color); title('Approx. True Color'); axis image;

% Moisture status map
subplot(2,3,5);
imagesc(moisture_map); axis image; colorbar;
title('Simple Soil Moisture Status Map (proxy)');
colormap([0.6 0.4 0.2;  1 0.8 0.4;  0.4 0.8 1;  0 0.4 0.8]);
caxis([0 3]);
legend('Very Dry', 'Dry', 'Moderate', 'Wet', 'Location','bestoutside');

% Histogram of NDMI (main proxy)
subplot(2,3,6);
histogram(NDMI(:), 60, 'Normalization','probability', 'FaceColor',[0.2 0.6 0.9]);
title('NDMI Distribution'); xlabel('NDMI Value'); ylabel('Probability');
grid on; xlim([-0.8 0.8]);

sgtitle('Soil Moisture Monitoring Example using Spectral Indices');

%% ================== Basic Statistics & Insights ==================
fprintf('\nMoisture Indices Statistics:\n');
fprintf('NDWI  → Mean: %.3f   Std: %.3f   Range: [%.3f  %.3f]\n', ...
    mean(NDWI(:)), std(NDWI(:)), min(NDWI(:)), max(NDWI(:)));
fprintf('NDMI  → Mean: %.3f   Std: %.3f   Range: [%.3f  %.3f]\n', ...
    mean(NDMI(:)), std(NDMI(:)), min(NDMI(:)), max(NDMI(:)));
fprintf('MSI   → Mean: %.3f   Std: %.3f   Range: [%.3f  %.3f]\n', ...
    mean(MSI(:)), std(MSI(:)), min(MSI(:)), max(MSI(:)));

fprintf('\nMoisture Status Distribution:\n');
counts = histcounts(moisture_map(:), [-0.5 0.5 1.5 2.5 3.5]);
total_pixels = numel(moisture_map);
fprintf('  Very Dry: %6d pixels (%.1f%%)\n', counts(1), counts(1)/total_pixels*100);
fprintf('  Dry:      %6d pixels (%.1f%%)\n', counts(2), counts(2)/total_pixels*100);
fprintf('  Moderate: %6d pixels (%.1f%%)\n', counts(3), counts(3)/total_pixels*100);
fprintf('  Wet:      %6d pixels (%.1f%%)\n', counts(4), counts(4)/total_pixels*100);

disp('Soil moisture example finished.');