function swL = isswipeL(sx,tx,sy,ty,sz,tz)
% function isswipeL get one isolated movement or one segment and checks
% if this movements is swipe L by looking at the first main peak of the
% gyro signals. if all signals have positive first peak returns 1.
% output:
% 1 - the movement is swipe L
% 0 - is not
% input:
% segments or isolated signals of all gyro cordinates.
% times and data vectors
fgx = firstPeakIsPositive(sx,tx);
fgy = firstPeakIsPositive(sy,ty);
fgz = firstPeakIsPositive(sz,tz);
if fgx && fgy && fgz
    swL = 1;
else
    swL = 0;
end
end

function fg = firstPeakIsPositive(g,t)
%     -       -
%   -   -   -
% -       -
% if the positive is first then we return 1
[~,locs1] = findpeaks(g,'SortStr','descend','NPeaks',1);
t1 = t(locs1);

[~,locs2] = findpeaks((-g),'SortStr','descend','NPeaks',1);
t2 = t(locs2);

if t1<=t2
    fg = 1;
else
    fg = 0;
end
end