% gtm_display.m
% Display Indian Pines ground truth map with class labels

clear; clc; close all;

% Load dataset
load('D:/work/Remote Sensing/data/IPS200.mat');

% Check if gtm exists
if ~exist('gtm', 'var')
    error('Ground truth matrix "gtm" not found in the loaded file.');
end

[Nr, Nc] = size(gtm);
fprintf('Ground truth map: %dx%d pixels, %d classes\n', Nr, Nc, length(unique(gtm(:)))-1);

% Create RGB visualization
gt_rgb = zeros(Nr, Nc, 3);

% Simple color mapping (you can customize)
colors = [
    0   0   0;     % 0 - background
    255 0   0;     % 1
    0   255 0;     % 2
    0   0   255;   % 3
    255 255 0;     % 4
    255 0   255;   % 5
    0   255 255;   % 6
    192 192 192;   % 7
    128 0   0;     % 8
    128 128 0;     % 9
    0   128 0;     % 10
    128 0   128;   % 11
    0   128 128;   % 12
    0   0   128;   % 13
    255 165 0;     % 14
    255 192 203;   % 15
    165 42  42     % 16
] / 255;

% Assign colors
for c = 0:16
    mask = (gtm == c);
    gt_rgb(repmat(mask, [1 1 3])) = repmat(reshape(colors(c+1,:), [1 1 3]), [sum(mask(:)) 1]);
end

% Display
figure('Name', 'Ground Truth Map', 'NumberTitle', 'off');
imshow(gt_rgb);
title('Indian Pines Ground Truth (16 classes + background)');
axis image;

% Add legend (simple text version)
hold on;
text(5, 10, 'Classes 1-16 + Background (black)', 'Color', 'w', 'FontSize', 11, 'FontWeight', 'bold');
hold off;

% Optional: count pixels per class
unique_classes = unique(gtm(:));
counts = histcounts(gtm(:), [unique_classes; max(unique_classes)+1]);
table(unique_classes, counts', 'VariableNames', {'Class', 'PixelCount'})