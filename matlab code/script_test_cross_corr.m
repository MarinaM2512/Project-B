%function label_mat = xcorr_segments_and_classify(data,times
template_mat = loadTemplateMat;
data_mat = loadMeasurmentMat("17_04","sit_N_tap1",1,"INIT"); %load one data mes
seg=data2timeSegmentsOverlapping(data_mat(:,4:6),data_mat(:,20),63,60);