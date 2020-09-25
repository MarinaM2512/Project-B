function [padedX,padedT]  = pad_data_to_same_size(x,y,z,tx,ty,tz,thresh,fraction_last)
% function make all parames be in same length
% thresh is the thereshold on the diff so that the last insignificant part
%        of the template would be reduced
%fraction_last - how much of the  the signal to cosider significant
trunckG = [{x} {y} {z}];
trunckT = [{tx} {ty} {tz}];
for i =1:3
    curr = trunckG{i};
    tmp = curr(floor(length(curr)*fraction_last):end);
    curr = curr(1:(length(curr)-length(tmp)));
    ind = find(diff(tmp)<thresh);
    if(~isempty(ind))
        tmp = tmp(1:ind(1)+1);
        curr(length(curr)+1:length(curr)+length(tmp)) = tmp;
        trunckG{i} = curr;
        t = trunckT{i};
        t=t(1:length(curr));
        trunckT{i} = t;
    end
end
[x1 ,y1, z1] = trunckG{1:3};
[tx1,ty1,tz1] = trunckT{1:3};
len_x = length( x1);
len_y = length( y1);
len_z = length( z1);
max_len= max([len_x,len_y,len_z]);
x2 = padarray(x1,max_len-len_x,x1(end),'post');
y2 = padarray(y1,max_len-len_y,y1(end),'post');
z2 = padarray(z1,max_len-len_z,z1(end),'post');
tx2 = padarray(tx1, max_len-len_x,tx1(end),'post');
ty2 = padarray(ty1,max_len-len_y,ty1(end),'post');
tz2=  padarray(tz1,max_len-len_z,tz1(end),'post');

padedX = [x2 y2 z2];
padedT = [tx2 ty2 tz2];

end