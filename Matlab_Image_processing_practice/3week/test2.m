function [output] = interp(img, n, method) 
%----------------------------------------------------------------------
% interp : ��ҵ� �̹����� �������� Ȱ���Ͽ� Reconstruction �� �����ϴ� �Լ�
%
% img : �Է¹��� �̹���
% n : ���� ũ�� ���
% method : ������ ������ ��� 
%----------------------------------------------------------------------
    
% �Է¹��� �ɼǿ� ���� �̹��� ���� ��� ����
if strcmp(method, '0th')
    key = 0;
elseif strcmp(method, '1st')
    key = 1;
elseif strcmp(method, '2nd')
    key = 2;
elseif strcmp(method, '3rd')
    key = 3;
elseif strcmp(method, 'CubicConv')
    key = 4;
elseif strcmp(method, 'Lanczos')
    key = 5;
else % �Է¹��� ���� �ɼ� �ùٸ��� ���� ���
    output = 'NULL';
    disp("�Ʒ��� Reconstruction ����� �������ּ���.")
    disp("method : '0th', '1st', '2nd', '3rd', 'CubicConv', 'Lanczos' ")
    return
end

img = double(img);                          % �̹��� �ȼ� ���� �Ǽ��� ��ȯ (���� ���� ������ ����)
output = recon(img, n);                    % ����(��)�� ���Ͽ� ���� ����
output = permute(output,[2 1 3]);   % �̹����� �࿭�� ���� ��Ī���� ��ȯ
output = recon(output, n);               % ����(��)�� ���Ͽ� ���� ����
output = permute(output,[2 1 3]);   % �̹����� �࿭�� �ٽ� ���� ��Ī���� ���� �̹����� ��ȯ

