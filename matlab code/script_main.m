clear all; close all; clc;
%% PARAMS
% get data to insert grid_serch
xcorr_data = load("./to grid search/xcorr_data.mat").val;
times = load("./to grid search/times.mat").val;
real_labels = load("./to grid search/real_labels.mat").val;
n = load("./to grid search/n.mat").val;
template_len = 63;
%% demands params to all moves
th1_range = 0.5:0.05:0.9; 
th2_range = [];
t2_range  = 60:20:300; %[mili-sec]
th3_range = 0.6:0.05:0.9;
FPR_max   = 0.15; % [%]
hold_time = 1500; %[mili-sec]
%% RUN GRID SEARCH
[TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = ...
    grid_search(...
    real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time);
%% Load optimal results 
th1_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th1;
th2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th2;
th3_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th3;
t2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").t2;
%% plot optimal results
hold_time = 1500; %[mili-sec]
[algo_labels,algo_vals] = get_algo_labels(th1, th2, t2,th3,hold_time);
%plot_results_stem(algo_vals);
%% Confusion matrix 
[united_times,united_algo_labels,united_real_labels] =...
            unite(times,algo_labels,real_labels,template_len);
dt = template_len*20;
plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt);
