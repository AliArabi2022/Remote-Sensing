%% Remote Sensing Hyperspectral Example
% This example demonstrates hyperspectral data processing workflow:
% 1. Data simulation (IPS200 compatible format)
% 2. Visualization
% 3. Dimensionality reduction (PCA, MNF)
% 4. Classification

clear; close all; clc;

% Add source directories to path
addpath(genpath('../src'));

fprintf('=== Remote Sensing: Hyperspectral Example (IPS200) ===\n\n');

%% 1. Simulate Hyperspectral Data
fprintf('Step 1: Simulating hyperspectral data...\n');
rows = 150;
cols = 150;
num_bands = 200;  % Typical for IPS200

% Simulate data with wavelengths from 400-2500 nm
data_struct = simulate_hyperspectral_data(rows, cols, num_bands, ...
                                          'wavelengths', linspace(400, 2500, num_bands), ...
                                          'noise', 0.02, ...
                                          'classes', 5);

data = data_struct.image;
wavelengths = data_struct.wavelengths;

%% 2. Visualize Hyperspectral Data
fprintf('\nStep 2: Visualizing hyperspectral data...\n');
visualize_data(data, 'hyperspectral', 'title', 'Simulated Hyperspectral Data (IPS200)');

% Plot spectral signatures
figure('Name', 'Spectral Signatures');
for i = 1:5
    px = randi([20, rows-20]);
    py = randi([20, cols-20]);
    signature = squeeze(data(px, py, :));
    plot(wavelengths, signature, 'LineWidth', 1.5);
    hold on;
end
xlabel('Wavelength (nm)');
ylabel('Reflectance');
title('Sample Spectral Signatures');
legend('Sample 1', 'Sample 2', 'Sample 3', 'Sample 4', 'Sample 5');
grid on;

%% 3. Dimensionality Reduction - PCA
fprintf('\nStep 3: Applying PCA...\n');
num_components = 10;
[reduced_pca, transform_pca] = apply_pca(data, num_components);

% Visualize first 3 PCA components
figure('Name', 'PCA Components');
for i = 1:3
    subplot(1,3,i);
    imagesc(reduced_pca(:,:,i)); colorbar; colormap(jet);
    title(sprintf('PC%d (%.1f%% var)', i, transform_pca.explained(i)));
    axis image;
end

%% 4. Dimensionality Reduction - MNF
fprintf('\nStep 4: Applying MNF...\n');
[reduced_mnf, noise] = apply_mnf(data, num_components);

% Visualize first 3 MNF components
figure('Name', 'MNF Components');
for i = 1:3
    subplot(1,3,i);
    imagesc(reduced_mnf(:,:,i)); colorbar; colormap(jet);
    title(sprintf('MNF%d', i));
    axis image;
end

%% 5. Classification on Reduced Data
fprintf('\nStep 5: Classifying reduced data...\n');
num_classes = 5;
classified = classify_kmeans(reduced_pca, num_classes);

figure('Name', 'Classification Results');
imagesc(classified); colorbar;
colormap(parula(num_classes));
title('K-means Classification (5 classes on PCA data)');
axis image;

%% Summary
fprintf('\n=== Analysis Summary ===\n');
fprintf('Original data: %d x %d x %d bands\n', rows, cols, num_bands);
fprintf('Wavelength range: %.0f - %.0f nm\n', min(wavelengths), max(wavelengths));
fprintf('PCA components: %d (%.2f%% variance)\n', num_components, sum(transform_pca.explained));
fprintf('MNF components: %d\n', num_components);
fprintf('Classification: %d classes\n', num_classes);

fprintf('\nHyperspectral example completed successfully!\n');
