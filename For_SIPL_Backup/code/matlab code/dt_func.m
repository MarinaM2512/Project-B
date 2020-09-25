function [dt] = dt_func(X,Y)
% find diffrence between two time samples in milisec
% X,Y- time stamps
% dt - time diffrence in milisec
s2ms = 1000;
m2s = 60;
h2m = 60;
d2h = 24;
m2d = 30;
y2m = 12;

convert2msec = flip(cumprod([s2ms,m2s,h2m,d2h,m2d,y2m]));
%
% [time1]=seperate_timeString(X);
% [time2]=seperate_timeString(Y);

dt = convert2msec * (Y - X);
end