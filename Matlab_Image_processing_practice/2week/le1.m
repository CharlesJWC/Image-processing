%% 
% 1/N (N = 4) ������� Sampling �� �̹�����
% 0th ~ 3rd order interpolation ����� ���� ����Ͽ� Reconstruction �ϱ�
%
% �� 2018 ���߿�. All Right Reserved.
%% 
% Step1 : �̹����� �ҷ��ͼ� Gaussian LPF�� �����Ͽ� 1/N ũ��� ���ø� �ϱ�
% Step1-1 : �̹��� �ҷ�����
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
Imn=Imn+1; figure(Imn);  set(Imn, 'name', '���� �̹���'); % �̹��� â ����
set(Imn,'units','normalized','outerposition',[0 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
imshow(uint8(img), 'border', 'tight') % �̹��� ũ�⿡ ���߾� ���
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

%Imn=Imn+1;figure(Imn); set(Imn, 'name', 'LPF�� ������ �̹���'); imshow(uint8(img_lpf))
%Imn=Imn+1;figure(Imn); set(Imn, 'name', 'LPF�� ������ �ٿ���ø�');imshow(uint8(img_lpf_sampled))
%%
% Step2 : 0th ~ 3rd order Interpolation�� Cubic Convolution�� ���� �����Ͽ� Reconstruction ����
% Step2-1 : ���� ���� ����

% ���� ���� ���̸� ���� �� �̹��� ����
img_recon_0th_col = zeros(H/N,W,D); 
img_recon_1st_col = zeros(H/N,W,D); % (�̹��� ó�� ����� ���ϱ� ���Ͽ� 1st �߰�)
img_recon_2nd_col = zeros(H/N,W,D);
img_recon_3rd_col = zeros(H/N,W,D);
img_recon_cubconv_col = zeros(H/N,W,D);

% �ٿ���ø��� �����͸� N�������� ���η� �Է�
img_recon_0th_col(:, 1:N:W, :) = img_lpf_sampled;
img_recon_1st_col(:, 1:N:W, :) = img_lpf_sampled;
img_recon_2nd_col(:, 1:N:W, :) = img_lpf_sampled;
img_recon_3rd_col(:, 1:N:W, :) = img_lpf_sampled;
img_recon_cubconv_col(:, 1:N:W, :) = img_lpf_sampled;

% ���� �׵θ� ������ ���Ͽ� �ٷ� �ٹ��� ���� �����Ͽ� ����ִ� ù��° �� ������ ��� 
img_recon_0th_col(:, 1, :) = img_lpf_sampled(:, 1+N, :);
img_recon_1st_col(:, 1, :) = img_lpf_sampled(:, 1+N, :);
img_recon_2nd_col(:, 1, :) = img_lpf_sampled(:, 1+N, :);
img_recon_3rd_col(:, 1, :) = img_lpf_sampled(:, 1+N, :);
img_recon_cubconv_col(:, 1, :) = img_lpf_sampled(:, 1+N, :);

% Imn=Imn+1;figure(Imn); set(Imn, 'name', 'Interpolation & Cubic Convolution ���� ������');imshow(uint8(img_recon_0th_col))

for i = 1:H/N % 1/N ��� �̹��� ���� �ȼ� ����
    for j = 1:N:W % ���� �̹����� ���� �ȼ� ����
        
        % 0th order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 2�� ������ �ȼ� ���� �ʿ�
        
        x1_0th = img_recon_0th_col(i,j,:); % ���� ��ǥ �ȼ���

        % x2 ����
        if j+N > W % �̹����� ������ ����� ���
             x2_0th = x1_0th; % ���� ��ǥ �ȼ� ���� ���� ��ǥ �ȼ����� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x2_0th = img_recon_0th_col(i,j+N,:); % ���� ��ǥ�� �ִ� �ȼ� ���� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 0th order Interpolation ���� ����
        for k = 1:N-1 
            if k < N/2 % x1�� x2 ��� �� �̸��� ��� x1���� ����
                img_recon_0th_col(i,j+k,:) = x1_0th;
            else % x1�� x2 ��� �� �̻��� ��� x2�� ���� 
                img_recon_0th_col(i,j+k,:) = x2_0th; 
            end
        end
        
        
        % 1st order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 2�� ������ �ȼ� ���� �ʿ�
        
        x1_1st = img_recon_1st_col(i,j,:); % ���� ��ǥ �ȼ���
        
        % x2 ����
        if j+N > W % �̹����� ������ ����� ���
             x2_1st = x1_1st; % ���� ��ǥ �ȼ� ���� ���� ��ǥ �ȼ����� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x2_1st = img_recon_1st_col(i,j+N,:); % ���� ��ǥ�� �ִ� �ȼ� ���� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 1th order Interpolation ���� ����
        for k = 1:N-1 
             img_recon_1st_col(i,j+k,:) = (1-k/4)*x1_1st+(k/4)*x2_1st;
        end
      
        % 2nd order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if j-N < 0 % �̹����� ������ ����� ���
            x1_2nd = img_recon_2nd_col(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_2nd = img_recon_2nd_col(i,j-N,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_2nd = img_recon_2nd_col(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if j+N > W % �̹����� ������ ����� ���
             x3_2nd = x2_2nd; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_2nd = img_recon_2nd_col(i,j+N,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if j+2*N > W % �̹����� ������ ����� ���
             x4_2nd = x3_2nd; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_2nd = img_recon_2nd_col(i,j+2*N,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 2nd order Interpolation ���� ����
        for k = 1:N-1 
            if k < N/2 % x1�� x2�� ��� �� �̸��� ��� 
                img_recon_2nd_col(i,j+k,:) = (0.5*(k/N - 0.5)^2).*x1_2nd ...  % x1�� ���� �� 
                                                           + (3/4 - k/N^2).*x2_2nd ...       % x2�� ���� ��
                                                           + (0.5*( k/N + 0.5)^2).*x3_2nd; % x3�� ���� ��
                % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .*�� .^ ������ ���
                % x2�� �߽����� x1�� x3�� ���� ���� ����ϱ� ���Ͽ� ���� x+1, x-1�� �����̵�    
            else % x1�� x2�� ��� ���̻��� ��� 
                img_recon_2nd_col(i,j+k,:) = (0.5*(k/N - 1.5)^2).*x2_2nd ...    % x2�� ���� �� 
                                                           + (3/4 - (k/N - 1)^2).*x3_2nd ... % x3�� ���� ��
                                                           + (0.5*(k/N - 0.5)^2).*x4_2nd;   % x4�� ���� ��
                % x2�� �߽����� x3�� x4�� ���� ���� ����ϱ� ���Ͽ� ���� x-1, x-2�� �����̵�
            end
        end
        
        
        % 3rd order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if j-N < 0 % �̹����� ������ ����� ���
            x1_3rd = img_recon_3rd_col(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_3rd = img_recon_3rd_col(i,j-N,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_3rd = img_recon_3rd_col(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if j+N > W % �̹����� ������ ����� ���
             x3_3rd = x2_3rd; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_3rd = img_recon_3rd_col(i,j+N,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if j+2*N > W % �̹����� ������ ����� ���
             x4_3rd = x3_3rd; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_3rd = img_recon_3rd_col(i,j+2*N,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 3rd order Interpolation ���� ����
        for k = 1:N-1 
            img_recon_3rd_col(i,j+k,:) = ((1/6)*(1 - k/N)^3).*x1_3rd ...                                 % x1�� ���� �� 
                                                       + (2/3 + 0.5*(k/N)^3 - (k/N)^2).*x2_3rd ...              % x2�� ���� ��
                                                       + (2/3 - 0.5*(k/N-1)^3 - (k/N-1)^2).*x3_3rd ...       % x3�� ���� ��
                                                       + ((1/6)*(k/N)^3).*x4_3rd;                                     % x4�� ���� ��
            % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .*�� .^ ������ ���
            % x2�� �߽����� x1, x3, x4�� ���� ���� ����ϱ� ���Ͽ� ���� x+1, x-1, x-2�� �����̵�
        end
        
        
        % Cubic Convolution ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if j-N < 0 % �̹����� ������ ����� ���
            x1_cubconv = img_recon_cubconv_col(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_cubconv = img_recon_cubconv_col(i,j-N,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_cubconv = img_recon_cubconv_col(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if j+N > W % �̹����� ������ ����� ���
             x3_cubconv = x2_cubconv; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_cubconv = img_recon_cubconv_col(i,j+N,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if j+2*N > W % �̹����� ������ ����� ���
             x4_cubconv = x3_cubconv; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_cubconv = img_recon_cubconv_col(i,j+2*N,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� Cubic Convolution ���� ����
        
        a = -0.5; % �Ķ���� 
        
        for k = 1:N-1 
            img_recon_cubconv_col(i,j+k,:) = x1_cubconv.*(a*(k/N)^3 - 2*a*(k/N)^2 + a*(k/N)) ...                 % x1�� ���� �� 
                                                           + x2_cubconv.*((a+2)*(k/N)^3 - (3+a)*(k/N)^2+1) ...                 % x2�� ���� ��
                                                           + x3_cubconv.*(-1*(a+2)*(k/N)^3 + (2*a+3)*(k/N)^2-a*(k/N)) ...   % x3�� ���� ��
                                                           + x4_cubconv.*(-a*(k/N)^3 + a*(k/N)^2);                                 % x4�� ���� ��
            % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .* ������ ���
        end
        
    end
end

% Imn=Imn+1;figure(Imn); set(Imn, 'name', '0th ���� ������'); imshow(uint8(img_recon_0th_col))
% Imn=Imn+1;figure(Imn); set(Imn, 'name', '1st ���� ������'); imshow(uint8(img_recon_1st_col))
% Imn=Imn+1;figure(Imn); set(Imn, 'name', '2nd ���� ������'); imshow(uint8(img_recon_2nd_col))
% Imn=Imn+1;figure(Imn); set(Imn, 'name', '3rd ���� ������'); imshow(uint8(img_recon_3rd_col))
% Imn=Imn+1;figure(Imn); set(Imn, 'name', 'cubconv ���� ������'); imshow(uint8(img_recon_cubconv_col))

%%
% Step2-2 : ���� ���� ����

% ���� ����� ���� �� �̹��� ����
img_recon_0th_row = zeros(H,W,D);  
img_recon_1st_row = zeros(H,W,D);  
img_recon_2nd_row = zeros(H,W,D);  
img_recon_3rd_row = zeros(H,W,D);  
img_recon_cubconv_row = zeros(H,W,D);  

% ���η� 0th ~ 3rd order Interpolation�� ������ �����͸� ���� N�������� ���η� �Է�
img_recon_0th_row(1:N:H, :, :) = img_recon_0th_col; 
img_recon_1st_row(1:N:H, :, :) = img_recon_1st_col; 
img_recon_2nd_row(1:N:H, :, :) = img_recon_2nd_col; 
img_recon_3rd_row(1:N:H, :, :) = img_recon_3rd_col;
img_recon_cubconv_row(1:N:H, :, :) = img_recon_3rd_col;

% ��� �׵θ� ������ ���Ͽ� �ٷ� �ٹ��� ���� �����Ͽ� ����ִ� ù��° �� ������ ���
img_recon_0th_row(1, :, :) = img_recon_0th_col(1+N, :, :); 
img_recon_1st_row(1, :, :) = img_recon_1st_col(1+N, :, :); 
img_recon_2nd_row(1, :, :) = img_recon_2nd_col(1+N, :, :); 
img_recon_3rd_row(1, :, :) = img_recon_3rd_col(1+N, :, :); 
img_recon_cubconv_row(1, :, :) = img_recon_3rd_col(1+N, :, :); 
 
%Imn=Imn+1;figure(Imn); set(Imn, 'name', '0th ���� ������');imshow(uint8(img_recon_0th_row))
%Imn=Imn+1;figure(Imn); set(Imn, 'name', '1st ���� ������');imshow(uint8(img_recon_1st_row))
%Imn=Imn+1;figure(Imn); set(Imn, 'name', '2nd ���� ������');imshow(uint8(img_recon_2nd_row))
%Imn=Imn+1;figure(Imn); set(Imn, 'name', '3rd ���� ������');imshow(uint8(img_recon_3rd_row))
%Imn=Imn+1;figure(Imn); set(Imn, 'name', 'cubconv ���� ������');imshow(uint8(img_recon_cubconv_row))

for i = 1:N:H % ���� �̹����� ���� �ȼ� ����
    for j = 1:W % ���� �̹����� ���� �ȼ� ����
         
        % 0th order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 2�� ������ �ȼ� ���� �ʿ�
        
        x1_0th = img_recon_0th_row(i,j,:); % ���� ��ǥ �ȼ���

        % x2 ����
        if i+N > H % �̹����� ������ ����� ���
             x2_0th = x1_0th; % ���� ��ǥ �ȼ� ���� ���� ��ǥ �ȼ����� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x2_0th = img_recon_0th_row(i+N,j,:); % ���� ��ǥ�� �ִ� �ȼ� ���� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 0th order Interpolation ���� ����
        for k = 1:N-1 
            if k < N/2 % x1�� x2 ��� �� �̸��� ��� x1���� ����
                img_recon_0th_row(i+k,j,:) = x1_0th;
            else % x1�� x2 ��� �� �̻��� ��� x2�� ���� 
                img_recon_0th_row(i+k,j,:) = x2_0th; 
            end
        end
        
        
        % 1st order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 2�� ������ �ȼ� ���� �ʿ�
        
        x1_1st = img_recon_1st_row(i,j,:); % ���� ��ǥ �ȼ���
        
        % x2 ����
        if i+N > H % �̹����� ������ ����� ���
             x2_1st = x1_1st; % ���� ��ǥ �ȼ� ���� ���� ��ǥ �ȼ����� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x2_1st = img_recon_1st_row(i+N,j,:); % ���� ��ǥ�� �ִ� �ȼ� ���� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 1th order Interpolation ���� ����
        for k = 1:N-1 
             img_recon_1st_row(i+k,j,:) = (1-k/N)*x1_1st+(k/N)*x2_1st;
        end
      
        % 2nd order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if i-N < 0 % �̹����� ������ ����� ���
            x1_2nd = img_recon_2nd_row(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_2nd = img_recon_2nd_row(i-N,j,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_2nd = img_recon_2nd_row(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if i+N > H % �̹����� ������ ����� ���
             x3_2nd = x2_2nd; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_2nd = img_recon_2nd_row(i+N,j,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if i+2*N > H % �̹����� ������ ����� ���
             x4_2nd = x3_2nd; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_2nd = img_recon_2nd_row(i+2*N,j,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 2nd order Interpolation ���� ����
        for k = 1:N-1 
            if k < N/2 % x1�� x2�� ��� �� �̸��� ��� 
                img_recon_2nd_row(i+k,j,:) = (0.5*(k/N - 0.5)^2).*x1_2nd ...  % x1�� ���� �� 
                                                           + (3/4 - k/N^2).*x2_2nd ...       % x2�� ���� ��
                                                           + (0.5*( k/N + 0.5)^2).*x3_2nd; % x3�� ���� ��
                % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .*�� .^ ������ ���
                % x2�� �߽����� x1�� x3�� ���� ���� ����ϱ� ���Ͽ� ���� x+1, x-1�� �����̵�    
            else % x1�� x2�� ��� ���̻��� ��� 
                img_recon_2nd_row(i+k,j,:) = (0.5*(k/N - 1.5)^2).*x2_2nd ...    % x2�� ���� �� 
                                                           + (3/4 - (k/N - 1)^2).*x3_2nd ... % x3�� ���� ��
                                                           + (0.5*(k/N - 0.5)^2).*x4_2nd;   % x4�� ���� ��
                % x2�� �߽����� x3�� x4�� ���� ���� ����ϱ� ���Ͽ� ���� x-1, x-2�� �����̵�
            end
        end
        
        
        % 3rd order Interpolation ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if i-N < 0 % �̹����� ������ ����� ���
            x1_3rd = img_recon_3rd_row(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_3rd = img_recon_3rd_row(i-N,j,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_3rd = img_recon_3rd_row(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if i+N > H % �̹����� ������ ����� ���
             x3_3rd = x2_3rd; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_3rd = img_recon_3rd_row(i+N,j,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if i+2*N > H % �̹����� ������ ����� ���
             x4_3rd = x3_3rd; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_3rd = img_recon_3rd_row(i+2*N,j,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� 3rd order Interpolation ���� ����
        for k = 1:N-1 
            img_recon_3rd_row(i+k,j,:) = ((1/6).*(1 - k/N).^3).*x1_3rd ...                               % x1�� ���� �� 
                                                       + (2/3 + 0.5.*(k/N).^3 - (k/N).^2).*x2_3rd ...              % x2�� ���� ��
                                                       + (2/3 - 0.5.*(k/N-1).^3 - (k/N-1).^2).*x3_3rd ...       % x3�� ���� ��
                                                       + ((1/6).*(k/N).^3).*x4_3rd;                                     % x4�� ���� ��
            % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .*�� .^ ������ ���
            % x2�� �߽����� x1, x3, x4�� ���� ���� ����ϱ� ���Ͽ� ���� x+1, x-1, x-2�� �����̵�
        end
        
        
        % Cubic Convolution ���� �˰��� ----------------------------------------
        % ���� ������ ���� 4�� ������ �ȼ� ���� �ʿ�
        
        % x1 ����
        if i-N < 0 % �̹����� ������ ����� ���
            x1_cubconv = img_recon_cubconv_row(i,j,:); % ���� ��ǥ�� �ȼ����� �����ϰ� ó��
        else
            x1_cubconv = img_recon_cubconv_row(i-N,j,:); % ���� ��ǥ�� �ȼ��� ����
        end
        
        x2_cubconv = img_recon_cubconv_row(i,j,:); % ���� ��ǥ �ȼ���
        
        % x3 ����
        if i+N > H % �̹����� ������ ����� ���
             x3_cubconv = x2_cubconv; % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x3_cubconv = img_recon_cubconv_row(i+N,j,:); % ���� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x4 ����
        if i+2*N > H % �̹����� ������ ����� ���
             x4_cubconv = x3_cubconv; % ���� �������� ���� ��ǥ �ȼ� ���� �����ϰ� ó��
        else % �̹����� ���� ���� ���
             x4_cubconv = img_recon_cubconv_row(i+2*N,j,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
        end
        
        % x1�� x2 ������ �ȼ��� ���Ͽ� Cubic Convolution ���� ����
        
        a = -0.5; % �Ķ���� 
        
        for k = 1:N-1
            img_recon_cubconv_row(i+k,j,:) = x1_cubconv.*(a*(k/N)^3 - 2*a*(k/N)^2+a*(k/N)) ...               % x1�� ���� �� 
                                                           + x2_cubconv.*((a+2)*(k/N)^3 - (a+3)*(k/N)^2+1) ...                 % x2�� ���� ��
                                                           + x3_cubconv.*(-1*(a+2)*(k/N)^3 + (2*a+3)*(k/N)^2-a*(k/N)) ...   % x3�� ���� ��
                                                           + x4_cubconv.*(-a*(k/N)^3 + a*(k/N)^2);                                 % x4�� ���� ��
                                                            % RGB 3���� ���� ���� ����ϱ� ���Ͽ� .* ������ ���
        end
        
    end
end


Imn=Imn+1;figure(Imn); set(Imn, 'name', '0th order Interpolation Reconstruction'); 
set(Imn,'units','normalized','outerposition',[0.15 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��) 
imshow(uint8(img_recon_0th_row), 'border','tight')
Imn=Imn+1;figure(Imn); set(Imn, 'name', '1st order Interpolation Reconstruction');
set(Imn,'units','normalized','outerposition',[0.3 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
imshow(uint8(img_recon_1st_row), 'border','tight')
Imn=Imn+1;figure(Imn); set(Imn, 'name', '2nd order Interpolation Reconstruction');
set(Imn,'units','normalized','outerposition',[0.45 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
imshow(uint8(img_recon_2nd_row), 'border','tight')
Imn=Imn+1;figure(Imn); set(Imn, 'name', '3rd order Interpolation Reconstruction');
set(Imn,'units','normalized','outerposition',[0.6 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
imshow(uint8(img_recon_3rd_row), 'border','tight')
Imn=Imn+1;figure(Imn); set(Imn, 'name', 'Cubic Convolution Reconstruction'); 
set(Imn,'units','normalized','outerposition',[0.75 1 (W-10)/scrWH(3) H/scrWH(4)]); % â ��ħ ������ ���� ��ġ ����(%��)
imshow(uint8(img_recon_cubconv_row), 'border','tight')

Imn=Imn+1;figure(Imn); set(Imn, 'name', '�̹��� ��ü ��');
set(Imn,'units','normalized','outerposition',[0 0 1 1]); 
subplot(2,3,1); imshow(uint8(img), 'border', 'tight'); title('Original Image');
subplot(2,3,2); imshow(uint8(img_recon_0th_row), 'border','tight'); title('0th order Interpolation'); 
subplot(2,3,3); imshow(uint8(img_recon_1st_row), 'border','tight'); title('1st order Interpolation');
subplot(2,3,4); imshow(uint8(img_recon_2nd_row), 'border','tight'); title('2nd order Interpolation');
subplot(2,3,5); imshow(uint8(img_recon_3rd_row), 'border','tight'); title('3rd order Interpolation'); 
subplot(2,3,6); imshow(uint8(img_recon_cubconv_row), 'border','tight'); title('Cubic Convolution'); 