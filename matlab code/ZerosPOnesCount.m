%% NEED TO FINISH
function [startOut,lenOut,numOut] = ZerosPOnesCount(v,p)
% casing func to ZeroOnesCount - up to p zeroes is stilll 1-string
% p - num of zeros that still counts as 1-string
[start,len,n] = ZeroOnesCount(v);
numOut = n;
startOut = zeros(size(start));            % where each 1-string starts
lenOut = zeros(size(start));           % length of each 1-string
startOut(1) = start(1);
startOut(n) = start(n);
lenOut(n) = len(n);
i=1;
while i<n
    zerosNum = start(i+1)-(start(i)+len(i));
    if zerosNum <= p 
        lenOut(i) = zerosNum+len(i+1)+len(i);
        if i>1
            startOut(i) = start(i+1);
        end
        numOut = numOut-1;
        i=i+1;
    else
        startOut(i) = start(i);
        lenOut(i)=len(i);
    end
    i=i+1;
end

end
