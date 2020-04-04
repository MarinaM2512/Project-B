function [dt] = dt_func(X,Y)

%
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