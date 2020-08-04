clear all; close all; clc;
%% Load PCA weights
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr; 
wight_vec = [vec_swl vec_swr vec_tap vec_ank];
%% 
date = "17_04";
move_name = get_all_meas_names(date, "FILTERED_INIT", 1); % all names
%% use unite2
[united_xcorr, united_xcorr_times, united_real_t_vec] = unite2(move_name);
%% use unite
% save all xcorr data to cell
data_xcorr = cell(size(move_name'));
times_xcorr = cell(size(move_name'));
for i=1:length(move_name) 
        %load data 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");  
        %gyro_data = data_mat(:,4:6); 
        times{i} = data_mat(:,20); 
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20)); 
        % cal xcorr 
        [data_xcorr{i},times_xcorr{i}] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");%? need another normlize? 
        % only times of start movment - length as num of movements in vec 
        tmp_orig_times = cell2mat(get_movment_times("start",{move_name{i}}));  
%         % length as times 
%         orig_times{i} = ismember(times,tmp_orig_times);
end 

    

%% demands params to all moves
th1_range = [0.7 1]; 
th2_range = [0.6 1];
t2_range  = [500 2000]; %[mili-sec]
FPR_max   = 30; % [%]

    
    [TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out] = grid_search(...
        united_real_t_vec,n,united_xcorr,united_xcorr_times,...
        th1_range,th2_range,t2_range,FPR_max);