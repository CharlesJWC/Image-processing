clear; %close all;  % ������ ��� �̹��� â �ݱ�

% ���ϴ� �̹��� �ҷ�����
img = imread('fig0.png');   

N = 4; % ���ø� ����

% �̹����� 1/4 ũ��� ���ø� (��ü �߰� ���� �Լ�)
img_lpf_sampled = samp(img, N, 'Gaussian'); 


% �̹����� ���� ũ��� ���� 
img_recon_0th = interp(img_lpf_sampled, N, '0th');             % 0th-order Interpolation ��� 
img_recon_1st = interp(img_lpf_sampled, N, '1st');              % 1st-order Interpolation ��� 
img_recon_2nd = interp(img_lpf_sampled, N, '2nd');             % 2nd-order Interpolation ��� 
img_recon_3rd = interp(img_lpf_sampled, N, '3rd');              % 3rd-order Interpolation ��� 
img_recon_ccv = interp(img_lpf_sampled, N, 'CubicConv');     % Cubic Convolution Interpolation ��� 
img_recon_lcz = interp(img_lpf_sampled, N, 'Lanczos');         % Lanczos Interpolation ���

% �̹��� â ���� (��üȭ��)
figure(99); set(99, 'name', '�̹��� ��ü ��','units','normalized','outerposition', [0 0 1 1]); 

% �� �̹����� subplot���� ���ÿ� ����
subplot(2,4,1); imshow(uint8(img), 'border', 'tight'); title('Original Image');
subplot(2,4,5); imshow(uint8(img_recon_0th), 'border','tight'); title('0th order Interpolation'); 
subplot(2,4,6); imshow(uint8(img_recon_1st), 'border','tight'); title('1st order Interpolation');
subplot(2,4,7); imshow(uint8(img_recon_2nd), 'border','tight'); title('2nd order Interpolation');
subplot(2,4,8); imshow(uint8(img_recon_3rd), 'border','tight'); title('3rd order Interpolation'); 
subplot(2,4,2); imshow(uint8(img_recon_ccv), 'border','tight'); title('Cubic Convolution Interpolation'); 
subplot(2,4,3); imshow(uint8(img_recon_lcz), 'border','tight'); title('Lanczos Interpolation'); 