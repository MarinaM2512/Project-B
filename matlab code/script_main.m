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
th1_range = 0.7; 
th2_range = 0.3;
t2_range  = 200; %[mili-sec]
th3_range = 0.7;
% th1_range = 0.6:0.05:1; 
% th2_range = 0.1:0.05:0.5;
% t2_range  = 200:20:400; %[mili-sec]
% th3_range = 0.7:0.05:1;
FPR_max   = 30; % [%]
hold_time = 1500; %[mili-sec]
%% RUN GRID SEARCH
[TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = ...
    grid_search(...
    real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time);
%% plot optimal results
algo_labels = get_algo_labels(th1_out, th2_out, t2_out,th3_out,hold_time);
plot_results_stem(algo_labels);
%% Confusion matrix 
[united_times,united_algo_labels,...
                        united_real_labels] = unite(times,algo_labels,...
                        real_labels,template_len);

plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt);
  
    
    
 