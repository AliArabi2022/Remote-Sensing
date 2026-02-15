% =========================================================================
% کد نمونه: جداسازی و نمایش waveform مستقیم و بازتابی
%
% =========================================================================

clear; clc; close all;

% مسیر فایل (خودت تغییر بده)
filename = 'D:\work\Remote Sensing\data\CAR09_0520_WAV_LND10020.nc';
ncdisp(filename);
% چک کردن مقادیر Link (اجرا کن و ببین چه مقادیری دارد)
link = ncread(filename, 'Link');
unique_link = unique(link(:));
fprintf('مقادیر منحصربه‌فرد Link: ');
disp(unique_link');

% فرض رایج: تنظیم کن بر اساس خروجی بالا
% مثلاً: 1 = مستقیم، 2 = بازتاب LHCP، 3 = بازتاب RHCP
direct_mask   = (link == 1);     % ← اینجا عدد مستقیم را بگذار
reflected_mask = (link == 3);    % ← اینجا عدد بازتاب اصلی را بگذار (یا [2 3] اگر هر دو)

% خواندن waveform ها
I_wave = ncread(filename, 'I_Waveform');
Q_wave = ncread(filename, 'Q_Waveform');

% جداسازی
I_direct = I_wave(:, direct_mask);
Q_direct = Q_wave(:, direct_mask);

I_refl = I_wave(:, reflected_mask);
Q_refl = Q_wave(:, reflected_mask);

fprintf('تعداد رکورد مستقیم: %d\n', size(I_direct, 2));
fprintf('تعداد رکورد بازتابی: %d\n', size(I_refl, 2));

% محاسبه power waveform (میانگین روی همه رکوردها)
if ~isempty(I_direct)
    power_direct = mean(I_direct.^2 + Q_direct.^2, 2);
else
    power_direct = [];
    warning('هیچ رکورد مستقیمی پیدا نشد');
end

if ~isempty(I_refl)
    power_refl = mean(I_refl.^2 + Q_refl.^2, 2);
else
    power_refl = [];
    warning('هیچ رکورد بازتابی پیدا نشد');
end

% نمایش
figure('Name','Direct vs Reflected Waveform Comparison', ...
       'Color','w', 'Position',[200 150 1000 700]);

subplot(2,1,1);
if ~isempty(power_direct)
    plot(power_direct, 'b-', 'LineWidth', 1.8);
    title('Power Waveform - Direct Signal (میانگین)');
else
    title('هیچ waveform مستقیمی موجود نیست');
end
xlabel('Delay bin / Sample'); ylabel('Power');
grid on; set(gca,'FontSize',11);

subplot(2,1,2);
if ~isempty(power_refl)
    plot(power_refl, 'r-', 'LineWidth', 1.8);
    title('Power Waveform - Reflected Signal (میانگین)');
else
    title('هیچ waveform بازتابی موجود نیست');
end
xlabel('Delay bin / Sample'); ylabel('Power');
grid on; set(gca,'FontSize',11);

sgtitle('مقایسه waveform مستقیم و بازتابی');

%% ============== نمایش نمونه waveform بازتابی (اصلاح‌شده) ==============

if size(I_refl, 2) == 0
    disp('هیچ رکورد بازتابی پیدا نشد.');
    disp('مقادیر موجود Link:');
    disp(unique(link(:)'));
    return;
end

% تبدیل به double برای اطمینان
I1 = double(I_refl(:,1));
Q1 = double(Q_refl(:,1));

% محاسبه قدرت و دامنه به صورت ایمن
power = I1.^2 + Q1.^2;
power(power < 0) = 0;           % جلوگیری از منفی شدن
amplitude = sqrt(power);

% انتخاب عنوان ایمن
if any(reflected_mask)
    first_link = link(find(reflected_mask, 1, 'first'));   % فقط اولین
    title_str = sprintf('نمونه waveform بازتابی - رکورد اول (Link = %d)', first_link);
else
    title_str = 'نمونه waveform بازتابی - رکورد اول';
end

% رسم
figure('Name','نمونه waveform بازتابی (رکورد اول)', 'Color','w');
plot(amplitude, 'm-', 'LineWidth', 1.8);
title(title_str);
xlabel('Delay bin / Sample');
ylabel('Amplitude');
grid on;
set(gca, 'FontSize', 12);


% =========================================================================
% کد نمونه: محاسبه proxy خاک مرطوب (از روی Reflectivity)
% ادامه کد قبلی یا مستقل
% =========================================================================

% اگر کد قبلی را اجرا کردی، مستقیم ادامه بده
% در غیر این صورت دوباره متغیرها را بخوان

% فرض: power_direct و power_refl از کد قبلی موجود هستند

if ~exist('power_direct','var') || ~exist('power_refl','var')
    error('ابتدا کد جداسازی waveform را اجرا کن');
end

% محاسبه peak power (حداکثر قدرت)
peak_direct = max(power_direct);
peak_refl   = max(power_refl);

if peak_direct <= 0 || peak_refl <= 0
    error('قدرت صفر یا منفی → داده مشکل دارد');
end

% Reflectivity ساده (نسبت قدرت حداکثر)
reflectivity = peak_refl / peak_direct;

fprintf('Reflectivity تقریبی (Γ): %.4f\n', reflectivity);

% تخمین dielectric constant (مدل Fresnel تقریبی - incidence ~35-45 درجه)
% این فرمول ساده‌شده است و فرض polarization RHCP دارد
sqrt_gamma = sqrt(reflectivity);
epsilon = (1 + sqrt_gamma) ./ (1 - sqrt_gamma).^2;

fprintf('Dielectric constant تقریبی (ε_r): %.2f\n', epsilon);

% تخمین بسیار ساده volumetric soil moisture
% فرمول تجربی تقریبی (برای خاک معدنی، بدون calibration دقیق)
% m_v ≈ (ε_r - ε_dry) / (ε_wet - ε_dry)   با مقادیر تقریبی
epsilon_dry = 3.5;    % خاک خشک تقریبی
epsilon_sat = 25;     % خاک اشباع تقریبی (بستگی به بافت خاک دارد)

soil_moisture_vol = (epsilon - epsilon_dry) / (epsilon_sat - epsilon_dry);

% محدود کردن به بازه واقعی
soil_moisture_vol = max(0, min(0.50, soil_moisture_vol));

fprintf('Proxy خاک مرطوب (تقریبی): %.3f m³/m³ (volumetric)\n', soil_moisture_vol);
fprintf('توجه: این مقدار تقریبی است و نیاز به calibration و مدل دقیق‌تر دارد\n');


