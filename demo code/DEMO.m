%% 
clear all; close all; clc; 
%% Convert from text to mat & save
src_path = read_data_to_mat("24_08");
%% DEFINE 
date = "24_08"; 
path = "..\measurements\resample"; 
dst_path = strcat(path,"\",date);
endOrStart = "start";
template_len = 63; %[samples] 
hold_time = 1500; %[mili-sec] 
%% Filter &  Resample 
copyfile src_path dst_path
resample_and_filter_raw_data(path, date,5,"MEDIAN");
init_qaut_resampled_data(date);
%% LOAD thresholds 
% th found from runing grid_search on training set
th1_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th1; 
th2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th2; 
th3_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th3; 
t2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").t2;
%% XCORR
move_name = get_meas_names_from_dir(path, date, "FILTERED_INIT");   % all names
% init
xcorr_data = cell(size(move_name')); 
times = cell(size(move_name'));
n1=0; % length of times from all measurments
% each meas in cell
for i=1:length(move_name) 
        data_mat = load_measurment_mat_from_dir(path,date,move_name{i},"FILTERED_INIT");%load all data of meas i
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20));            %load gyro data of meas i
        times{i} = data_mat(:,20);                               %save time sampels of meas i
        n1=n1+length(times{i});                                    %update length of total time vec
        % cal xcorr and insert to corr fild
        [xcorr_data{i}.corr,~] = xcorr_all_intresting_data(gyro,'normalized',"start");     
end   
%% save xcorr, times , n in directory "to grid search"
clear n
n.val=n1;
xcorrData.val = xcorr_data;
Times.val = times;

xcorr_data_name=strcat(".\to grid search\",date,"\xcorr_data.mat");
save(xcorr_data_name,'-struct','xcorrData');

times_name=strcat(".\to grid search\",date,"\times.mat");
save(times_name,'-struct','Times');

n_name=strcat(".\to grid search\",date,"\n.mat");
save(n_name,'-struct','n');

real_labels = get_all_real_labels(endOrStart,date); 
realLabels.val = real_labels;
real_labels_name=strcat(".\to grid search\",date,"\real_labels.mat");
save(real_labels_name,'-struct','realLabels');
%% output labels 
[algo_labels,algo_vals] = get_algo_labels_new(...
    xcorr_data,times,th1_out, th2_out, t2_out,th3_out,hold_time);
%% Present results in matlab
