function [qt_img, Y_qtfunc, th] = Quantizaion_nuni(img, X, N)
% Non-uniform �̹����� ����ȭ Threshold ���� �ڵ����� �����Ͽ� Decoder Mapping�ϴ� �Լ� (��ü ����)
% ----------INPUT ������----------
% img              : �Է� �̹���
% X                 : �̹��� �ȼ� �� ����
% N                 : ����ȭ ��Ʈ ��
% ----------OUTPUT ������----------
% qt_img        : ����ȭ�� �̹��� (Non-Uniform)
% Y_qtfunc     : ����ȭ �Լ� (Non-Uniform)
% th               : ������ Threshold
% ---------------------------------
[H, W] = size(img);                         % �̹����� ũ�� ����

th = [];                                          % threshold �迭 �ʱ�ȭ
qt_img = zeros(H,W);                      % Quantization�� �̹��� ���� ����
Y_qtfunc = zeros(1, length(X));       % N-bit Non-Uniform Quantization Function [Y = Q(X)]

th_maxnum = 2^N-1;                      % threshold �迭�� �ִ� index

QuantizatioinAdd(img, 0, 256, 1);      % �̹��� ����ȭ ����

    function [] = QuantizatioinAdd(img_, low, high, pos)
        % threshold �迭�� ���� ���� �̹����� Decoder Mapping�ϴ� ����Լ� (Ʈ�� ������ ����)
        
        % ���� ����ȭ ��Ʈ�� �ܰ��� threshold ����
        th(pos) = mean(img_(low <= img_ & img_ < high));
        
        % ���� ����ȭ ��Ʈ�� �ܰ��� threshold�� ���� �̹��� Decoder Mapping
         qt_img(low <= img_ & img_ < th(pos)) = (low+th(pos))/2;
         qt_img(th(pos) <= img_ & img_ < high) = (th(pos)+high)/2;
         
         % ���� ����ȭ ��Ʈ�� �ܰ��� threshold�� ���� X�� ���� Quantization Function ����
         Y_qtfunc(low <= X & X < th(pos)) = (low+th(pos))/2;
         Y_qtfunc(th(pos) <= X & X < high) = (th(pos)+high)/2;
         
         % ���� ����ȭ ��Ʈ�� �ܰ�� �̵�
        if 2*pos < th_maxnum
            QuantizatioinAdd(img_, low,  th(pos), 2*pos);
            QuantizatioinAdd(img_, th(pos), high, 2*pos+1);
        end
    end    
end