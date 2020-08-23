%% DEFINE 
% date = ""; 
% path = ""; 
template_len = 63; %[samples] 
hold_time = 1500; %[mili-sec] 
 
%% LOADS 
% thresholds 
th1_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th1; 
th2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th2; 
th3_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th3; 
t2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").t2; 
% labels 
real_labels = load("./to grid search/real_labels.mat").val; 
[algo_labels,algo_vals] = get_algo_labels_new(xcorr_data,times,th1_out, th2_out, t2_out,th3_out,hold_time); 