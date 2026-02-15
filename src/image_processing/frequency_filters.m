
% Frequency domain filtering using FFT (ideal, Gaussian, Butterworth)

clear; clc; close all;

%% ================== Load Data ==================
load('D:/work/Remote Sensing/data/IPS200.mat');

band_num = 60;
band = double(squeeze(data(:,:,band_num)));

%% ================== Parameters ==================
filter_type = 'lowpass';     % 'lowpass', 'highpass', 'bandreject'
cutoff_freq = 30;            % cutoff frequency in pixels
order = 2;                   % for Butterworth

%% ================== Frequency Domain Filtering ==================
% FFT
F = fft2(band);
Fshift = fftshift(F);
[m, n] = size(band);
[u, v] = meshgrid(-floor(n/2):floor((n-1)/2), -floor(m/2):floor((m-1)/2));

% Distance from center
D = sqrt(u.^2 + v.^2);

% Create filter
switch lower(filter_type)
    case 'lowpass'
        fprintf('Ideal Low-pass filter (cutoff = %d)\n', cutoff_freq);
        H = double(D <= cutoff_freq);
        
    case 'highpass'
        fprintf('Ideal High-pass filter (cutoff = %d)\n', cutoff_freq);
        H = double(D > cutoff_freq);
        
    case 'bandreject'
        fprintf('Ideal Band-reject filter\n');
        r1 = cutoff_freq - 10;
        r2 = cutoff_freq + 10;
        H = double(D <= r1 | D >= r2);
        
    otherwise
        error('Unknown filter type');
end

% Apply filter
Gshift = Fshift .* H;
G = ifftshift(Gshift);
filtered = real(ifft2(G));

%% ================== Visualization ==================
figure('Name','Frequency Domain Filtering','NumberTitle','off','Position',[200 200 1400 600]);

subplot(2,3,1); imshow(mat2gray(band)); title('Original');
subplot(2,3,2); imshow(log(1+abs(Fshift)),[]); title('FFT Spectrum');
subplot(2,3,3); imshow(H,[]); title(sprintf('%s Filter', filter_type));

subplot(2,3,4); imshow(mat2gray(filtered)); title('Filtered Image');
subplot(2,3,5); imshow(log(1+abs(Gshift)),[]); title('Filtered Spectrum');
subplot(2,3,6); imshow(mat2gray(abs(band - filtered)*5)); title('Difference (×5)');

sgtitle(sprintf('Frequency Domain Filtering - Band %d', band_num));