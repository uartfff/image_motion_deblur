close all;
clear all;

%% 读入并显示图像
filename = 'C:\Users\10310\Desktop\010635.png';
I = imread(filename);

figure
imshow(uint8(I));
title('原图');%figure1

%% 生成运动模糊图像
PSF = fspecial('motion',21, 11);
g = imfilter(I, PSF, 'circular');
figure 
imshow(uint8(g));
title('运动模糊图');%figure2

%% 对运动模糊图像进行灰度化，并进行二维快速傅里叶变换，生成其频谱图

gb=g;
figure
imshow(uint8(gb));%figure3
PQ = paddedsize(size(gb));
F = fft2(gb, PQ(1), PQ(2));
figure
imshow(uint8(F));%figure4

%% 作出倒频谱
F1 = log(1+abs(F));
F2 = abs(F1).^2;
F3 = real(ifft2(F2));
figure
imshow(uint8(F3));%figure5


%% 将倒频谱压缩，居中
H = log(1+abs(F3)); % 将倒频谱动态范围进行压缩
Hc = fftshift(H); % 将压缩结果进行循环移位，使低频成分居中
figure
imshow(uint8(Hc));%figure6

%% 通过阈值处理，边缘检测“canny”算子二值化倒频谱
T = graythresh(Hc);
bw=edge(Hc, 'canny', T);
figure
imshow(bw);%figure7

%% 对倒频谱从1°到180°作radon变换，以求出模糊角度
theta = 1:180;
R = radon(bw, theta);
figure
imshow(R);%figure8

%% 计算出通过倒频谱radon变换估计出的模糊角度
MAX = max(max(R));
[m, n] = find(R == MAX);
if 90 < n <= 180
   beita = n - 90;
else if 0 < n < 90
        beita = n + 90;
    else if n == [90;90] | n == [180;180]
            beita = n(1);
        end;
    end;
end;