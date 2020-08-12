clear all; close all; clc;
%% PARAMS
% get data to insert grid_serch
xcorr_data = load("./to grid search/xcorr_data.mat").val;
times = load("./to grid search/times.mat").val;
real_labels = load("./to grid search/real_labels.mat").val;
n = load("./to grid search/n.mat").val;
template_len = 63;
dt = 1500; %[msec]

%% demands params to all moves
th1_range = 0.7 ; 
th2_range = 0.3;
t2_range  = 200; %[mili-sec]
th3_range = 0.7;
% th1_range = 0.5:0.05:0.9; 
% th2_range = 0.1:0.05:0.5;
% t2_range  = 200:20:400; %[mili-sec]
% th3_range = 0.6:0.05:0.9;
FPR_max   = 5e-4; % [%]
hold_time = 1500; %[mili-sec]
%% RUN GRID SEARCH
[TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = ...
    grid_search(...
    real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time);
thresholds2.th1 = th1_out;
thresholds2.th2 = th2_out;
thresholds2.t2 = t2_out;
thresholds2.th3 = th3_out;
save("./results after grid search/thresholds2.mat",'-struct',"thresholds2");
results2.tpr = TPR;
results2.fpr = FPR;
results2.tnr = TNR;
results2.ppv = PPV;
save("./results after grid search/results2.mat",'-struct',"results2");
%% Load optimal results
n = load("./to grid search/n.mat").val;
template_len = 63;
hold_time = 1500; %[mili-sec]
th1_out  = load("./results after grid search/thresholds2.mat").th1;
th2_out = load("./results after grid search/thresholds2.mat").th2;
t2_out = load("./results after grid search/thresholds2.mat").t2;
th3_out = load("./results after grid search/thresholds2.mat").th3;

%% plot optimal results
[algo_labels,algo_vals] = get_algo_labels(th1_out, th2_out, t2_out,th3_out,hold_time);
plot_results_stem(algo_vals);
%% Confusion matrix 
[united_times,united_algo_labels,united_real_labels] =...
            unite(times,algo_labels,real_labels,template_len);
dt = 1000;
plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt);
