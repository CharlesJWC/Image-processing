        elseif key == 2
        
            a = 3;                                                           % [-a, a] ���� ����
            x = zeros(2*a);                                           % �Լ� ���� for������ �Է��ϱ� ���� �迭 ����

            %   x(1)  ...  x(a-1)    x(a)    x(a+1)  ...  x(2a)
            %                          �����ȼ�
            
            x(a) = Y(start_pos);                                     % ���� ��ǥ �ȼ���

            % ���� ��ǥ�� ����
            for ll = a-1 : -1 : 1 
                if start_pos-(a-ll) <= 0                               % ���ǿ� ������ ��� ���
                    x(ll) = x(ll+1);                                      % ���� ��ǥ�� ���� �����ϰ� ó�� 
                else                                                          % ���ǿ� ���� ���� ���
                    x(ll) = Y(start_pos-(a-ll));                    % �ش� ��ǥ�� ����
                end
            end

            % ���� ��ǥ�� ����
            for ll = a+1 : 2*a
                if pos-(a-ll) > len                                       % ���ǿ� ������ ��� ���
                    x(ll) = x(ll-1);                                    % ���� ��ǥ�� ���� �����ϰ� ó�� 
                else                                                          % ���ǿ� ���� ���� ���
                    x(ll) = Y((end_pos-1)-(a-ll));                             % �ش� ��ǥ�� ����
                end
            end
            disp(interval)
            % start_pos�� end_pos ������ ������ �Լ� ���� Lanczos Interpolation���� ����
            for k = 1:interval-1
                sum = 0;
                for ll = 1:2*a
                    sum = sum + beta_func_lcz(k+(a-ll)*interval, interval, a)*x(ll);    % �� ������ �Լ� ���� ���� �� 
                end
                Y(start_pos+k) = sum;
            end
        
        else
           disp('Method Error');
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
