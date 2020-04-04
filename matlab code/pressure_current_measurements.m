%pressure -motor current measurement:
close all; 
clear all; clc;

IsTimestamp = 0;
%conversion:
conv2current = 0.5;%0.783;%~
conv2weight = 1;%0.25 * (5/1023);%~
[num,txt,raw] = xlsread('pressure_curent_run7_thumb_new.csv');
if (IsTimestamp)
    dt_vec = cellfun(@(X,Y) dt_func(X,Y),txt(2:end-1,1),txt(3:end,1));
    Ncycle = num(:,1);
    current = num(:,2);
    pressure = num(:,3);
else
    t_vec = num(:,1);
    Ncycle = num(:,2);
    current = num(:,3);
    pressure = num(:,4);    
end

end_cyc = [0;find(diff(Ncycle))];
m=1;
for k = 1 : length(end_cyc)-1
    indx = (end_cyc(k)+1):end_cyc(k+1);
    if (IsTimestamp)
        t_temp = cumsum(dt_vec(indx));
    else
        t_temp = t_vec(indx);
    end
    
    if mod(k,2)
        % collect only closing:
        t_close(m) = {t_temp};
        current_close(m) = {current(indx)};
        pressure_close(m) = {pressure(indx)};
        m = m+1;
    else  
        % collect only Opening:
        t_open(m) = {t_temp};
        current_open(m) = {current(indx)};
        pressure_open(m) = {pressure(indx)};
    end
end

% ploting closing finger:
figure()
subplot(211)
hold on
%cellfun(@(T,C) plot(T,conv2current * C),t_close,current_close);
cellfun(@(T,C) scatter(T,conv2current * C,'filled','b','MarkerFaceAlpha' ,0.1),t_close,current_close)
sgtitle('Closing Finger')
xlabel('t [msec]'); ylabel('motor current [mA]');
axis tight
xlim([0,900]);
subplot(212)
hold on
%cellfun(@(T,C) plot(T,conv2weight * C),t_close,pressure_close);
cellfun(@(T,C) scatter(T,conv2weight * C,'filled','b','MarkerFaceAlpha' ,0.1),t_close,pressure_close)
xlabel('t [msec]'); ylabel('pressure [g]');
axis tight
xlim([0,900]);
% ploting opening finger:
figure()
subplot(211)
hold on
%cellfun(@(T,C) plot(T,conv2current * C),t_open,current_open);
cellfun(@(T,C) scatter(T,conv2current * C,'filled','b','MarkerFaceAlpha' ,0.1),t_open,current_open)
sgtitle('Opening Finger')
xlabel('t [msec]'); ylabel('motor current [mA]');
axis tight
xlim([0,900]);
subplot(212)
hold on
%cellfun(@(T,C) plot(T,conv2weight * C),t_open,pressure_open);
cellfun(@(T,C) scatter(T,conv2weight * C,'filled','b','MarkerFaceAlpha' ,0.1),t_open,pressure_open)
xlabel('t [msec]'); ylabel('pressure [g]');
axis tight
xlim([0,900]);
%

%delete strating current:
t_start = cellfun(@(X) find(X>600,1), t_close);
t_mid1 = cellfun(@(X) find(X>770,1), t_close);
%t_mid2 = cellfun(@(X) find(X>840,1), t_close);
for k = 1:length(t_start)
%     current_new(k) = {current_cell{k}(t_start(k):end)};
%     pressure_new(k) = {pressure_cell{k}(t_start(k):end)};
    current_new(k) = {current_close{k}(t_start(k):t_mid1(k))};%{current_close{k}([t_start(k):t_mid1(k),t_mid2(k):end])};
    pressure_new(k) = {pressure_close{k}(t_start(k):t_mid1(k))};%{pressure_close{k}([t_start(k):t_mid1(k),t_mid2(k):end])};
end

figure(3);
hold on
cellfun(@(X,Y) scatter(conv2current * X,conv2weight * Y,'filled','k','MarkerFaceAlpha' ,0.1),current_new,pressure_new)
xlabel('motor current [mA]');ylabel('pressure [g]');
title('Pressure vs. Current drawn by the motor when closing finger')
% calc percentile
dt = 10 ;%find percentile for each 10 milisecobds
t_stop = 900; %milisocnd each movement
[t_per_close,perC_close,perP_close] = extracting_percentile(dt,t_stop,t_close,current_close,pressure_close);
[t_per_open,perC_open,perP_open] = extracting_percentile(dt,t_stop,t_open,current_open,pressure_open);
dc = 10 ;%find percentile for each 5 miliAmper
c_stop = 800;
[c_per_close,~,perCvsP] = extracting_percentile(dc,c_stop,current_new,current_new,pressure_new);
% plot
figure(5)
subplot(211)
hold on
h(1)=plot(t_per_close,conv2current * perC_close(:,2),'r','linewidth',2);
h(2:3)=plot(t_per_close,conv2current * perC_close(:,[1,3]),'--r');
legend(h(1:2),'$median$','$5\%-95\%$')
subplot(212)
hold on
plot(t_per_close,conv2weight * perP_close(:,2),'r','linewidth',2)
plot(t_per_close,conv2weight * perP_close(:,[1,3]),'--r')
% plot
figure(2)
subplot(211)
hold on
plot(t_per_open,conv2current * perC_open(:,2),'r','linewidth',2)
plot(t_per_open,conv2current * perC_open(:,[1,3]),'--r')
subplot(212)
hold on
plot(t_per_open,conv2weight * perP_open(:,2),'r','linewidth',2)
plot(t_per_open,conv2weight * perP_open(:,[1,3]),'--r')
% plot
figure(3)
hold on
plot(conv2current * c_per_close,conv2weight * perCvsP(:,2),'r','linewidth',2)
plot(conv2current * c_per_close,conv2weight * perCvsP(:,[1,3]),'--r')

