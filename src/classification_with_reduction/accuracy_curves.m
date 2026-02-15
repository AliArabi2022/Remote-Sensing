% accuracy_curves.m
% Classification accuracy vs. number of features (Raw / PCA / LDA)

clear; clc; close all;

%% تنظیمات
load('D:/work/Remote Sensing/data/IPS200.mat');   % یا مسیر درست فایل
data = double(data);

max_feat = 15;
n_runs   = 8;
train_frac = 0.3;          % نسبت آموزش

X = reshape(data, [], size(data,3));
y = gtm(:);

valid = y > 0;
Xv = X(valid,:);
yv = y(valid);

% PCA یک بار
[~, score] = pca(Xv, 'NumComponents', max_feat);

acc_raw = zeros(max_feat, n_runs);
acc_pca = zeros(max_feat, n_runs);
acc_lda = zeros(max_feat, n_runs);

for r = 1:n_runs
    fprintf('Run %d / %d\n', r, n_runs);
    
    cv = cvpartition(yv, 'HoldOut', 1-train_frac);
    tr = training(cv);
    te = test(cv);
    
    Xtr = Xv(tr,:);   ytr = yv(tr);
    Xte = Xv(te,:);   yte = yv(te);
    
    % ── LDA ──────────────────────────────────────────────
    mdl = fitcdiscr(Xtr, ytr, 'DiscrimType','linear');
    
    % استخراج ماتریس پروجکشن از Coeffs
    n_classes = length(mdl.ClassNames);
    proj = zeros(size(Xtr,2), n_classes-1);
    
    for c = 2:n_classes
        proj(:, c-1) = mdl.Coeffs(c).Linear;    % این خط کلیدی است
    end
    
    nld = min(max_feat, size(proj,2));
    
    mu = mean(Xtr);   % مرکز داده‌های آموزشی
    
    Xtr_lda = (Xtr - mu) * proj(:,1:nld);
    Xte_lda = (Xte - mu) * proj(:,1:nld);
    
    % ── طبقه‌بندی برای هر تعداد ویژگی ──────────────────
    for nf = 1:max_feat
        
        % Raw bands
        p_raw = classify(Xte(:,1:nf), Xtr(:,1:nf), ytr);
        acc_raw(nf,r) = mean(p_raw == yte) * 100;
        
        % PCA
        p_pca = classify(score(te,1:nf), score(tr,1:nf), ytr);
        acc_pca(nf,r) = mean(p_pca == yte) * 100;
        
        % LDA
        if nf <= nld
            p_lda = classify(Xte_lda(:,1:nf), Xtr_lda(:,1:nf), ytr);
            acc_lda(nf,r) = mean(p_lda == yte) * 100;
        else
            acc_lda(nf,r) = NaN;
        end
    end
end

%% رسم نمودار
nf = 1:max_feat;
figure('Position',[300 300 950 650]);
hold on;
errorbar(nf, mean(acc_raw,2), std(acc_raw,0,2), 'b-o', 'LineWidth',1.5, 'DisplayName','Raw Bands');
errorbar(nf, mean(acc_pca,2), std(acc_pca,0,2), 'r-s', 'LineWidth',1.5, 'DisplayName','PCA');
errorbar(nf, nanmean(acc_lda,2), nanstd(acc_lda,0,2), 'g-^', 'LineWidth',1.5, 'DisplayName','LDA');
grid on;
xlabel('Number of Features');
ylabel('Overall Accuracy (%)');
legend('Location','southeast');
title('Classification Accuracy vs. Number of Features');
set(gca,'FontSize',11);
hold off;

disp('Finished.');