function [Y_extend] = InterpLancoz(Y, N)

a = 3;                                                   % [-a, a] ���� ����
x = zeros(2*a,3);                                   % �Լ� ���� for������ �Է��ϱ� ���� �迭 ����
len = length(Y);                                     % ���ǿ� index �ִ� ��
Y_extend = zeros(1,len*N);                    % Ȯ��� Y�Լ�

for p = 1:N:len*N
    x(a,:) = Y(p);                                     % ���� ��ǥ �ȼ���

    for ll = a-1 : -1 : 1 
        if p-(a-ll)*N < 0                             % ���ǿ� ������ ��� ���
            x(ll,:) = x(ll+1);                          % ���� ��ǥ�� ���� �����ϰ� ó�� 
        else                                              % ���ǿ� ���� ���� ���
            x(ll,:) = output_(p-(a-ll)*N);       % �ش� ��ǥ�� ����
        end
    end

    for ll = a+1 : 2*a
        if p-(a-ll)*N > W*N                         % ���ǿ� ������ ��� ���
            x(ll,:) = x(ll-1,:);                         % ���� ��ǥ�� ���� �����ϰ� ó�� 
        else                                               % ���ǿ� ���� ���� ���
            x(ll,:) = output_(p-(a-ll)*N);        % �ش� ��ǥ�� ����
        end
    end

    % x1�� x2 ������ �ȼ��� ���Ͽ� Lanczos Interpolation ���� ����
    for k = 1:N-1
        sum = 0;
        for ll = 1:2*a
            sum = sum + beta_func_lcz(k+(a-ll)*N, N, a)*x(ll,:);    % �� �ȼ����� ���� �� 
        end
        Y_extend(p+k) = sum;
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