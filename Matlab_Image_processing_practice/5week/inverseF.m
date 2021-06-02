function [invY] = inverseF(Y)
% �Է� �������� 0~255(N = 256)�̰� ��� �������� 0~1�� �Լ��� ���Լ��� ���ϴ� �Լ� 

N = length(Y);

invY = zeros(1,N);
for ll = 1 : N
    invY(uint8((N-1)*Y(ll))+1) = ll;  
    % y=x���� ��Ī���� X�� Y�� ���� ��ȯ
end

invY = EmptyInterp(invY);
% 1:1 ������ �ƴ� ������ ��� Interpolation ����

invY = invY/(N-1); 
% �ٽ� ��� �������� 0~1�� ����� ���� Normalization

end