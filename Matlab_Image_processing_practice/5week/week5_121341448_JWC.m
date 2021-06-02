%% 5week HW : Histogram Equalization & Uniform Quantization
%    Copyright 2018, Jungwon Choi, INHA Electronics
close all; clear; clc;

img = imread('fig1.tif');
%img = rgb2gray(img);
img = double(img);
[H, W] = size(img);

N = 5; % 1~N bit ���� 

%% 1. compute histogram %%
% �̹����� �ȼ����� ���� ī��Ʈ

hist = zeros(256,1);
for i = 1:H
    for j = 1:W
        hist(img(i,j)+1) = hist(img(i,j)+1)+1;
        % ������ ���� �ε����� 1���� �̱� ������ +1 ����
    end
end
hist = hist/sum(hist); % Normalization ����

% ����1�� ������ ���� ��ü ���� >> hist = imhist(img)/numel(img);

%% 2. get transformaion function %%
% Transformation �Լ� : cumulative sum of normalized histogram values
% (Cumulative Distribution Function Ȱ��)

% cdf �Լ� ����
cdf = zeros(256 , 1);
for i = 1:256
    cdf(i) = sum(hist(1:i));
    % �ȼ��� ī��Ʈ ���� �����ؼ� ����
end
cdf = cdf/cdf(end);

% ����2�� ������ ���� ��ü ���� >> cdf = cumsum(hist); 

%% 3. histogram equalization %%

% cdf�� equalization ����
img_eq = uint8((255.0*cdf(uint8(img)+1)));
% cdf �Լ� ����� 0 ~ 1 �̹Ƿ� �ȼ����� �����ϵ��� 255 �� ����

%% (Supplementary) 
% �񱳸� ���� cdf �ٻ� ���� �Լ��� equalization ����
X = 0:255;
Y_eqf =  LinearTransF(X); 
img_eql = uint8((Y_eqf(uint8(img)+1)));
% ������ ���� ��ü ���� >> img_eql = max(y1,min(y2, ((y2-y1)/(x2-x1))*(img-x1)+y1));

%%%%%%%%%% ��ȯ ��� Ȯ�� %%%%%%%%%%
hist_eq = imhist(img_eq)./numel(img_eq);
cdf_eq = cumsum(hist_eq);
hist_eql = imhist(img_eql)./numel(img_eql);
cdf_eql = cumsum(hist_eql);

figure(100); set(100, 'name', 'Equalization result comparation','units','normalized','outerposition', [0 0 1 1]);
subplot(3,3,1); imshow(uint8(img)); title('Original Image');
subplot(3,3,2); plot(hist);xlim([1 256]);
subplot(3,3,3); plot(X, cdf, 'b', X, Y_eqf/255, 'r'); xlim([1 256]); 
subplot(3,3,4); imshow(uint8(img_eq)); title('historam equalization Image (cdf)');
subplot(3,3,5); plot(hist_eq);xlim([1 256]);
subplot(3,3,6); plot(cdf_eq);xlim([1 256]);
subplot(3,3,7); imshow(uint8(img_eql)); title('historam equalization Image (linear cdf function)');
subplot(3,3,8); plot(hist_eql);xlim([1 256]);
subplot(3,3,9); plot(cdf_eql);xlim([1 256]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. uniform quantization
% ������׷� ��Ȱȭ�� �̹����� ���� �̹����� ���� uniform quantization ����

img_just_uniqnt = zeros(H,W,N);       % �� bitrate�� uniform quantization�� �̹����� ������ ���� (Original image)
img_hist_uniqnt = zeros(H,W,N);       % �� bitrate�� uniform quantization�� �̹����� ������ ���� (Histgram equalized image)

for Nbit = 1:N                                   % 1~N bitrate�� quantizaion 
    img_temp1 = zeros(H,W);             % ������ ���� �ӽ� �̹��� ���� ���� (Original image)
    img_temp2 = zeros(H,W);             % ������ ���� �ӽ� �̹��� ���� ���� (Histgram equalized image)
    for k = 1 : 2^Nbit                         % Quantizaion Step
        img_temp1(round((256/2^Nbit)*(k-1)) <= img & img < round((256/2^Nbit)*k)) = round((256/2^Nbit)*(2*k-1)/2);
        img_temp2(round((256/2^Nbit)*(k-1)) <= img_eq & img_eq < round((256/2^Nbit)*k)) = round((256/2^Nbit)*(2*k-1)/2);
        % ���ǽ����� encoder mapping �� �� �� boundary�� �߰� ���� �����Ͽ� decoder mapping
        % �ִ� �ȼ����� 255�� ����ȭ ������ �����ϱ� ���Ͽ� ������ ������ img < 256���� ����
    end
    img_just_uniqnt(:,:,Nbit) = img_temp1;  % �ش� bitrate�� uniform quantization�� ������ �̹��� ��� ���� (Original image)
    img_hist_uniqnt(:,:,Nbit) = img_temp2;  % �ش� bitrate�� uniform quantization�� ������ �̹��� ��� ���� (Histgram equalized image)
end


%% 5. inverse transform %%

invcdf = inverseF(cdf);
% inverse transform�� ���� cdf�� ���Լ��� ����

img_hist_uniqnt_inv = uint8((255.0*invcdf(uint8(img_hist_uniqnt)+1)));
% �� �̹������� inverse transform ����

figure(150); figure(150); set(150, 'name', 'Inverse result');
plot(X, cdf , 'b-'); hold on; 
plot(X, invcdf, 'r-' ); hold off;
legend('Transformaion Function', 'Inverse Transformaion Function'); xlim([0,255]); ylim([0,1]);
%% 6. Calculate quantization error %%
err_just_uniqnt = zeros(1,N);    % �� Bitrate�� ���� quantization error (RMSQE) (Original image)
err_hist_uniqnt = zeros(1,N);    % �� Bitrate�� ���� quantization error (RMSQE) (Histgram equalized image)

for Nbit = 1:N
    % quantization error (RMSE) ����
    err_just_uniqnt(Nbit) = sqrt(sum(sum((img-double(img_just_uniqnt(:,:,Nbit))).^2))/length(img(:))); 
    err_hist_uniqnt(Nbit) = sqrt(sum(sum((img-double(img_hist_uniqnt_inv(:,:,Nbit))).^2))/length(img(:))); 
end

%% 7. Display the result %%

figure(200); set(200, 'name', 'Histogram Equalization Quantization result comparation','units','normalized','outerposition', [0 0 1 1]);
subplot(3,N,1); imshow(uint8(img)); title('Original Image');
for ll = 1:N
    subplot(3,N, N+ll); imshow(uint8(img_just_uniqnt(:,:,ll))); title(['Unifrom ',num2str(ll),'bit quantization']); xlabel(['quantization error (RMSE) : ',num2str(err_just_uniqnt(ll))]);
    subplot(3,N, 2*N+ll); imshow(uint8(img_hist_uniqnt_inv(:,:,ll))); title(['Histogram Equalization ',num2str(ll),'bit quantization']); xlabel(['quantization error (RMSE) : ',num2str(err_hist_uniqnt(ll))]);
end
subplot(3,N,2); plot(1:N, err_just_uniqnt, 'b', 1:N, err_hist_uniqnt, 'r' ); % bitrate�� ���� Quantization error ��ȭ 
title('Quantization Error (RSME) of Image'); xlabel('Quantized Bitrate'); ylabel('Quantization Error (RMSE)');
xlim([0 N+1]); ylim('auto'); legend('Uniform quantization', 'Histogram equalizaion quantizatioin');