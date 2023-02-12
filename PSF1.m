close all;
clear all;

%% ���벢��ʾͼ��
filename = 'C:\Users\10310\Desktop\010635.png';
I = imread(filename);

figure
imshow(uint8(I));
title('ԭͼ');%figure1

%% �����˶�ģ��ͼ��
PSF = fspecial('motion',21, 11);
g = imfilter(I, PSF, 'circular');
figure 
imshow(uint8(g));
title('�˶�ģ��ͼ');%figure2

%% ���˶�ģ��ͼ����лҶȻ��������ж�ά���ٸ���Ҷ�任��������Ƶ��ͼ

gb=g;
figure
imshow(uint8(gb));%figure3
PQ = paddedsize(size(gb));
F = fft2(gb, PQ(1), PQ(2));
figure
imshow(uint8(F));%figure4

%% ������Ƶ��
F1 = log(1+abs(F));
F2 = abs(F1).^2;
F3 = real(ifft2(F2));
figure
imshow(uint8(F3));%figure5


%% ����Ƶ��ѹ��������
H = log(1+abs(F3)); % ����Ƶ�׶�̬��Χ����ѹ��
Hc = fftshift(H); % ��ѹ���������ѭ����λ��ʹ��Ƶ�ɷ־���
figure
imshow(uint8(Hc));%figure6

%% ͨ����ֵ������Ե��⡰canny�����Ӷ�ֵ����Ƶ��
T = graythresh(Hc);
bw=edge(Hc, 'canny', T);
figure
imshow(bw);%figure7

%% �Ե�Ƶ�״�1�㵽180����radon�任�������ģ���Ƕ�
theta = 1:180;
R = radon(bw, theta);
figure
imshow(R);%figure8

%% �����ͨ����Ƶ��radon�任���Ƴ���ģ���Ƕ�
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