function [output_] = recon(img_, n)     % �̹����� ���� ���Ͽ� N��� ������ ����
    [H, W, D] = size(uint8(img_));          % �̹����� ũ�⸦ �����Ͽ� ����
    output_ = zeros(H, W*n, D);             % ������ �̹��� ������ 0���� �ʱ�ȭ
    output_(:, 1:n:W*n,:) = img_;            % ���� �̹����� n�������� �Է�
    output_(:, 1, :) = img_(:,1+n,:);         % ������ �������� �����ϱ� ���� �ʱⰪ ��ó �ȼ��� �����ϰ� ����

    for i = 1:H             % ��� �࿡ ���Ͽ� ����
        for j = 1:n:W*n  % �ش� �࿡ ���Ͽ� n �������� ���� �̵�

            switch key % method�� ���� ���� �˰����� �����Ͽ� ����

                case 0  % 0th Interpolation method
                    
                    %       x1       x2
                    %   �����ȼ� 
                    
                    % x1
                    x1 = output_(i,j,:);              % ���� ��ġ�� �ȼ� ��
                    
                    % x2 ����
                    if j+n >W                            % �̹��� ������ �ʰ��� ��� 
                            x2 = x1;                     % �ٷ� ���� �ȼ� ���� ����
                    else                                   % �̹����� ���� ���� ���
                            x2 = output_(i,j+n,:);  % ���� ��ġ�� �ȼ� ��
                    end

                    for k = 1 : n-1                    % x1 ~ x2 ������ �ȼ��� ���Ͽ� ������ ����
                         output_(i,j+k,:) = beta_func0(k, n)*x1...
                                                +beta_func0(k-n, n)*x2;
                    end

                case 1 % 1st Interpolation method
                    
                    %       x1       x2
                    %   �����ȼ� 
                    
                    % x1
                    x1 = output_(i,j,:);              % ���� ��ġ�� �ȼ� ��
                    
                    % x2 ����
                    if j+n >W                            % �̹��� ������ �ʰ��� ��� 
                            x2 = x1;                     % �ٷ� ���� �ȼ� ���� ����
                    else                                   % �̹����� ���� ���� ���
                            x2 = output_(i,j+n,:);  % ���� ��ġ�� �ȼ� ��
                    end

                    for k = 1 : n-1                    % x1 ~ x2 ������ �ȼ��� ���Ͽ� ������ ����
                         output_(i,j+k,:) = beta_func1(k, n)*x1...
                                                 +beta_func1(k-n, n)*x2;
                    end

                case 2 % 2nd Interpolation method
                    
                    %       x1       x2        x3       x4
                    %              �����ȼ�
                    
                    % x2 
                    x2 = output_(i,j,:);             % ���� ��ǥ �ȼ���
                    
                    % x1 ����
                    if j-n < 0                          % �̹����� ������ ��� ���
                        x1 = x2;        % ���� ��ǥ�� �ȼ� ���� �����ϰ� ó�� 
                    else                                 % �̹����� ���� ���� ���
                        x1 = output_(i,j-n,:);    % ���� ��ǥ�� �ȼ��� ����
                    end
                    
                    % x3 ����
                    if j+n > W                         % �̹����� ������ ��� ���
                         x3 = x2;                      % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                 % �̹����� ���� ���� ���
                         x3 = output_(i,j+n,:);   % ���� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x4 ����
                    if j+2*n > W                      % �̹����� ������ ��� ���
                         x4 = x3;                       % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                  % �̹����� ���� ���� ���
                         x4 = output_(i,j+2*n,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x1�� x2 ������ �ȼ��� ���Ͽ� 2nd order Interpolation ���� ����
                    for k = 1:n-1
                        output_(i,j+k,:) = beta_func2(k+n, n)*x1...
                                                +beta_func2(k, n)*x2...
                                                +beta_func2(k-n, n)*x3...
                                                +beta_func2(k-2*n, n)*x4;
                    end

                case 3 % 3rd Interpolation method
                    
                    %       x1       x2        x3       x4
                    %              �����ȼ�
                    
                    % x2 
                    x2 = output_(i,j,:);             % ���� ��ǥ �ȼ���
                    
                    % x1 ����
                    if j-n < 0                          % �̹����� ������ ��� ���
                        x1 = x2;        % ���� ��ǥ�� �ȼ� ���� �����ϰ� ó�� 
                    else                                 % �̹����� ���� ���� ���
                        x1 = output_(i,j-n,:);    % ���� ��ǥ�� �ȼ��� ����
                    end
                    
                    % x3 ����
                    if j+n > W                         % �̹����� ������ ��� ���
                         x3 = x2;                      % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                 % �̹����� ���� ���� ���
                         x3 = output_(i,j+n,:);   % ���� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x4 ����
                    if j+2*n > W                      % �̹����� ������ ��� ���
                         x4 = x3;                       % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                  % �̹����� ���� ���� ���
                         x4 = output_(i,j+2*n,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x1�� x2 ������ �ȼ��� ���Ͽ� 2nd order Interpolation ���� ����
                    for k = 1:n-1
                        output_(i,j+k,:) = beta_func3(k+n, n)*x1...
                                                +beta_func3(k, n)*x2...
                                                +beta_func3(k-n, n)*x3...
                                                +beta_func3(k-2*n, n)*x4;
                    end

                case 4 % Cubic Convolution Interpolation method
                    
                    %       x1       x2        x3       x4
                    %              �����ȼ�
                    
                    % x2 
                    x2 = output_(i,j,:);             % ���� ��ǥ �ȼ���
                    
                    % x1 ����
                    if j-n < 0                          % �̹����� ������ ��� ���
                        x1 = x2;        % ���� ��ǥ�� �ȼ� ���� �����ϰ� ó�� 
                    else                                 % �̹����� ���� ���� ���
                        x1 = output_(i,j-n,:);    % ���� ��ǥ�� �ȼ��� ����
                    end
                    
                    % x3 ����
                    if j+n > W                         % �̹����� ������ ��� ���
                         x3 = x2;                      % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                 % �̹����� ���� ���� ���
                         x3 = output_(i,j+n,:);   % ���� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x4 ����
                    if j+2*n > W                      % �̹����� ������ ��� ���
                         x4 = x3;                       % ���� ��ǥ �ȼ� ���� �����ϰ� ó��
                    else                                  % �̹����� ���� ���� ���
                         x4 = output_(i,j+2*n,:); % �ٴ��� ��ǥ�� �ִ� �ȼ� �� ����
                    end

                    % x1�� x2 ������ �ȼ��� ���Ͽ� 2nd order Interpolation ���� ����
                    for k = 1:n-1
                        output_(i,j+k,:) = beta_func_ccv(k+n, n)*x1...
                                                +beta_func_ccv(k, n)*x2...
                                                +beta_func_ccv(k-n, n)*x3...
                                                +beta_func_ccv(k-2*n, n)*x4;
                    end

                case 5 % Lanczos Interpolation method
                    a = 3; 
                    x = zeros(2*a,3);
                    
                    x(a,:) = output_(i,j,:);
                    
                    for ll = a-1 : 1 
                        if j-(a-ll)*n < 0                          % �̹����� ������ ��� ���
                            x(ll,:) = x(ll+1);        % ���� ��ǥ�� �ȼ� ���� �����ϰ� ó�� 
                        else                                 % �̹����� ���� ���� ���
                            x(ll,:) = output_(i,j-(a-ll)*n,:);    % ���� ��ǥ�� �ȼ��� ����
                        end
                    end
                    
                    for ll = a+1 : 2*a
                        if j+ll*n > W                          % �̹����� ������ ��� ���
                            x(ll,:) = x(ll-1,:);        % ���� ��ǥ�� �ȼ� ���� �����ϰ� ó�� 
                        else                                 % �̹����� ���� ���� ���
                            x(ll,:) = output_(i,j-(a-ll)*n,:);    % ���� ��ǥ�� �ȼ��� ����
                        end
                    end

                    for k = 1:n-1
                        sum = 0;
                        for ll = 1:2*a
                            sum = sum + beta_func_lcz(k-(a-ll)*n, n, a)*x(ll,:);
                        end
                        output_(i,j+k,:) = sum;
                    end

                otherwise
                    warning('�� ���� ������?!')
                    output_ = img_;
                    return
            end
        end
    end
end

% 0th-order Interpolation beta �Լ�
function [b] = beta_func0(k,n)
    k = k/n;
    if (-1/2 < k) && (k <= 1/2)
        b = 1;
    else
        b = 0;
    end
end

% 1st-order Interpolation beta �Լ�
function [b] = beta_func1(k,n)
    k = k/n;
    if(-1 < k) && (k < 0)
        b = k+1;
    elseif (0 <= k) &&(k <= 1)
        b = 1-k;
    else
        b = 0;
    end
end

% 2nd-order Interpolation beta �Լ�
function [b] = beta_func2(k,n)
    k = k/n;
    if (-3/2 < k) && (k <= -1/2)
        b = 0.5*(k + 1.5)^2;
    elseif (-1/2 < k) && (k <= 1/2)
        b = 3/4 - k^2;
    elseif (1/2 < k) && (k <= 3/2)
        b = 0.5*(k - 1.5)^2;
    else
        b = 0;
    end
end

% 3rd-order Interpolation beta �Լ�
function [b] = beta_func3(k,n)
    k = k/n;
    if (0 <= abs(k)) && (abs(k) < 1)
        b = 2/3+0.5*abs(k)^3 - k^2;
    elseif (1 <= abs(k)) && (abs(k) < 2)
        b = 1/6*(2 - abs(k))^3;
    else
        b = 0;
    end
end

% Cubic Convoltion Interpolation beta �Լ�
function [b] = beta_func_ccv(k,n)
    a = -0.5;
    k = k/n;
    if (0 <= abs(k)) && (abs(k) < 1)
        b = (a+2)*abs(k)^3 - (a+3)*abs(k)^2 + 1;
    elseif (1 <= abs(k)) && (abs(k) < 2)
        b = a*abs(k)^3 - 5*a*abs(k)^2 + 8*a*abs(k) - 4*a;
    else
        b = 0;
    end
end

% Lanczos Interpolation beta �Լ�
function [b] = beta_func_lcz(k,n, a)
    k = k/n;
    if abs(k) < a
        b = sinc(k)*sinc(k/a);
    else
        b = 0;
    end
end

end