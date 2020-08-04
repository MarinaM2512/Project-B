clear all; close all; clc;

%%
% get data to insert grid_serch
date = "17_04";
endOrStart = 'start';
move_name = get_all_meas_names(date, "FILTERED_INIT", 1);   % all names
real_labels = get_all_real_labels(endOrStart);              % cell of labels from all meas
% init
xcorr_data = cell(size(move_name')); 
times = cell(size(move_name'));
n=0;
% save each meas in cell
for i=1:length(move_name) 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");%load all data of meas i
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20));            %load gyro data of meas i
        times{i} = data_mat(:,20);                               %save time sampels of meas i
        n=n+length(times{i});                                    %update length of total time vec
        % cal xcorr and insert to corr fild
        [xcorr_data{i}.corr,~] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");
        % create and update type fild in data_xcorr
        % swipe L - 1, swipe R - 2, tap - 3, ankle - 4, else - 1
        if(contains(move_name{i},"swipe_L"))
            xcorr_data{i}.type = 1;
        elseif(contains(move_name{i},"swipe_R"))
            xcorr_data{i}.type = 2;
        elseif(contains(move_name{i},"tap"))
            xcorr_data{i}.type = 3;
        elseif(contains(move_name{i},"side_ancle"))
            xcorr_data{i}.type = 4;
        else
            xcorr_data{i}.type = 1; %e.x walking
        end
            
end   
%% demands params to all moves
th1_range = [0.7 1.3]; 
th2_range = [0.1 0.5];
t2_range  = [200 500]; %[mili-sec]
th3_range = [0.7 1];
FPR_max   = 30; % [%]
hold_time = 1500; %[mili-sec]
[TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = ...
    grid_search(...
    real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time);


  
    
    
 