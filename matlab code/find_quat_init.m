function q_init=find_quat_init(window,t,Fs)
% window is the data multiplied with the window in m by 4 matrix
% t      the amount of time to calaulate avg
% Fs     sampels per sec
n = fs*t;
tmp = window(1:n);
q_init = sum(tmp)/n;
end
