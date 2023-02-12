close all;
clear all;
clc;
% Display the original image.
I = im2double(imread('C:\Users\10310\Desktop\012504.png'));
[hei,wid,~] = size(I);
figure,imshow(I);
title('Original Image (courtesy of MIT)');


% Simulate a motion blur.
LEN = 21;
THETA = 10;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
figure, imshow(blurred); title('Blurred Image');

% Inverse filter
If = fft2(blurred);
Pf = psf2otf(PSF,[hei,wid]);
deblurred = ifft2(If./Pf);
figure, imshow(deblurred); title('Restore Image')

% Simulate additive noise.
noise_mean = 0;
noise_var = 0.00001;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
figure, imshow(blurred_noisy)

title('Simulate Blur and Noise')

% Try restoration using  Home Made Constrained Least Squares Filtering.
p = [0 -1 0;-1 4 -1;0 -1 0];
P = psf2otf(p,[hei,wid]);

gama = 0.001;%Ω®“È÷µ0.001
If = fft2(blurred_noisy);

numerator = conj(Pf);
denominator = Pf.^2 + gama*(P.^2);

deblurred2 = ifft2( numerator.*If./ denominator );
figure, imshow(deblurred2)
imwrite(deblurred2,'LeastFilterWithNoise.png');
%title('Restoration of Blurred Using Constrained Least Squares Filtering');

figure; imshow(deconvreg(blurred_noisy, PSF,0)); title('Regul in Matlab');
