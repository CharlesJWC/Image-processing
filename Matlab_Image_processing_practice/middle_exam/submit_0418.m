%% �̹��� �ҷ����� �� �ʱ� ����
img = imread('nir_img.png');
img = img(1:end-1, :); % 3��� �°� �̹��� �ڸ���
img = double(img);
[H, W] = size(img);

N = 3; % 3���
%% Q1. 1/3 sub-sampling with gaussian LPF

% �̹��� �ܰ� copy padding
img2 = [img(:,1), img, img(:,end)];
img2 = [img2(1,:); img2; img2(end,:)];

% Gaussian ����
lpf = [1 2 1; 2 4 2; 1 2 1]/16;

img_lpf = zeros(H,W);

% Gaussian ���� Convolution ����
for i = 1:H
    for j = 1:W
        img_lpf(i,j) = sum(sum(img2(i:i+2,j:j+2).*lpf));
    end
end

% �̹��� 1/3 ũ��� sub-sampling
img_samp = img_lpf(1:N:end, 1:N:end);

%% Q2-1. Histogram equalizaition

% ������׷� ����
hist = zeros(1, 256);
for i = 1:H/N
    for j = 1:W/N
        hist(uint8(img_samp(i,j))+1) = hist(uint8(img_samp(i,j))+1) +1;
    end
end

% CDF �Լ� ����
cdf = zeros(1,256);
for i = 1:256
    cdf(i) = sum(hist(1:i));
end
cdf = cdf/cdf(end);

% Transfer �Լ� ���� (cdf �ٻ�)
x1 = 184; x2 = 250;
y1 = 0; y2 = 255;

a = (y2-y1)/(x2-x1);
b = -a*x1+y1;
X = 0:255;

Y = max(0, min(255, a.*X+b));

% �̹����� Transfer �Լ� ����
img_eq = Y(uint8(img_samp));

%% ����� ��Ȱȭ �Ǿ����� �׽�Ʈ
% hist_eq = zeros(1, 256);
% for i = 1:H/N
%     for j = 1:W/N
%         hist_eq(uint8(img_eq(i,j))+1) = hist_eq(uint8(img_eq(i,j))+1) +1;
%     end
% end
% 
% 
% cdf_eq = zeros(1,256);
% for i = 1:256
%     cdf_eq(i) = sum(hist_eq(1:i));
% end
% cdf_eq = cdf_eq/cdf_eq(end);
% 
% figure(1); plot(hist_eq); figure(2); plot(cdf_eq);
%% Q2-2. 3-bit quantization

img_qt = zeros(H/N, W/N);

Nbit = 3;

% ����ȭ ������ �Ϲ�ȭ ��Ų �ݺ���
for k = 1:2^Nbit
    img_qt((256/2^Nbit)*(k-1) <= img_eq & img_eq < (256/2^Nbit)*k) = (256/2^Nbit)*(2*k-1)/2;
    % ����ȭ �ܰ��� �߰� ���� ���Ͽ� Error �ּ�ȭ
end
    
%% Q2-3. Inverse Transfer

% Inverse Transfer �Լ� ���� (Inverse cdf �ٻ�)
x1 = 0; x2 = 255;
y1 = 184; y2 = 250;

a = (y2-y1)/(x2-x1);
b = -a*x1+y1;
X = 0:255;

invY = max(0, min(255, a.*X+b));

% �̹����� Inverse Transfer �Լ� ����
img_ivt = invY(uint8(img_qt));

%% Q3. up-sampling with cubic convolution interpolation

% ���� ���� Interpolation 
img_recon = zeros(H/N, W);
img_recon(:, 1:N:W) = img_ivt; 

