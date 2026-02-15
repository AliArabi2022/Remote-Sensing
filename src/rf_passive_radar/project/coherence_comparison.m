% =========================================================================
% مقایسه روش‌های تشخیص Coherence روی داده واقعی فایل CAROLS 2009
% 
% =========================================================================

clear; clc; close all;

%% مرحله ۱: باز کردن فایل و خواندن داده‌ها
filename = 'D:\work\Remote Sensing\data\CAR09_0520_WAV_LND10020.nc';

disp('در حال خواندن فایل NetCDF ...');
try
    % چک وجود متغیرها
    info = ncinfo(filename);
    var_names = {info.Variables.Name};
catch ME
    error('خطا در باز کردن فایل: %s', ME.message);
end

% خواندن waveformها (اندازه بزرگ → فقط بخشی بخوانیم برای سرعت)
% مثلاً ۱۰۰۰ رکورد اول (برای تست سریع – می‌توانید بیشتر کنید)
n_records_to_read = 1000;   % ← این عدد را تغییر دهید اگر می‌خواهید بیشتر بخوانید

I_wave = ncread(filename, 'I_Waveform', [1 1], [64 n_records_to_read]);
Q_wave = ncread(filename, 'Q_Waveform', [1 1], [64 n_records_to_read]);
link   = ncread(filename, 'Link', 1, n_records_to_read);

% تبدیل به double (لازم است چون int8 هستند)
I_wave = double(I_wave);
Q_wave = double(Q_wave);

disp(['تعداد رکورد خوانده‌شده: ' num2str(n_records_to_read)]);
disp(['مقادیر Link موجود در نمونه: ' num2str(unique(link'))]);

%% مرحله ۲: محاسبه power waveform برای هر رکورد
power_waveforms = zeros(64, n_records_to_read);
for r = 1:n_records_to_read
    power_waveforms(:, r) = I_wave(:,r).^2 + Q_wave(:,r).^2;
end

% نرمال‌سازی اختیاری (برای مقایسه بهتر)
power_waveforms = power_waveforms ./ max(power_waveforms, [], 1);

%% مرحله ۳: انتخاب چند رکورد نمونه (مثلاً یکی مستقیم و یکی بازتابی)
% فرض: Link==1 مستقیم، Link==2 یا 3 بازتابی
direct_idx   = find(link == 1, 1, 'first');
refl_idx     = find(link == 2 | link == 3, 1, 'first');

if isempty(direct_idx) || isempty(refl_idx)
    error('رکورد مستقیم یا بازتابی پیدا نشد. مقادیر Link را چک کنید.');
end

% نمونه‌ها
wf_direct = power_waveforms(:, direct_idx);
wf_refl   = power_waveforms(:, refl_idx);

%% مرحله ۴: اعمال روش‌های تشخیص Coherence

% 1. Trailing Edge Slope
[isTES_dir, TES_dir] = detectCoherenceTES(wf_direct);
[isTES_ref, TES_ref] = detectCoherenceTES(wf_refl);

% 2. CIR (نیاز به تعداد incoherent averages - فرض ۱۰)
Ninc = 10;
[isCIR_dir, CIR_dir] = detectCoherenceCIR(I_wave(:,direct_idx) + 1j*Q_wave(:,direct_idx), Ninc);
[isCIR_ref, CIR_ref] = detectCoherenceCIR(I_wave(:,refl_idx)   + 1j*Q_wave(:,refl_idx),   Ninc);

% 3. Entropy (نیاز به ماتریس همبستگی)
corr_direct = cov(I_wave(:,direct_idx) + 1j*Q_wave(:,direct_idx));
corr_refl   = cov(I_wave(:,refl_idx)   + 1j*Q_wave(:,refl_idx));
[isEnt_dir, ent_dir] = detectCoherenceEntropy(corr_direct);
[isEnt_ref, ent_ref] = detectCoherenceEntropy(corr_refl);

% 4. SNR / Shape
[isSNR_dir, SNR_dir] = detectCoherenceSNR(wf_direct);
[isSNR_ref, SNR_ref] = detectCoherenceSNR(wf_refl);

% 5. Phase Coherence (از MaxPhase استفاده می‌کنیم - فرض ساده)
phase_direct = ncread(filename, 'MaxPhase', direct_idx, 1);
phase_refl   = ncread(filename, 'MaxPhase', refl_idx, 1);
[isPhase_dir, pu_dir] = detectCoherencePhase(phase_direct);   % فقط یک مقدار → ساده
[isPhase_ref, pu_ref] = detectCoherencePhase(phase_refl);

%% مرحله ۵: جدول مقایسه
methods = {'Trailing Edge Slope', 'CIR', 'Entropy', 'SNR/Shape', 'Phase Coherence'}';
direct_results   = [isTES_dir, isCIR_dir, isEnt_dir, isSNR_dir, isPhase_dir]';
refl_results     = [isTES_ref, isCIR_ref, isEnt_ref, isSNR_ref, isPhase_ref]';
article_metrics  = {'PD=93.8%', 'F1≈0.98', 'ROC AUC≈0.9', 'Accuracy≈98%', 'Accuracy 98.66%'}';

comparisonTable = table(methods, direct_results, refl_results, article_metrics, ...
    'VariableNames', {'Method', 'Direct_Link', 'Reflected_Link', 'Article_Metric'});

disp('جدول مقایسه روش‌های تشخیص Coherence روی داده واقعی:');
disp(comparisonTable);

% ذخیره جدول
writetable(comparisonTable, 'D:\work\Remote Sensing\data\coherence_comparison_real.csv');
disp('جدول در فایل coherence_comparison_real.csv ذخیره شد.');

%% مرحله ۶: نمایش waveformها برای مقایسه بصری
figure('Name','مقایسه waveform مستقیم و بازتابی', 'Color','w', 'Position',[200 100 1000 600]);

subplot(2,1,1);
plot(wf_direct, 'b-', 'LineWidth', 1.8);
title(sprintf('Waveform مستقیم (Link=%d)', link(direct_idx)));
xlabel('Lag / Sample'); ylabel('Normalized Power'); grid on;

subplot(2,1,2);
plot(wf_refl, 'r-', 'LineWidth', 1.8);
title(sprintf('Waveform بازتابی (Link=%d)', link(refl_idx)));
xlabel('Lag / Sample'); ylabel('Normalized Power'); grid on;

sgtitle('مقایسه بصری waveformها');