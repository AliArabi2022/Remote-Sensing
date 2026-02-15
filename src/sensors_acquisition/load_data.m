% load_data.m
% Load hyperspectral dataset and display basic information
% Supports common formats: .mat (Indian Pines, Salinas, Pavia, etc.)

clear; clc; close all;

%% ================== Configuration ==================
data_path = 'D:/work/Remote Sensing/data/';                % folder containing datasets
dataset_name = 'IPS200.mat';        % change to: 'Salinas.mat', 'PaviaU.mat', etc.

% Common variable names in .mat files (you may need to adjust)
expected_data_var = 'data';         % hyperspectral cube
expected_gt_var   = 'gtm';          % ground truth (optional)

%% ================== Load Data ==================
fprintf('Loading dataset: %s\n', dataset_name);

try
    loaded = load(fullfile(data_path, dataset_name));
catch ME
    error('Cannot load file: %s\nError: %s', dataset_name, ME.message);
end

% Try to find the hyperspectral cube
data_fields = fieldnames(loaded);
data_var = '';

for i = 1:length(data_fields)
    if contains(data_fields{i}, {'data','image','cube','corrected','hsi'}, 'IgnoreCase',true)
        data_var = data_fields{i};
        break;
    end
end

if isempty(data_var)
    error('Could not automatically detect hyperspectral data variable.\nAvailable variables: %s', strjoin(data_fields,', '));
end

data = loaded.(data_var);
fprintf('Hyperspectral cube loaded: %s  size = %s\n', data_var, mat2str(size(data)));

% Look for ground truth
gt_var = '';
for i = 1:length(data_fields)
    if contains(data_fields{i}, {'gt','ground','map','label','class','gtm'}, 'IgnoreCase',true)
        gt_var = data_fields{i};
        break;
    end
end

if ~isempty(gt_var)
    gtm = loaded.(gt_var);
    fprintf('Ground truth found: %s  size = %s  classes = %d\n', ...
        gt_var, mat2str(size(gtm)), length(unique(gtm(:)))-1);
else
    fprintf('No ground truth map detected.\n');
    gtm = [];
end

%% ================== Basic Visualization ==================
[Nr, Nc, Nb] = size(data);

% Show first band as example
figure('Name','First Band Preview','NumberTitle','off');
imshow(mat2gray(squeeze(data(:,:,1))),[]);
title(sprintf('%s - Band 1', dataset_name(1:end-4)));
axis image; colorbar;

% Show number of bands
% Look for ground truth
gt_var = '';
possible_gt_names = {'gt','ground','map','label','class','gtm','groundtruth','labels'};

for i = 1:length(data_fields)
    fname = lower(data_fields{i});
    if any(contains(fname, possible_gt_names))
        gt_var = data_fields{i};
        break;
    end
end

if ~isempty(gt_var)
    gtm = loaded.(gt_var);
    fprintf('Ground truth found: %s   size = %s\n', gt_var, mat2str(size(gtm)));
    
    if ~isempty(gtm) && ismatrix(gtm)
        classes = unique(gtm(:));
        num_classes = sum(classes > 0);   % count non-zero classes
        fprintf('Detected classes: %d  (values: %s)\n', num_classes, mat2str(classes'));
    else
        fprintf('Warning: Loaded ground truth is empty or not a matrix.\n');
        gtm = [];
    end
else
    fprintf('No ground truth map detected in the .mat file.\n');
    gtm = [];
end