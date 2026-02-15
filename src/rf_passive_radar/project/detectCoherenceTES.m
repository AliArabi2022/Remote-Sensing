function [isCoherent, TES] = detectCoherenceTES(waveform)
% DETECTCOHERENCETES Trailing Edge Slope for coherence detection
%   isCoherent = true اگر coherent باشد (بر اساس threshold مقاله)
%   TES = شیب لبه عقبی
%   ورودی: waveform = آرایه 1D قدرت waveform
%   متریک مقاله: PD = 93.8%, PE کم

% نرمالیزه waveform
waveform = waveform / max(waveform);

% پیدا کردن پیک و لبه عقبی (trailing edge)
[~, peakIdx] = max(waveform);
trailingEdge = waveform(peakIdx:end);

% محاسبه شیب (slope) – ساده با fit linear
x = (1:length(trailingEdge))';
p = polyfit(x, trailingEdge, 1);
TES = abs(p(1));  % شیب مطلق (مقدار منفی نشان‌دهنده افت است)

% threshold از مقاله (تقریبی – تنظیم بر اساس داده)
threshold = 0.1;  % شیب بالا = coherent (از مقالات TES N,IDW ≈0.1-0.2)
isCoherent = TES > threshold;

% توضیح متریک مقاله
disp('متریک مقاله: Detection Probability = 93.8%, Probability of Error = کم');
end