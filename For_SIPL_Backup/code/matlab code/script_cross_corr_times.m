move_name = "sit_N_tap";
data = loadMeasurmentMat("17_04",move_name,1,"INIT"); %load one data mes
S=data2timeSegmentsOverlapping(data(:,4:6),data(:,20),63,60);
thresholds = [500,12,10];
plot_raw_data_with_move_extraction(move_name,"17_04","gyro",thresholds);
chosen_seg = S{250,1};
data_seg = chosen_seg(:,1:3);
times_seg = chosen_seg(:,4);
Ts = times_seg(2)-times_seg(1);
template_mat = loadTemplateMat;
temp = template_mat{3};
[corr,lags] = xcorr( data_seg(:,1),temp(:,1));
[~,ind_peak] = max(corr);
lag = lags(ind_peak);
t_delay = (lag-length(temp))*Ts;
figure;
plot(lags,corr);
title("cross corr vs lags");

figure;
plot(times_seg,data_seg(:,1));
title("chosen seg and template");




