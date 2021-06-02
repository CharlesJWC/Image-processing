close all; clear; clc;

img = imread('fig0.png'); % fig0.png �̹��� ���� �ҷ��ͼ� img�� �����ϱ�
img = double(img); % img�� �����͸� �Ǽ������� ��ȯ (�Ǽ����� ������ ����)
[H, W, D] = size(img); % �ҷ��� �̹��� ũ�� ���� (Height, Width, Dimension)
scrWH = get(0, 'screensize'); % â ��ġ ������ ���� ��ũ�� ������ ����


N = 4; % downsizing ���

img_sampled = img(1:N:end, 1:N:end,:); 
% Low Pass Filter �������� �ʰ� ���ø��� ��� -> �ȼ� ������ ���� ���̰� ū ��� �̹����� ��ĥ�� ����
% Simple downsampling �̶�� ��

Imn = 0; % Image number : â ������ ����
% Imn=Imn+1; figure(Imn);  set(Imn, 'name', '���� �̹���'); % �̹��� â ����
% set(Imn,'units','normalized','outerposition',[0 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
% imshow(uint8(img), 'border', 'tight') % �̹��� ũ�⿡ ���߾� ���
% figure â�� �̹����� unsigned ���������� ��ȯ�Ͽ� 8bit�� ��� (imshow 8bit ������ ���)
%Imn=Imn+1;figure(Imn); set(Imn, 'name', 'LPF���� Simple �ٿ���ø�'); imshow(uint8(img_sampled))
%%
% Step1-2 : Gaussian LPF ���͸� �����Ͽ� Down ���ø��ϱ�

% lpf = ones(3,3,3)/9;  % Uniform Weight Moving average LPF ����
lpf = [1,2,1; ...
         2,4,2; ...
         1,2,1]/16; % Gaussian LPF ����

img_lpf = zeros(H,W,D); % LPF ���͸� ������ �̹��� ���� ����

for i = 1:H-2   
    for j = 1:W-2
        img_lpf(i+1,j+1,:) = sum(sum( img(i:i+2,j:j+2,:).*lpf, 1),2); 
        % .���� ���Ͽ� 3x3���͸� �����Ͽ� �迭�� ���� ���� �ȼ� ������ ����
        % �׵θ� �ȼ��� ��� ���͸� ������ �ܺ��� ���� ���� ������ �׵θ� ���� ���� ������ ���� ����
    end
end

img_lpf_sampled = img_lpf(1:N:end, 1:N:end,:); % Low Pass Filter�� �����Ͽ� ���ø�

Imn=Imn+1; figure(Imn);  set(Imn, 'name', 'sample'); % �̹��� â ����
imshow(uint8(img_lpf_sampled), 'border', 'tight') % �̹��� ũ�⿡ ���߾� ���
%%
% img_recon_0th = interp_0th_(img_lpf_sampled, N);
img_recon_1st = interp_1st_(img_lpf_sampled, N);
% img_recon_2nd = interp_2nd_(img_lpf_sampled, N);
% img_recon_3rd = interp_3rd_(img_lpf_sampled, N);
% img_recon_ccv = cubic_conv_(img_lpf_sampled, N);
 
Imn=Imn+1;figure(Imn); set(Imn, 'name', '�̹��� ��ü ��');
% set(Imn,'units','normalized','outerposition',[0 0 1 1]); 
subplot(2,3,1); imshow(uint8(img), 'border', 'tight'); title('Original Image');
% subplot(2,3,2); imshow(uint8(img_recon_0th), 'border','tight'); title('0th order Interpolation'); 
subplot(2,3,3); imshow(uint8(img_recon_1st), 'border','tight'); title('1st order Interpolation');
% subplot(2,3,4); imshow(uint8(img_recon_2nd), 'border','tight'); title('2nd order Interpolation');
% subplot(2,3,5); imshow(uint8(img_recon_3rd), 'border','tight'); title('3rd order Interpolation'); 
% subplot(2,3,6); imshow(uint8(img_recon_ccv), 'border','tight'); title('Cubic Convolution'); 