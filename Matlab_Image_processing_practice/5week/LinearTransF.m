function [Y] = LinearTransF(X)
% cdf�� �ٻ��Ų ���� �Լ��� ����� �Լ�

% �� ���� ��ǥ
x1 = 91;
y1= 0;
x2 = 137; % 127�� �� �ٻ�
y2= 255;

% ������ ����� y����
a = (y2-y1)/(x2-x1);
b = -a*x1+y1;

Y = max(y1, min(y2, a*X+b));

end