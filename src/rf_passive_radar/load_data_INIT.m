% مسیر فایل (مسیر خودت رو بگذار)
filename = 'D:\work\Remote Sensing\data\CAR09_0520_INT_v001.nc';

% مرحله 1: نمایش اطلاعات کامل فایل (خیلی مفید!)
ncdisp(filename)

% مرحله 2: اطلاعات کلی فایل (dimensions, variables, attributes)
info = ncinfo(filename);
disp('Dimensions:');
disp(info.Dimensions);
disp('Variables:');
disp({info.Variables.Name}');

% مرحله 3: خواندن یک متغیر خاص (مثال: فرض کنیم متغیر 'complex_waveform' یا 'reflected_power' وجود داره)
% اول با ncdisp ببین نام دقیق متغیرها چیه، بعد این خط رو تغییر بده

% مثال: خواندن یک waveform یا سیگنال بازتابی
reflected_data = ncread(filename, 'SecondOfWeek');  % نام متغیر رو عوض کن
direct_data    = ncread(filename, 'GPSweek');    % اگر وجود داشته باشه

% یا خواندن بخشی از داده (اگر خیلی بزرگه)
% start = [1 1 1];  % نقطه شروع
% count = [100 Inf 1];  % تعداد بخوان (Inf یعنی همه)
% partial_data = ncread(filename, 'ddm', start, count);

% مرحله 4: خواندن attribute (مثل واحد یا توضیح)
unit = ncreadatt(filename, 'SecondOfWeek', 'units');  % مثال
disp(['Unit of reflected_power: ' unit]);

% مرحله 5: نمایش ساده (اگر داده 1D یا 2D باشه)
figure;
plot(reflected_data);  % یا imagesc اگر 2D باشه
title('Example Reflected Signal / Waveform');
xlabel('Sample'); ylabel('Amplitude / Power');
grid on;