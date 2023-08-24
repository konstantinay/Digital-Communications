close all; clear; clc

load cameraman.mat
%imshow(uint8(i));

x = i(:);
x = (x-128)/128;
% x = 128*x+128;
% y = reshape(x, 256, 256);
% imshow(uint8(y));

%PCM peiramata
[xq_1, centers1, D1] = LloydMax(x, 2, min(x), max(x));
[xq_2, centers2, D2] = LloydMax(x, 4, min(x), max(x));

x_out1 = 128*xq_1+128;
y1 = reshape(x_out1, 256, 256);

x_out2 = 128*xq_2+128;
y2 = reshape(x_out2, 256, 256);

% figure;
% imshowpair(uint8(i),uint8(y1),'montage')
% title('Original & Quantized Image gia N = 2')

% figure;
% imshowpair(uint8(i),uint8(y2),'montage')
% title('Original & Quantized Image gia N = 4')