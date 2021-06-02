%% 4week HW Uniform & Non-uniform Quantization
%    Copyright 2018, Jungwon Choi, INHA Electronics
close all; clear;

img = imread('fig2.jpg');   % ���ϴ� �̹����� �ҷ�����
img = rgb2gray(img);        % �̹����� ������� ��ȯ
img = double(img);            % ������ ���� �ȼ� ���� �Ǽ������� ��ȯ

[H, W] = size(img);            % �̹����� ũ�� ����
N = 7;                               % Ȯ���� ����ȭ Bits (1~N bit) 
%% Uniform Quantization

img_nbit_uni = zeros(H,W,N);    % �� Bitrate�� Uniform Quantization�� �̹����� ������ ����
X = 1 : 255;                              % Quantization Function�� X��
Y_uni = zeros(length(X),N);       % �� Bitrate�� ���� Quantization Function [Y = Q(X)]
err_nbit_uni = zeros(1,N);           % �� Bitrate�� ���� Quantization Error (RMSE)

for Nbit = 1:N  % 1~N Bitrate�� Quantizaion 
    img_temp = zeros(H,W);  % ������ ���� �ӽ� �̹��� ���� ����
    for k = 1 : 2^Nbit % Quantizaion Step
        img_temp(round((256/2^Nbit)*(k-1)) <= img & img < round((256/2^Nbit)*k)) = round((256/2^Nbit)*(2*k-1)/2);
        % ���ǽ����� Encoder Mapping �� �� �� boundary�� �߰� ���� �����Ͽ� Decoder Mapping
        % �ִ� �ȼ����� 255�� ����ȭ ������ �����ϱ� ���Ͽ� ������ ������ img < 256���� ����
        Y_uni(round((256/2^Nbit)*(k-1)) <= X & X < round((256/2^Nbit)*k), Nbit) = round((256/2^Nbit)*(2*k-1)/2);
        % �ش� Bitrate�� ���� X�� ���� Quantization Function ����
    end
    img_nbit_uni(:,:,Nbit) = img_temp;  % �ش� Bitrate�� Uniform Quantization�� ������ �̹��� ��� ����
    err_nbit_uni(1,Nbit) = sqrt(sum(sum((img-img_nbit_uni(:,:,Nbit)).^2))/length(img(:))); % Quantization Error (RMSE) ����
end

% Bitrate�� ���� Quantization Function ���
figure(50); set(50, 'name', ['Uniform Quantization Function 1-',num2str(N),'bit'],'units','normalized','outerposition', [0 0 1 1]);
for Nbit = 1:N 
    subplot(2,4,Nbit); plot(X, Y_uni(:,Nbit)); xlim([0 255]); ylim([0 255]); title([num2str(Nbit),'-bit Uniform Quantizaion Function']); 
end
subplot(2,4,N+1); histogram(img(:),length(X),'Normalization','probability');
title('Histogram of image'); xlabel('Pixel Value'); ylabel('Numer of Value (%)'); xlim([0 255]);

% Bitrate�� ���� Quantization Image ���
figure(51); set(51, 'name', ['Uniform Quantization Image 1-',num2str(N),'bit'],'units','normalized','outerposition', [0 0 1 1]);
for Nbit = 1:N 
    subplot(2,4,Nbit); imshow(uint8(img_nbit_uni(:,:,Nbit))); title([num2str(Nbit),'-bit Uniform Quantizaion Image']); 
    xlabel(['Quantization ERR (RMSE) = ', num2str(err_nbit_uni(Nbit))]);
end
subplot(2,4,N+1); imshow(uint8(img)); title('Original Image'); 

%% Non-uniform Quantization (��հ��� �̿�)

% �̹����� Bitrate�� ���� Threshold ���� �ڵ����� �����ϴ� �Լ� (��ü ����)

img_nbit_nuni = zeros(H,W,N);    % �� Bitrate�� Non-uniform Quantization�� �̹����� ������ ����
X = 1 : 255;                                % Quantization Function�� X��
Y_nuni = zeros(length(X),N);       % �� Bitrate�� ���� Quantization Function [Y = Q(X)]
err_nbit_nuni = zeros(1,N);           % �� Bitrate�� ���� Quantization Error (RMSE)

