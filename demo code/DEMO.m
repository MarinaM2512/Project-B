%% DEFINE 
% date = ""; 
% path = ""; 
endOrStart = 'start';
template_len = 63; %[samples] 
hold_time = 1500; %[mili-sec] 
%% LOAD thresholds 
th1_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th1; 
th2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th2; 
th3_out = load("./results after grid search/14-Aug-2020/thresholds.mat").th3; 
t2_out = load("./results after grid search/14-Aug-2020/thresholds.mat").t2;
%% XCORR
move_name = get_all_meas_names(date, "FILTERED_INIT", 1);   % all names
% init
xcorr_data = cell(size(move_name')); 
times = cell(size(move_name'));
n1=0; % length of times from all measurments
% each meas in cell
for i=1:length(move_name) 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");%load all data of meas i
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

xcorr_data_name=strcat(".\to grid search\xcorr_data.mat");
save(xcorr_data_name,'-struct','xcorrData');

times_name=strcat(".\to grid search\times.mat");
save(times_name,'-struct','Times');

n_name=strcat(".\to grid search\n.mat");
save(n_name,'-struct','n');
%% output labels 
[algo_labels,algo_vals] = get_algo_labels_new(...
    xcorr_data,times,th1_out, th2_out, t2_out,th3_out,hold_time);