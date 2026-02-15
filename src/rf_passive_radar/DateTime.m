% =========================================================================
% برنامه تبدیل زمان GPS به تاریخ میلادی (UTC)
% 
% خروجی: زمان هر رکورد به صورت datetime میلادی
% =========================================================================

clear; clc;

% مسیر فایل (این مسیر را با مسیر واقعی خودت جایگزین کن)
filename = 'D:\work\Remote Sensing\data\CAR09_0520_WAV_LND10020.nc';
ncdisp(filename);
% خواندن متغیرهای زمان
gpsweek        = ncread(filename, 'GPSweek');
secondofweek   = ncread(filename, 'SecondOfWeek');
millisecond    = ncread(filename, 'Millisecond');

fprintf('تعداد رکوردها: %d\n', length(gpsweek));

% تبدیل به زمان GPS واقعی
% مبدأ زمان GPS: 6 ژانویه 1980 ساعت 00:00:00 UTC
gps_epoch = datetime(1980, 1, 6, 0, 0, 0, 'TimeZone', 'UTC');

% محاسبه تعداد ثانیه‌ها از مبدأ GPS
% هر هفته GPS = 7 روز × 86400 ثانیه
weeks_in_seconds = double(gpsweek) * 7 * 86400;

% اضافه کردن ثانیه‌های داخل هفته + میلی‌ثانیه
total_seconds = weeks_in_seconds + double(secondofweek) + double(millisecond)/1000;

% تبدیل به datetime میلادی (UTC)
utc_times = gps_epoch + seconds(total_seconds);

% نمایش ۱۰ نمونه اول (برای چک کردن)
disp(' نمونه زمان به میلادی (UTC):');
disp(utc_times());
% 
% % نمایش نمونه وسط و آخر (برای اطمینان از پوشش زمانی)
% disp('نمونه رکورد میانی:');
% disp(utc_times(round(end/2)));
% 
% disp('آخرین رکورد:');
% disp(utc_times(end));

% اگر می‌خواهی همه زمان‌ها را در یک فایل CSV ذخیره کنی (اختیاری)
% جدول بساز
time_table = table(utc_times, 'VariableNames', {'UTC_Time'});
writetable(time_table, 'D:\work\Remote Sensing\data\converted_times.csv');

disp('فایل CSV ذخیره شد: converted_times.csv');