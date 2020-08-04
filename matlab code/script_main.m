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
%% get data to insert grid_serch
date = "17_04";
endOrStart = 'start';
move_name = get_all_meas_names(date, "FILTERED_INIT", 1); % all names
real_labels = get_all_real_labels(endOrStart);
% save all xcorr data and all time sampels to cell
data_xcorr = cell(size(move_name')); 
times = cell(size(move_name'));
% orig_times = get_movment_times ("start",move_name);  
n=0;
for i=1:length(move_name) 
        %load data 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");  
        %gyro_data = data_mat(:,4:6); 
        times{i} = data_mat(:,20); 
        n=n+length(times{i});
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20)); 
        % cal xcorr 
        [data_xcorr{i}.corr,~] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");
        if(contains(move_name{i},"swipe_L"))
            data_xcorr{i}.type = 1;
        elseif(contains(move_name{i},"swipe_R"))
            data_xcorr{i}.type = 2;
        elseif(contains(move_name{i},"tap"))
            data_xcorr{i}.type = 3;
        elseif(contains(move_name{i},"side_ancle"))
            data_xcorr{i}.type = 4;
        else
            data_xcorr{i}.type = 0; %e.x walking
        end
            
end   

        % only times of start movment - length as num of movements in vec 
%         tmp_orig_times = cell2mat(get_movment_times("start",{move_name{i}}));  
%         % length as times 
%         orig_times{i} = ismember(times,tmp_orig_times);

    

%% demands params to all moves
th1_range = [0.7 1]; 
th2_range = [0.6 1];
t2_range  = [500 2000]; %[mili-sec]
FPR_max   = 30; % [%]

    
    [TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out] = grid_search(...
        united_real_t_vec,n,united_xcorr,united_xcorr_times,...
        th1_range,th2_range,t2_range,FPR_max);
    
    
 