for Nbit = 1:N  % 1~N Bitrate�� Quantizaion 
    [img_nbit_nuni(:,:,Nbit), Y_nuni(:, Nbit), th] = Quantizaion_nuni(img, X, Nbit);  % ��ü ���� Non-uniform Quantization �Լ�
    % �ش� Bitrate�� Non-uniform Quantization�� ������ �̹����� Quatization Function ��� ����
    err_nbit_nuni(1,Nbit) = sqrt(sum(sum((img-img_nbit_nuni(:,:,Nbit)).^2))/length(img(:))); % Quantization Error (RMSE) ����
end

% Bitrate�� ���� Quantization Function ���
figure(52); set(52, 'name', ['Non-uniform Quantization Function 1-',num2str(N),'bit'],'units','normalized','outerposition', [0 0 1 1]);
for Nbit = 1:N 
    subplot(2,4,Nbit); plot(X, Y_nuni(:,Nbit)); xlim([0 255]); ylim([0 255]); title([num2str(Nbit),'-bit Non-uniform Quantizaion Function']); 
end
subplot(2,4,N+1); histogram(img(:),length(X),'Normalization','probability'); % ���� �̹��� ������׷� ���
title('Histogram of Image'); xlabel('Pixel Value'); ylabel('Numer of Value (%)'); xlim([0 255]);

% Bitrate�� ���� Quantization Image ���
figure(53); set(53, 'name', ['Non-uniform Quantization Image 1-',num2str(N),'bit'],'units','normalized','outerposition', [0 0 1 1]);
for Nbit = 1:N 
    subplot(2,4,Nbit); imshow(uint8(img_nbit_nuni(:,:,Nbit))); title([num2str(Nbit),'-bit Non-uniform Quantizaion Image']); 
    xlabel(['Quantization ERR (RMSE) = ', num2str(err_nbit_nuni(Nbit))]);
end
subplot(2,4,N+1); imshow(uint8(img)); title('Original Image'); % ���� �̹��� ���

%%
% Bitrate�� ���� Quantization Image ���
figure(55); set(55, 'name', 'Uniform & Non-uniform Quantization Image 1-3bit','units','normalized','outerposition', [0 0 1 1]);
for Nbit = 1:3 
    subplot(2,4,Nbit); imshow(uint8(img_nbit_uni(:,:,Nbit))); title([num2str(Nbit),'-bit Uniform Quantizaion Image']); 
    xlabel(['Quantization ERR (RMSE) = ', num2str(err_nbit_uni(Nbit))]);
    subplot(2,4,Nbit+4); imshow(uint8(img_nbit_nuni(:,:,Nbit))); title([num2str(Nbit),'-bit Non-uniform Quantizaion Image']); 
    xlabel(['Quantization ERR (RMSE) = ', num2str(err_nbit_nuni(Nbit))]);
end
subplot(2,4,4); imshow(uint8(img)); title('Original Image'); % ���� �̹��� ���
subplot(2,4,8); % 1-3 bit Quantization Error (RMSE) ��ȭ �׷��� ���
plot(1:3, err_nbit_uni(1:3), '-o');  hold on;
plot(1:3, err_nbit_nuni(1:3), '-or'); hold off;
title('Quantization Error (RSME) of Image'); xlabel('Quantized Bitrate'); ylabel('Quantization Error (RMSE)');
legend('Uniform', 'Non-uniform'); xlim([0 4]);

%%
% Bitrate�� ���� Quantization Error (RMSE) �� �׷��� ���
figure(60); set(60, 'name', ['Uniform Quantization Error (RMSE) 1-',num2str(N),'bit']);
plot(1:N, err_nbit_uni, '-o'); hold on;
plot(1:N, err_nbit_nuni, '-or'); hold off;
title('Quantization Error (RSME) of Image'); xlabel('Quantized Bitrate'); ylabel('Quantization Error (RMSE)');
legend('Uniform', 'Non-uniform');

% 1~3 bits�Ӹ��ƴ϶� ������ �Ϲ�ȭ�Ͽ� 7bit���� Ȯ���� �� �ֵ��� �ۼ��Ͽ����ϴ�. 
% ��ü �̹����� Quantization Error�� Root Mean Square Error(RSME)�� ����Ͽ����ϴ�.
% �ȼ� ���� ���������� ������ �̹����� ��쿡 Non-uniform Quantizaion Error�� ��������� �۾����� ���� Ȯ���߽��ϴ�. 