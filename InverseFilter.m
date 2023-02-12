close all;
clear all;
clc;
% Display the original image.
I = im2double(imread('C:\Users\10310\Desktop\012504.png'));
[hei,wid,~] = size(I);
figure,imshow(I);
title('Original Image (courtesy of MIT)');


% Simulate a motion blur.
LEN = 15;
THETA = 8;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
figure, imshow(blurred);
%title('Blurred Image');
imwrite(blurred,'Blurred.png');

% Inverse filter
If = fft2(blurred);
Pf = fft2(PSF,hei,wid);
deblurred = ifft2(If./Pf);
figure, imshow(deblurred); 
%title('Restore Image')
imwrite(deblurred,'InverseFilterWithoutNoise.png');

% Simulate additive noise.
noise_mean = 0;
noise_var = 0.001;
noise_var2=0.0002;
blurred_noisy = imnoise(blurred, 'gaussian', ...
                        noise_mean, noise_var);
figure, imshow(blurred_noisy)
imwrite(blurred_noisy,'BlurredWithNoise.png')

only_noise=imnoise(I, 'gaussian', ...
                        noise_mean, noise_var2);
figure,imshow(only_noise);
imwrite(only_noise,'WienerFilerWithNoise.png');
%title('Simulate Blur and Noise')

% Try restoration assuming no noise.
If = fft2(blurred_noisy);
deblurred2 = ifft2(If./Pf);
figure, imshow(deblurred2)
%title('Restoration of Blurred Assuming No Noise');
imwrite(deblurred2,'InverseFilterWithNoise.png');

% Try restoration with noise is known.
noisy = blurred_noisy - blurred;
Nf = fft2(noisy);
deblurred2 = ifft2(If./Pf - Nf./Pf);
figure, imshow(deblurred2)
title('Restoration of Blurred with Noise Is Known')
