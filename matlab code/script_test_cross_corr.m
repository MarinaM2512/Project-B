%function label_mat = xcorr_segments_and_classify(data,times
template_mat = loadTemplateMat;
data_mat = loadMeasurmentMat("17_04","sit_N_tap1",1,"INIT"); %load one data mes
[S,T]=data2timeSegmentsOverlapping(data(:,4),data(:,20),63,60);
%% 
t = data(:,20);
xcorr = xcorr_all_intresting_seg(Sd,factor);
xcorr_mat = cell2mat(xcorr);
xcorr_swl = xcorr_mat(:,:,1);
xcorr_swr = xcorr_mat(:,:,2);
xcorr_tap = xcorr_mat(:,:,3);
xcorr_anc = xcorr_mat(:,:,4);
%%
figure();
