% classification_with_reduction.m
% Perform supervised classification with dimensionality reduction

clear; clc; close all;

%% Configuration
data_path = 'D:/work/Remote Sensing/data/IPS200.mat';
classifier_type = 'ml';           % 'ml', 'knn', 'svm'
feature_count = 10;

%% Load Data
load(data_path);
data = double(data);
[Nr, Nc, Nb] = size(data);

X = reshape(data, [], Nb);
y = gtm(:);

valid = y > 0;
X_valid = X(valid, :);
y_valid = y(valid);

fprintf('Labeled samples: %d   Classes: %d\n', length(y_valid), length(unique(y_valid)));

%% Train/Test Split (simple 30/70)
rng(42);
cv = cvpartition(y_valid, 'HoldOut', 0.7);
train_idx = training(cv);
test_idx  = test(cv);

X_train = X_valid(train_idx, :);
y_train = y_valid(train_idx);
X_test  = X_valid(test_idx, :);
y_test  = y_valid(test_idx);

%% Dimensionality Reduction

% PCA
[~, score_pca] = pca(X_valid, 'NumComponents', feature_count);
X_pca_train = score_pca(train_idx, :);
X_pca_test  = score_pca(test_idx, :);

% LDA projection (per run)
    mdl = fitcdiscr(X_train, y_train, 'DiscrimType','linear');
    
    % استخراج ماتریس ضرایب (Linear coefficients)
    n_classes = length(mdl.ClassNames);
    proj = zeros(size(X_train,2), n_classes-1);   % features × (classes-1)
    
    for c = 2:n_classes
        proj(:, c-1) = mdl.Coeffs(c).Linear;   % .Linear فیلد مهم است
    end
    
    nld = min(feature_count, size(proj,2));
    
    mu = mean(X_train);   % یا mdl.Mu اگر بخواهید میانگین کلاس‌ها (ولی معمولاً mean(Xtr) بهتر است)
    
    Xtr_lda = (X_train - mu) * proj(:,1:nld);
    Xte_lda = (X_train - mu) * proj(:,1:nld);

%% Choose which features to use for classification
% Change one of these lines to test different methods
% X_train_use = X_train(:, 1:feature_count);      % Raw bands
X_train_use = X_pca_train;                        % PCA
% X_train_use = X_lda_train;                      % LDA

X_test_use  = X_pca_test;   % باید با بالا هم‌خوانی داشته باشد

%% Classification
fprintf('Classifying with %s ...\n', upper(classifier_type));

switch lower(classifier_type)
    case 'ml'
        pred = classify(X_test_use, X_train_use, y_train);
    case 'knn'
        mdl_class = fitcknn(X_train_use, y_train, 'NumNeighbors', 5);
        pred = predict(mdl_class, X_test_use);
    case 'svm'
        mdl_class = fitcsvm(X_train_use, y_train, 'KernelFunction','rbf');
        pred = predict(mdl_class, X_test_use);
    otherwise
        error('Unknown classifier');
end

%% Evaluation
acc = mean(pred == y_test) * 100;
fprintf('Accuracy: %.2f%%\n', acc);

% Confusion matrix
figure; confusionchart(y_test, pred);
title(sprintf('%s - %d features - Acc: %.1f%%', upper(classifier_type), feature_count, acc));

disp('Done.');