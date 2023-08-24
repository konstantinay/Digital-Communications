close all; clear; clc

%dhmiourgoume tis AR diadikasies
L = 10000;
a = [0.9, 0.01];

x = randn(L,1);
y1 = filter(1, [1; -a(1)], x);
y2 = filter(1, [1; -a(2)], x);

%PCM peiramata
[xq_y1_2, centers_y1_2, D_y1_2] = LloydMax(y1, 2, min(y1), max(y1));
[xq_y1_4, centers_y1_4, D_y1_4] = LloydMax(y1, 4, min(y1), max(y1));
[xq_y1_8, centers_y1_8, D_y1_8] = LloydMax(y1, 8, min(y1), max(y1));

[xq_y2_2, centers_y2_2, D_y2_2] = LloydMax(y2, 2, min(y2), max(y2));
[xq_y2_4, centers_y2_4, D_y2_4] = LloydMax(y2, 4, min(y2), max(y2));
[xq_y2_8, centers_y2_8, D_y2_8] = LloydMax(y2, 8, min(y2), max(y2));

% figure;
% plot(y2(1:500));
% hold on
% plot(xq_y2_8(1:500));
% legend({'original','quantized'})
% title('PCM, AR_2(1)')
% xlabel('500 samples')

%ADM peiramata
y1_int = interp(y1, 2);
out1 = ADM(y1_int);
adm_error1 = mean((out1 - y1_int).^2);
sqnr1 = 10*log10(mean(y1_int.^2)/adm_error1);

y2_int = interp(y2, 2);
out2 = ADM(y2_int);
adm_error2 = mean((out2 - y2_int).^2);
sqnr2 = 10*log10(mean(y2_int.^2)/adm_error2);

% figure;
% plot(y1_int(1:500));
% hold on
% plot(out1(1:500));
% legend({'original','quantized'})
% title('ADM, AR_1(1)')
% xlabel('500 samples')
