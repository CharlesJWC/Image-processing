function [th] =  ThresholdMaker(img, N)
% Non-uniform �̹����� ����ȭ Threshold ���� �ڵ����� �����ϴ� �Լ� (��ü ����)
% img : �Է� �̹���
% N    : ����ȭ ��Ʈ ��
    
th = [];                       % threshold �迭 �ʱ�ȭ
th_maxnum = 2^N-1;  % threshold �迭�� �ִ� index

thresholdAdd(img, 0, 256, 1);   

    function [] = thresholdAdd(img_, low, high, pos)
        % threshold�� ���� �̹����� ����ȭ�ϴ� �迭�� ���� �߰��ϴ� ����Լ� (Ʈ�� ������ ����)
        
        % ���� ����ȭ ��Ʈ�� �ܰ��� threshold ����
        th(pos) = mean(img_(low <= img_ & img_ < high));
        
         % ���� ����ȭ ��Ʈ�� �ܰ��� threshold ����
        if 2*pos < th_maxnum
            thresholdAdd(img_, low,  th(pos), 2*pos);      
            thresholdAdd(img_, th(pos), high, 2*pos+1);
        end
        
    end
end
