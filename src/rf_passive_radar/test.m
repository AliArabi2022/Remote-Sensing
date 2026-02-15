% =========================================================================
% گام ۱: محاسبه Reflectivity واقعی (با تصحیح نویز ساده)
% فایل: DCAR09_0520_WAV_LND10020.nc
% =========================================================================

clear; clc; close all;

% مسیر فایل (خودت تنظیم کن)
filename = 'D:\work\Remote Sensing\data\CAR09_0520_WAV_LND10020.nc';
ncdisp(filename);
% خواندن متغیرهای کلیدی
link         = ncread(filename, 'Link');          % 1 تا 3
max_amp      = ncread(filename, 'MaxAmplitude');  % int8
max_pos      = ncread(filename, 'MaxPosition');   % lag با بیشترین دامنه
Channal      = ncread(filename, 'Channel');
% تبدیل MaxAmplitude به دامنه مثبت (int8 signed → absolute value)
max_amp_abs = abs(double(max_amp));   % تبدیل به double و قدر مطلق

% فرض رایج در CAROLS/GOLD-RTR (باید با unique(link) چک کنی)
% معمولاً:
%   Link=1 → مستقیم (direct / up-looking)
%   Link=2 → بازتاب LHCP
%   Link=3 → بازتاب RHCP
direct_mask   = (link == 1);
refl_lhcp_mask = (link == 2);   % بازتاب LHCP (رایج برای زمین)
refl_rhcp_mask = (link == 3);   % بازتاب RHCP (کمتر استفاده می‌شود)

% چک تعداد رکوردها
fprintf('تعداد رکورد مستقیم (Link=1): %d\n', sum(direct_mask));
fprintf('تعداد بازتاب LHCP (Link=2): %d\n', sum(refl_lhcp_mask));
fprintf('تعداد بازتاب RHCP (Link=3): %d\n', sum(refl_rhcp_mask));

% محاسبه میانگین MaxAmplitude برای هر گروه (به عنوان تخمین قدرت پیک)
if any(direct_mask)
    peak_direct = mean(max_amp_abs(direct_mask));
else
    peak_direct = NaN;
    warning('هیچ رکورد مستقیمی پیدا نشد');
end

if any(refl_lhcp_mask)
    peak_refl_lhcp = mean(max_amp_abs(refl_lhcp_mask));
else
    peak_refl_lhcp = NaN;
end

if any(refl_rhcp_mask)
    peak_refl_rhcp = mean(max_amp_abs(refl_rhcp_mask));
else
    peak_refl_rhcp = NaN;
end

% محاسبه Reflectivity ساده (بدون تصحیح پیشرفته)
reflectivity_lhcp = peak_refl_lhcp / peak_direct;
reflectivity_rhcp = peak_refl_rhcp / peak_direct;

fprintf('\nReflectivity تقریبی LHCP (Link=2): %.4f\n', reflectivity_lhcp);
fprintf('Reflectivity تقریبی RHCP (Link=3): %.4f\n', reflectivity_rhcp);

% =========================================================================
% تصحیح نویز ساده (Noise floor correction)
% =========================================================================

% تخمین نویز: میانگین MaxAmplitude در جایی که سیگنال ضعیف است
% (اینجا ساده فرض می‌کنیم کمترین ۵٪ مقادیر ≈ نویز)
all_amp_sorted = sort(max_amp_abs);
noise_floor = mean(all_amp_sorted(1:round(0.05*length(all_amp_sorted))));

fprintf('تخمین سطح نویز (noise floor): %.2f\n', noise_floor);

% تصحیح نویز روی پیک‌ها
peak_direct_corr   = peak_direct   - noise_floor;
peak_refl_lhcp_corr = peak_refl_lhcp - noise_floor;
peak_refl_rhcp_corr = peak_refl_rhcp - noise_floor;

% جلوگیری از منفی شدن
peak_direct_corr   = max(peak_direct_corr,   1e-6);
peak_refl_lhcp_corr = max(peak_refl_lhcp_corr, 1e-6);
peak_refl_rhcp_corr = max(peak_refl_rhcp_corr, 1e-6);

% Reflectivity با تصحیح نویز
reflectivity_lhcp_corr = peak_refl_lhcp_corr / peak_direct_corr;
reflectivity_rhcp_corr = peak_refl_rhcp_corr / peak_direct_corr;

fprintf('Reflectivity با تصحیح نویز LHCP: %.4f\n', reflectivity_lhcp_corr);
fprintf('Reflectivity با تصحیح نویز RHCP: %.4f\n', reflectivity_rhcp_corr);

% =========================================================================
% نمایش توزیع Reflectivity (برای درک بهتر)
% =========================================================================

figure('Name','توزیع Reflectivity (LHCP)', 'Color','w');
histogram(reflectivity_lhcp_corr * ones(sum(refl_lhcp_mask),1), 50);
title('توزیع Reflectivity LHCP (با تصحیح نویز)');
xlabel('Reflectivity (Γ)'); ylabel('تعداد رکورد');
grid on;

% اگر بخواهی نقشه بکشی (اگر lat/lon داشتی)
% فعلاً فقط توزیع نشان می‌دهیم