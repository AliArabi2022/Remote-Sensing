% spectral_signature.m
% Plot spectral signature of a selected pixel in Indian Pines dataset

clear; clc; close all;

% Load dataset
load('D:/work/Remote Sensing/data/IPS200.mat');

[Nr, Nc, Nb] = size(data);
fprintf('Dataset: %dx%d pixels, %d bands\n', Nr, Nc, Nb);

% User input: pixel location
row = input(sprintf('Enter row (1 to %d): ', Nr));
col = input(sprintf('Enter column (1 to %d): ', Nc));

if row < 1 || row > Nr || col < 1 || col > Nc
    error('Invalid pixel coordinates.');
end

% Extract spectral vector
signature = squeeze(data(row, col, :));

% Plot
figure('Name', 'Spectral Signature', 'NumberTitle', 'off');
plot(1:Nb, signature, 'b-', 'LineWidth', 1.8);
grid on;
title(sprintf('Spectral Signature - Pixel (%d, %d)', row, col));
xlabel('Band Number');
ylabel('Digital Number / Reflectance');
set(gca, 'FontSize', 12);

% Optional: show class if ground truth available
class_id = gtm(row, col);
if class_id > 0
    title(sprintf('Spectral Signature - Pixel (%d, %d)  |  Class: %d', ...
                  row, col, class_id), 'Interpreter', 'none');
end

% Optional: mark water absorption bands (approx)
hold on;
xline([104 108 150 163 220], '--r', 'Water absorption', 'LabelHorizontalAlignment', 'right');
hold off;