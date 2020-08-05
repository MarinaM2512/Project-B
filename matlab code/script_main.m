clear all; close all; clc;

%%
% get data to insert grid_serch
xcorr_data = load("./to grid search/xcorr_data.mat").val;
times = load("./to grid search/times.mat").val;
real_labels = load("./to grid search/real_labels.mat").val;
n = load("./to grid search/n.mat").val;

%% demands params to all moves
% th1_range = [0.7 1.3]; 
% th2_range = [0.1 0.5];
% t2_range  = [200 500]; %[mili-sec]
% th3_range = [0.7 1];
th1_range = 0.7:0.05:1.3; 
th2_range = 0.1:0.05:0.5;
t2_range  = 200:10:500; %[mili-sec]
th3_range = 0.7:0.05:1;
FPR_max   = 30; % [%]
hold_time = 1500; %[mili-sec]
[TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = ...
    grid_search(...
    real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time);


  
    
    
 