% feature_plotting.m
% Visualize pixels in 2D or 3D feature space (after PCA or raw bands)

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');

%% ================== Configuration ==================
use_pca = true;             % true = PCA features, false = raw selected bands
n_features = 3;             % 2 or 3 for plotting
bands_or_pcs = [50, 100, 150];   % if not PCA → which bands to use

%% ================== Prepare Features ==================
X = reshape(data, [], size(data,3));   % (Nr*Nc) × Nb

if use_pca
    fprintf('Computing PCA for feature space...\n');
    [~, score] = pca(X, 'NumComponents', n_features);
    features = score;
    title_str = sprintf('PCA Feature Space (%d components)', n_features);
else
    features = X(:, bands_or_pcs);
    title_str = sprintf('Raw Bands %s Feature Space', mat2str(bands_or_pcs));
end

labels = gtm(:);

%% ================== Plot ==================
figure('Name','Feature Space Visualization','NumberTitle','off','Position',[400 400 1000 800]);

if n_features == 2
    scatter(features(:,1), features(:,2), 6, labels, 'filled');
    xlabel('Feature 1'); ylabel('Feature 2');
    title(title_str);
    colormap jet; colorbar;
    grid on;
    
elseif n_features == 3
    scatter3(features(:,1), features(:,2), features(:,3), 6, labels, 'filled');
    xlabel('Feature 1'); ylabel('Feature 2'); zlabel('Feature 3');
    title(title_str);
    colormap jet; colorbar;
    grid on; view(45,30);
    rotate3d on;
else
    error('Plotting supported only for 2 or 3 dimensions.');
end

% Improve legend readability
unique_classes = unique(labels(labels>0));
caxis([0 max(unique_classes)]);
title({title_str, 'Colors = Ground Truth Classes (0 = background)'}, 'Interpreter','none');

disp('Feature space plot completed.');