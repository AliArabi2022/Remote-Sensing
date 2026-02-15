% lda_false_color.m
% Create false color composite using first three Linear Discriminant components
% Uses manual eigendecomposition of scatter matrices (standard LDA projection)

clear; clc; close all;

%% ================== Load Data ==================
fprintf('Loading Indian Pines dataset...\n');
load('D:/work/Remote Sensing/data/IPS200.mat');           % adjust path if needed

[Nr, Nc, Nb] = size(data);
fprintf('Data size: %d × %d × %d\n', Nr, Nc, Nb);

%% ================== Prepare Data ==================
% Flatten
X = reshape(data, [], Nb);          % (Nr*Nc) × Nb
labels = gtm(:);                    % (Nr*Nc) × 1

% Keep only labeled pixels (class > 0)
valid = labels > 0;
X_valid = X(valid, :);
y_valid = labels(valid);

classes = unique(y_valid);
n_classes = length(classes);
fprintf('Using %d labeled pixels for LDA (%d classes)\n', size(X_valid,1), n_classes);

%% ================== Compute Scatter Matrices ==================
% Mean of each class
mu_class = zeros(n_classes, Nb);
for i = 1:n_classes
    idx = (y_valid == classes(i));
    mu_class(i,:) = mean(X_valid(idx,:));
end

% Overall mean
mu_overall = mean(X_valid);

% Within-class scatter (Sw)
Sw = zeros(Nb, Nb);
for i = 1:n_classes
    idx = (y_valid == classes(i));
    diff = X_valid(idx,:) - mu_class(i,:);
    Sw = Sw + diff' * diff;
end

% Between-class scatter (Sb)
Sb = zeros(Nb, Nb);
for i = 1:n_classes
    n_i = sum(y_valid == classes(i));
    diff = (mu_class(i,:) - mu_overall)';
    Sb = Sb + n_i * (diff * diff');
end

%% ================== Solve Generalized Eigenvalue Problem ==================
fprintf('Computing LDA projection directions...\n');

% Solve Sb * W = lambda * Sw * W
[W, LAMBDA] = eig(Sb, Sw + eps*eye(Nb));   % add small eps to avoid singularity

% Sort eigenvectors by descending eigenvalues
lambda = diag(LAMBDA);
[~, sort_idx] = sort(lambda, 'descend');
W = W(:, sort_idx);

% Take first min(3, n_classes-1) directions
n_dims = min(3, n_classes-1);
W_lda = W(:, 1:n_dims);

%% ================== Project All Data (including background) ==================
% Center using overall mean of training data
X_centered = X - mu_overall;

% Project → LD scores
LD_full = X_centered * W_lda;               % (Nr*Nc) × n_dims

%% ================== Reshape to Images ==================
LD1_img = reshape(LD_full(:,1), Nr, Nc);

LD2_img = [];
LD3_img = [];
if n_dims >= 2
    LD2_img = reshape(LD_full(:,2), Nr, Nc);
end
if n_dims >= 3
    LD3_img = reshape(LD_full(:,3), Nr, Nc);
end

%% ================== Normalize & Create False Color RGB ==================
R = mat2gray(LD1_img);

G = zeros(size(R));
if ~isempty(LD2_img)
    G = mat2gray(LD2_img);
end

B = zeros(size(R));
if ~isempty(LD3_img)
    B = mat2gray(LD3_img);
end

false_color = cat(3, R, G, B);

%% ================== Display ==================
figure('Name','LDA False Color Composite','NumberTitle','off','Position',[300 200 1100 900]);

subplot(2,2,1);
imshow(false_color);
title('False Color (LD1-R, LD2-G, LD3-B)');

subplot(2,2,2);
imshow(mat2gray(LD1_img)); title('LD1'); colorbar; axis image;

if ~isempty(LD2_img)
    subplot(2,2,3);
    imshow(mat2gray(LD2_img)); title('LD2'); colorbar; axis image;
end

if ~isempty(LD3_img)
    subplot(2,2,4);
    imshow(mat2gray(LD3_img)); title('LD3'); colorbar; axis image;
end

sgtitle('Supervised LDA-based False Color - Indian Pines');

fprintf('LDA completed. Projected to %d dimensions.\n', n_dims);
disp('Script finished.');