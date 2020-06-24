%function label_mat = xcorr_segments_and_classify(data,times
template_mat = loadTemplateMat;
data_mat = loadMeasurmentMat("17_04","sit_N_swipe_tap1",1,"INIT"); %load one data mes
[S,T]=data2timeSegments(data,times,delay);
