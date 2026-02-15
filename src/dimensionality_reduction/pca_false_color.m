% pca_false_color.m
% Create false color composite using first three Principal Components (PC1, PC2, PC3)

clear; clc; close all;

%% ================== Load Data ==================
fprintf('Loading Indian Pines dataset...\n');
load('D:/work/Remote Sensing/data/IPS200.mat');          % adjust path if needed

[Nr, Nc, Nb] = size(data);
fprintf('Data size: %d × %d × %d\n', Nr, Nc, Nb);

%% ================== Reshape for PCA ==================
% Flatten spatial dimensions
data_2d = reshape(data, [], Nb);            % (Nr*Nc) × Nb

%% ================== PCA ==================
fprintf('Computing PCA...\n');
[coeff, score, latent, ~] = pca(data_2d, 'Centered', true);

% First three principal components
PC1 = score(:,1);
PC2 = score(:,2);
PC3 = score(:,3);

% Reshape back to image dimensions
PC1_img = reshape(PC1, Nr, Nc);
PC2_img = reshape(PC2, Nr, Nc);
PC3_img = reshape(PC3, Nr, Nc);

%% ================== Normalize for Visualization ==================
% Simple min-max normalization to [0,1]
R = mat2gray(PC1_img);
G = mat2gray(PC2_img);
B = mat2gray(PC3_img);

false_color = cat(3, R, G, B);

%% ================== Display ==================
figure('Name','PCA False Color Composite','NumberTitle','off','Position',[200 200 1000 800]);

subplot(2,2,1);
imshow(false_color);
title('False Color (PC1, PC2, PC3)');

subplot(2,2,2);
imshow(mat2gray(PC1_img));
title('PC1');
colorbar;

subplot(2,2,3);
imshow(mat2gray(PC2_img));
title('PC2');
colorbar;

subplot(2,2,4);
imshow(mat2gray(PC3_img));
title('PC3');
colorbar;

sgtitle('PCA-based False Color Composite - Indian Pines');

%% ================== Explained Variance ==================
explained = latent / sum(latent) * 100;
fprintf('Explained variance:\n');
fprintf('PC1: %.2f%%\n', explained(1));
fprintf('PC2: %.2f%%\n', explained(2));
fprintf('PC3: %.2f%%\n', explained(3));
fprintf('First 3 PCs together: %.2f%%\n', sum(explained(1:3)));

disp('PCA false color visualization completed.');