function [isCoherent, SNR] = detectCoherenceSNR(waveform)
% DETECTCOHERENCESNR Peak Power / SNR for coherence
%   isCoherent = true اگر coherent باشد
%   SNR = مقدار SNR
%   ورودی: waveform = آرایه 1D قدرت
%   متریک مقاله: Accuracy ≈98%

% محاسبه peak power
peak = max(waveform);

% تخمین نویز (میانگین خارج از پیک)
noise = mean(waveform(waveform < 0.1 * peak));

% SNR = peak / noise
SNR = 10 * log10(peak / noise);

% شکل waveform: پخش‌شدگی (variance normalized)
shape_spread = var(waveform) / mean(waveform);

% threshold از مقاله (SNR بالا >10 dB و spread کم = coherent)
isCoherent = (SNR > 10) && (shape_spread < 0.5);

% توضیح متریک مقاله
disp('متریک مقاله: Accuracy ≈98% برای طبقه‌بندی');
end