function [paded1, paded2, paded3, paded4]  = pad_template_to_same_size(tmp1,tmp2,tmp3,tmp4)
% function make all parames be in same length
% ti is templates matrix
%    dims: template len X 3 (x,y,z) X 2 (data,time)

trunckG = [{tmp1(:,:,1)} {tmp2(:,:,1)} {tmp3(:,:,1)} {tmp4(:,:,1)}];
trunckT = [{tmp1(:,:,2)} {tmp2(:,:,2)} {tmp3(:,:,2)} {tmp4(:,:,2)}];
[d1, d2, d3, d4] = trunckG{1:end};
[t1, t2, t3, t4] = trunckT{1:end};
len1 = size(d1,1);
len2 = size(d2,1);
len3 = size(d3,1);
len4 = size(d4,1);
n = max([len1,len2,len3,len4]);
%initialize
d1_n = zeros(n,3);
d2_n = zeros(n,3);
d3_n = zeros(n,3);
d4_n = zeros(n,3);

t1_n = zeros(n,3);
t2_n = zeros(n,3);
t3_n = zeros(n,3);
t4_n = zeros(n,3);


for i = 1:3
    d1_n(:,i) = padarray(d1(:,i), n-len1, d1(end,i), 'post');
    d2_n(:,i) = padarray(d2(:,i), n-len2, d2(end,i), 'post');
    d3_n(:,i) = padarray(d3(:,i), n-len3, d3(end,i), 'post');
    d4_n(:,i) = padarray(d4(:,i), n-len4, d4(end,i), 'post');

    t1_n(:,i) = padarray(t1(:,i), n-len1, t1(end,i), 'post');
    t2_n(:,i) = padarray(t2(:,i), n-len2, t2(end,i), 'post');
    t3_n(:,i) = padarray(t3(:,i), n-len3, t3(end,i), 'post');
    t4_n(:,i) = padarray(t4(:,i), n-len4, t4(end,i), 'post');
end
paded1 = cat(3,d1_n,t1_n);
paded2 = cat(3,d2_n,t2_n);
paded3 = cat(3,d3_n,t3_n);
paded4 = cat(3,d4_n,t4_n);


end