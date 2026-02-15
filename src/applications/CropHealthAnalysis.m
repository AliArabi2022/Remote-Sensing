
% Placeholder / Example: Vegetation Indices and Simple Crop Health Analysis
% 
% Application focus:
%   - Agriculture monitoring (crop health, stress detection)
%   - Forestry (vegetation vigor assessment)
%
% Uses Indian Pines dataset as example
% Computes popular vegetation indices: NDVI, EVI, SAVI
% Creates a basic health map and visualizes results

clear; clc; close all;

%% ================== Configuration ==================
data_file = 'D:/work/Remote Sensing/data/IPS200.mat';          % adjust path if needed

% Approximate band numbers for Indian Pines (wavelengths ~400-2500 nm)
% NIR ~ band 50-60 (around 800-900 nm)
% Red ~ band 27-30  (around 650-680 nm)
% Blue ~ band 10-15 (around 450-520 nm)
red_band  = 29;     % ~660 nm
nir_band  = 50;     % ~800 nm
blue_band = 12;     % ~480 nm

%% ================== Load Data ==================
fprintf('Loading dataset...\n');
load(data_file);

data = double(data);
[Nr, Nc, Nb] = size(data);

fprintf('Dataset: %d × %d pixels, %d bands\n', Nr, Nc, Nb);

%% ================== Extract Required Bands ==================
Red  = squeeze(data(:,:,red_band));
NIR  = squeeze(data(:,:,nir_band));
Blue = squeeze(data(:,:,blue_band));

% Normalize bands to [0,1] range (common practice for indices)
Red  = mat2gray(Red);
NIR  = mat2gray(NIR);
Blue = mat2gray(Blue);

%% ================== Compute Vegetation Indices ==================

% 1. NDVI - Normalized Difference Vegetation Index
%    NDVI = (NIR - Red) / (NIR + Red)
NDVI = (NIR - Red) ./ (NIR + Red + eps);   % eps avoids division by zero

% 2. EVI - Enhanced Vegetation Index (simplified version)
%    EVI = 2.5 * (NIR - Red) / (NIR + 6*Red - 7.5*Blue + 1)
EVI = 2.5 * (NIR - Red) ./ (NIR + 6*Red - 7.5*Blue + 1 + eps);

% 3. SAVI - Soil-Adjusted Vegetation Index
%    SAVI = ((NIR - Red) / (NIR + Red + L)) * (1 + L)   where L=0.5 (soil adjustment)
L = 0.5;
SAVI = ((NIR - Red) ./ (NIR + Red + L)) * (1 + L);

%% ================== Simple Crop Health Classification ==================
% Rule-based classification (very basic example)

health_map = zeros(Nr, Nc);

% Thresholds (empirical - adjust based on your data)
healthy_ndvi  = 0.5;
stressed_ndvi = 0.2;

for i = 1:Nr
    for j = 1:Nc
        ndvi_val = NDVI(i,j);
        
        if ndvi_val > healthy_ndvi
            health_map(i,j) = 3;     % Healthy vegetation
        elseif ndvi_val > stressed_ndvi
            health_map(i,j) = 2;     % Stressed / moderate vegetation
        elseif ndvi_val > 0
            health_map(i,j) = 1;     % Sparse vegetation / soil mix
        else
            health_map(i,j) = 0;     % Bare soil / water / non-veg
        end
    end
end

%% ================== Visualization ==================
figure('Name','Vegetation Indices & Crop Health','NumberTitle','off','Position',[100 100 1400 900]);

% Row 1: Indices
subplot(2,4,1); imshow(NDVI, []); title('NDVI'); colorbar; axis image;
subplot(2,4,2); imshow(EVI,  []); title('EVI');  colorbar; axis image;
subplot(2,4,3); imshow(SAVI, []); title('SAVI'); colorbar; axis image;

% True color approximation for reference
true_color = cat(3, mat2gray(squeeze(data(:,:,29))), ...
                    mat2gray(squeeze(data(:,:,20))), ...
                    mat2gray(squeeze(data(:,:,10))));
subplot(2,4,4); imshow(true_color); title('Approx. True Color');

% Row 2: Health map & ground truth comparison
subplot(2,4,5);
imagesc(health_map); axis image; colorbar;
title('Simple Vegetation Health Map');
colormap([0.5 0.5 0.5; 0.8 0.6 0.2; 0.2 0.8 0.2; 0 0.6 0]);
caxis([0 3]);
legend('Bare/Non-veg','Sparse','Stressed','Healthy','Location','bestoutside');

subplot(2,4,6);
imagesc(gtm); axis image; colorbar;
title('Ground Truth (reference)');
colormap jet;

% NDVI histogram
subplot(2,4,[7 8]);
histogram(NDVI(:), 50, 'Normalization','probability');
title('NDVI Distribution');
xlabel('NDVI Value'); ylabel('Probability');
grid on; xlim([-1 1]);

sgtitle('Vegetation Monitoring Example - Agriculture / Forestry Application');

%% ================== Basic Statistics ==================
fprintf('\nVegetation Indices Statistics:\n');
fprintf('NDVI → Mean: %.3f   Std: %.3f   Min: %.3f   Max: %.3f\n', ...
    mean(NDVI(:)), std(NDVI(:)), min(NDVI(:)), max(NDVI(:)));
fprintf('EVI  → Mean: %.3f   Std: %.3f\n', mean(EVI(:)), std(EVI(:)));
fprintf('SAVI → Mean: %.3f   Std: %.3f\n', mean(SAVI(:)), std(SAVI(:)));

fprintf('\nHealth Map Class Distribution:\n');
counts = histcounts(health_map(:), [ -0.5 0.5 1.5 2.5 3.5 ]);
fprintf('  Bare/Non-veg: %d pixels (%.1f%%)\n', counts(1), counts(1)/numel(health_map)*100);
fprintf('  Sparse:       %d pixels (%.1f%%)\n', counts(2), counts(2)/numel(health_map)*100);
fprintf('  Stressed:     %d pixels (%.1f%%)\n', counts(3), counts(3)/numel(health_map)*100);
fprintf('  Healthy:      %d pixels (%.1f%%)\n', counts(4), counts(4)/numel(health_map)*100);

disp('Example application finished.');