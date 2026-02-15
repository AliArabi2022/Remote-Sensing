
% Convert RGB to HSI color space
% Useful when you create a true color image from hyperspectral data

clear; clc; close all;

%% ================== Create or Load RGB ==================
% Example: create true color from Indian Pines
load('D:/work/Remote Sensing/data/IPS200.mat');

% Approximate true color bands (adjust according to your sensor)
R = squeeze(data(:,:,29));   % ~ red
G = squeeze(data(:,:,20));   % ~ green
B = squeeze(data(:,:,10));   % ~ blue

% Normalize to 0-1
R = mat2gray(R);
G = mat2gray(G);
B = mat2gray(B);

rgb_img = cat(3, R, G, B);

%% ================== RGB → HSI Conversion ==================
r = rgb_img(:,:,1);
g = rgb_img(:,:,2);
b = rgb_img(:,:,3);

% Hue
theta = acos( (0.5*((r-g)+(r-b))) ./ (sqrt((r-g).^2 + (r-b).*(g-b)) + eps) );
H = theta;
H(b > g) = 2*pi - H(b > g);
H = H / (2*pi);

% Saturation
S = 1 - 3 * min(cat(3,r,g,b), [], 3) ./ (r + g + b + eps);
S(isnan(S)) = 0;

% Intensity
I = (r + g + b) / 3;

hsi = cat(3, H, S, I);

%% ================== Visualization ==================
figure('Name','RGB to HSI Conversion','NumberTitle','off','Position',[100 100 1400 800]);

subplot(2,3,1); imshow(rgb_img); title('RGB (True Color Approx)');
subplot(2,3,2); imshow(H); title('Hue'); colormap hsv; colorbar;
subplot(2,3,3); imshow(S); title('Saturation'); colorbar;
subplot(2,3,4); imshow(I); title('Intensity'); colorbar;
subplot(2,3,5); imshow(hsi); title('HSI Composite');
subplot(2,3,6); imshow([H S I]); title('H | S | I Channels');

sgtitle('RGB → HSI Color Space Conversion');