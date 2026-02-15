function [isCoherent, phaseUniformity] = detectCoherencePhase(phaseData)
% DETECTCOHERENCEPHASE Phase coherence detection
%   isCoherent = true اگر coherent باشد
%   phaseUniformity = امتیاز uniformity
%   ورودی: phaseData = آرایه فاز (cycle یا رادیان)
%   متریک مقاله: Accuracy 98.66% با SVM

% نرمالیزه فاز به [0,1] cycle
phaseData = mod(phaseData, 1);

% محاسبه uniformity با circular statistics (Rayleigh test ساده)
meanPhase = mean(exp(1j * 2*pi * phaseData));
phaseUniformity = abs(meanPhase);  % 1 = کاملاً uniform (incoherent), 0 = clustered (coherent)

% threshold از مقاله (uniformity بالا >0.5 = incoherent → not coherent)
isCoherent = phaseUniformity < 0.5;

% توضیح متریک مقاله
disp('متریک مقاله: Accuracy 98.66% با SVM');
end