for i = 1: H/N
    for j = 1:N:W
        
        % �ι�° ��ǥ �ȼ���
        x2 = img_recon(i,j);     
        
        % �̹��� ���� ������ ù��° ��ǥ �ȼ��� ����
        if j - N < 0
            x1 = x2;
        else
            x1 = img_recon(i,j - N);
        end
        
        % �̹��� ���� ������ ����° ��ǥ �ȼ��� ����
        if j + N > W
            x3 = x2;
        else
            x3 = img_recon(i,j + N);
        end
        
        % �̹��� ���� ������ �׹�° ��ǥ �ȼ��� ����
        if j + 2*N > W
            x4 = x3;
        else
            x4 = img_recon(i,j + 2*N);
        end
        
        % x1�� x2 ������ �ȼ� ���� Cubic Convolution�� �̿��Ͽ� Interpolation ����
        a = -0.5;
        for k = 1 : N-1            
            t = k/N;
            img_recon(i,j+k) = (a*t^3 - 2*a*t^2 + a*t)*x1 ...
                                     + ((a+2)*t^3 - (3+a)*t^2 + 1)*x2 ...
                                     + (-(a+2)*t^3 + (2*a+3)*t^2 - a*t)*x3 ...
                                     + (-a*t^3 + a*t^2)*x4;
        end      
    end
end

% ���� ���� Interpolation 
img_recon2 = zeros(H, W);
img_recon2(1:N:H,:) = img_recon; 

for i = 1:N:H
    for j = 1:W
        
        % �ι�° ��ǥ �ȼ���
        x2 = img_recon2(i,j);
        
        % �̹��� ���� ������ ù��° ��ǥ �ȼ��� ����
        if i - N < 0
            x1 = x2;
        else
            x1 = img_recon2(i - N,j);
        end
        
        % �̹��� ���� ������ ����° ��ǥ �ȼ��� ����
        if i + N > H
            x3 = x2;
        else
            x3 = img_recon2(i + N,j);
        end
        
        % �̹��� ���� ������ �׹�° ��ǥ �ȼ��� ����
        if i + 2*N > H
            x4 = x3;
        else
            x4 = img_recon2(i + 2*N,j);
        end
        
        % x1�� x2 ������ �ȼ� ���� Cubic Convolution�� �̿��Ͽ�  Interpolation ����
        a = -0.5;
        for k = 1 : N-1
            t = k/N;
            img_recon2(i+k,j) = (a*t^3 - 2*a*t^2 + a*t)*x1 ...
                                     + ((a+2)*t^3 - (3+a)*t^2 + 1)*x2 ...
                                     + (-(a+2)*t^3 + (2*a+3)*t^2 - a*t)*x3 ...
                                     + (-a*t^3 + a*t^2)*x4;
        end
    end
end

%% Q4. Quantization Error (PSNR)

% Mean Square Error
MSE = sum(sum(img-img_recon2))/length(img(:));
% PSNR Error
qt_error = 10*log10(255^2/MSE);
disp(['Quantization Error (MSE) : ', num2str(MSE)]);
disp(['Quantization Error (PSNR) : ', num2str(qt_error)]);

%% Result Plot
figure(100);
subplot(2,4,1); imshow(uint8(img)); title('Original Image');
subplot(2,4,2); imshow(uint8(img_samp)); title('Sub-Sampling Image with Gaussian LPF');
subplot(2,4,3); plot(hist); title('Image Histogram');
subplot(2,4,4); plot(X,Y/255, X, cdf); title('Transfer Function');
subplot(2,4,5); imshow(uint8(img_eq)); title('Historam Equalized Image');
subplot(2,4,6); imshow(uint8(img_qt)); title('3-bit Quantized Image');
subplot(2,4,7); imshow(uint8(img_ivt)); title('Inverse Transform Image');
subplot(2,4,8); imshow(uint8(img_recon2)); title('Reconstruction Image');
xlabel(['Quantization Error : ', num2str(MSE),' (MSE)   ', num2str(qt_error),' (PSNR)']);

%% Result Image Save
imwrite(uint8(img_recon2), 'output_12131448.bmp');
