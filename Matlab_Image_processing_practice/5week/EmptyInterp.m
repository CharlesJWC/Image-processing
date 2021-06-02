function [Y_stuffed] = EmptyInterp(Y)
% �Լ� ���� 0���� empty�� ��� �̸� ���� ���ִ� �Լ�

len = length(Y);                                % ���ǿ� index �ִ� ��

start_flag = 0;                                 % ���� �������� üũ ����
interval = 1;                                     % start�� end ���� ����
end_flag = 0;                                   % ���� ������ üũ ����

for pos = 1:len
    
    % start_pos�� end_pos ���� ������ empty���� ī��Ʈ
    if start_flag == 1 && Y(pos) == 0
        interval = interval + 1; 
    end
    
    % ��ŸƮ ���� ���� �� empty�� �ƴ� ���� �� ������ Interpolation ���� ���� Set
    if  end_flag == 0 && Y(pos) ~= 0
        end_pos = pos;
        end_flag = 1;
    end
    
    % empty�� �ƴ� ������ ��� ��ŸƮ �������� ����
    if start_flag == 0 && Y(pos) ~= 0
        start_pos = pos;
        start_flag = 1;
    end
    
    % �������� empty�� �ƴ� ���
    if start_flag == 1 && end_flag == 1 && interval ==1
        start_pos = pos;
        end_flag = 0;
    end
    
    % ���ǿ� ���� �����Ͽ� Interpolation�� ���� ���� ��� 
    if pos + 1 > len && interval > 1
        for k = 1:interval-1
            Y(start_pos+k) = Y(start_pos); % ���� �ֱ� empty �ƴ� ������ ä��
        end
    end
    
    % Lancoz Interpolation ����
    if start_flag ==1 && end_flag ==1 
            
        %       x1       x2        x3       x4
        %                start      end

        % x2 
        x2 = Y(start_pos);                 % start_pos ���� �Լ� ��
        x1 = x2;                                % start_pos ���� �Լ� ���� �����ϰ� ó�� 
        x3 = Y(end_pos);                   % end_pos ���� �Լ� �� ����
        x4 = x3;                                % end_pos ���� �Լ� �� �����ϰ� ó��

        % start_pos�� end_pos ������ ������ �Լ� ���� Cubic Convolution Interpolation ���� ����
        for k = 1:interval-1
            Y(start_pos+k) = beta_func_ccv(k+interval, interval)*x1...
                                    +beta_func_ccv(k, interval)*x2...
                                    +beta_func_ccv(k-interval, interval)*x3...
                                    +beta_func_ccv(k-2*interval, interval)*x4;
        end
    
        start_pos = end_pos;
        start_flag = 1;
        interval = 1;
        end_flag = 0;
    end
    
Y_stuffed = Y;
end

% Cubic Convoltion Interpolation beta �Լ�
function [b] = beta_func_ccv(k,n)
    alpha = -0.5;
    k = k/n;
    if (0 <= abs(k)) && (abs(k) < 1)
        b = (alpha+2)*abs(k)^3 - (alpha+3)*abs(k)^2 + 1;
    elseif (1 <= abs(k)) && (abs(k) < 2)
        b = alpha*abs(k)^3 - 5*alpha*abs(k)^2 + 8*alpha*abs(k) - 4*alpha;
    else
        b = 0;
    end
end

end