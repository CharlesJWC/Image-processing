function [img_sampled] =  samp(img, n, method)
%----------------------------------------------------------------------
% samp : �̹����� ���ϴ� LPF�� Sampling �� �����ϴ� �Լ�
%
% img : �Է¹��� �̹���
% n : ���ø� ���� (�̹����� 1/n ��)
% method : ���ø��� ������ ��� (LPF ����)
%----------------------------------------------------------------------

% �Է¹��� �ɼǿ� ���� �̹��� ���ø� ��� ����
if strcmp(method, 'Simple')
    key = 0;
elseif strcmp(method, 'Uniform')
    key = 1;
elseif strcmp(method, 'Gaussian')
    key = 2;
else  % �Է¹��� �ɼ��� �������� ���� ���
    img_sampled = 'NULL';
    disp("�Ʒ��� Sampling ����� �������ּ���.")
    disp("method : 'Simple'(no LPF), 'Uniform', 'Gaussian' ")
    return
end

[H, W, D] = size(img);
img = double(img);

switch key
    
    case 0 % LPF ���͸� ������� ���ø�
        img_sampled = img(1:n:end, 1:n:end,:); % n �������� ���ø�
        
    case 1  % Uniform Weight Moving average LPF ���͸� �����Ͽ� ���ø�
        lpf = ones(3,3,3)/9;        % Uniform LPF ����
        img_lpf = zeros(H,W,D);  % LPF ������ �̹��� ���� �ʱ�ȭ
        
        for i = 1:H-2
            for j = 1:W-2
                img_lpf(i+1,j+1,:) = sum(sum( img(i:i+2,j:j+2,:).*lpf, 1),2);
                % .���� ���Ͽ� 3x3���͸� �����Ͽ� �迭�� ���� ���� �ȼ� ������ ����
                % �׵θ� �ȼ��� ��� ���͸� ������ �ܺ��� ���� ���� ������ �׵θ� ���� ���� ������ ���� ����
            end
        end

        img_sampled = img_lpf(1:n:end, 1:n:end,:); % n �������� ���ø�
        
    case 2 % Gaussian LPF ���͸� �����Ͽ� ���ø�
        lpf = [1,2,1; ...
                 2,4,2; ...
                 1,2,1]/16;             % Gaussian LPF ����
        img_lpf = zeros(H,W,D);  % LPF ������ �̹��� ���� �ʱ�ȭ
  
        
        for i = 1:H-2
            for j = 1:W-2
                img_lpf(i+1,j+1,:) = sum(sum( img(i:i+2,j:j+2,:).*lpf, 1),2);
                % .���� ���Ͽ� 3x3���͸� �����Ͽ� �迭�� ���� ���� �ȼ� ������ ����
                % �׵θ� �ȼ��� ��� ���͸� ������ �ܺ��� ���� ���� ������ �׵θ� ���� ���� ������ ���� ����
            end
        end
        
        img_sampled = img_lpf(1:n:end, 1:n:end,:); % n �������� ���ø� 
        
    otherwise
        warning('�� ���� ������?!')
        img_sampled = img;
        return
end

end