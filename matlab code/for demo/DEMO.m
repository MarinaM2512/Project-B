%% 
clear all; close all; clc; 
% add matlab code to search path
oldpath = path;
path(oldpath,"C:\Users\Marina\Documents\Technion\Winter semester 2020\Project B\Project-B\matlab code");
%% DEFINE 
% Replace Date with the date of the measurments
date = "24_08"; 
%Save new measurement (from tera term) in folder measurements on the same level as matlab
% in a new folder with the relevant date.
folderPath = "..\..\measurements\resample"; 
endOrStart = "start";
template_len = 63; %[samples] 
hold_time = 1500; %[mili-sec] 
%% Convert from raw text to mat & save - use for new data recording
srcPath = "..\..\measurements\";
read_data_to_mat(srcPath,folderPath,date); 
%% Filter &  Resample - use for new data recording
resample_and_filter_raw_data(folderPath, date,5,"MEDIAN");
init_qaut_resampled_data(folderPath,date)
%% XCORR
%Preform cross correlation of templats with data vector
move_name = get_meas_names_from_dir(folderPath, date, "FILTERED_INIT");   % all names
% init
xcorr_data = cell(size(move_name')); 
times = cell(size(move_name'));
n1=0; % length of times from all measurments
% each meas in cell
order = cell(length(move_name) ,1); %
for i=1:length(move_name) 
        data_mat = load_measurment_mat_from_dir(folderPath,date,move_name{i},"FILTERED_INIT");%load all data of meas i
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20));            %load gyro data of meas i
        times{i} = data_mat(:,20);                               %save time sampels of meas i
        n1=n1+length(times{i});                                    %update length of total time vec
        % cal xcorr and insert to corr fild
        [xcorr_data{i}.corr,~] = xcorr_all_intresting_data(gyro,'normalized',"start");
        if(contains(move_name{i},"all"))
            % For detection of true labels (Preformence evaluation) -
            % If the current measurement is more than one type, it should 
            % have the word all in it and order sholud contain the order of 
            % movements where: swipe left = 1, swipe right = 2, tap = 3,
            % side ankle = 4.
            order{i} = [1 1 2 2 3 3 4 4 1 2 3 4 3 2 4 1];
        end
end   
%% save xcorr, times , n in directory "to grid search"
clear n
n.val=n1;
xcorrData.val = xcorr_data;
Times.val = times;

xcorr_data_name=strcat("..\variables for labeling\",date,"\xcorr_data.mat");
save(xcorr_data_name,'-struct','xcorrData');

times_name=strcat("..\variables for labeling\",date,"\times.mat");
save(times_name,'-struct','Times');

n_name=strcat("..\variables for labeling\",date,"\n.mat");
save(n_name,'-struct','n');

real_labels = get_all_real_labels(endOrStart,date,order); 
realLabels.val = real_labels;
real_labels_name=strcat("..\variables for labeling\",date,"\real_labels.mat");
save(real_labels_name,'-struct','realLabels');
%% LOAD parms - start here if not new measurement
xcorr_data = load(strcat("..\variables for labeling\",date,"\xcorr_data.mat")).val;
times = load(strcat("..\variables for labeling\",date,"\times.mat")).val;
real_labels = load(strcat("..\variables for labeling\",date,"\real_labels.mat")).val;
n = load(strcat("..\variables for labeling\",date,"\n.mat")).val;
th1_out = load("..\results after grid search\14-Aug-2020\thresholds.mat").th1; 
th2_out = load("..\results after grid search\14-Aug-2020\thresholds.mat").th2; 
th3_out = load("..\results after grid search\14-Aug-2020\thresholds.mat").th3; 
t2_out = load("..\results after grid search\14-Aug-2020\thresholds.mat").t2;
%% Output labels
%algo_labels is cell array containing a binary matrix - Nx4 , for each 
%measurment in the current directoty, where N is the length of the original 
%data vector, and each column contains the 1 where the algorithm detected 
%each  movement and 0 otherwise. the columns correspond to: 1-swipe left,
%2 - swipe right, 3- tap, 4- side ankle
[algo_labels,algo_vals] = get_algo_labels_new(...
    xcorr_data,times,th1_out, th2_out, t2_out,th3_out,hold_time);
% save the labels to the current folder
destdirectory = strcat(".\algo labels\",date);
if ~exist(destdirectory, 'dir')
    mkdir(destdirectory);
    mat_name=strcat(destdirectory,"\algo_labels",".mat");
    save(mat_name,'algo_labels'); 
end
%% Present results in matlab
plot_results_stem(algo_vals,date);
%%Confusion matrix 
[united_times,united_algo_labels,united_real_labels] =...
            unite(times,algo_labels,real_labels,template_len);
dt = template_len*20;
plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt);