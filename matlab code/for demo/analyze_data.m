function [msg,next_i] = analyze_data(list_lines_curr,hold_samp,curr_i)
%list lines curr contains string lines of data (they should be filtered from
%calibration messages before sent to the function). the length of the list
%should be greater or equal to template_len+6 and hold_samp to satisfy the time condition of theresholding
%cross correlation.
%hold_samp - number of samples to save before current sample 
% Text data to mat
line=list_lines_curr{1};
first_time=seperate_timeString(line);
split_line= strsplit(line,{'[',']'});
original_string=[split_line{end} ' ' num2str(0)];
for i=2:length(list_lines_curr)
       line=list_lines_curr{i};
       time=seperate_timeString(line);
       num_ms=dt_func(first_time,time);
       split_line= strsplit(line,{'[',']'});
       original_string=[original_string newline split_line{end} ' ' num2str(num_ms)];
end
splitStr={original_string};
writecell(splitStr,'tmp.txt');
final=readmatrix('tmp.txt');
delete tmp.txt
final=final(1:end,:);
% Filter then Resample current data mat
all_data_medfilt=median_data_filt(final,5);
resampled_data = resample_all_data(all_data_medfilt);
Ts = resampled_data(3,20) - resampled_data(2,20);
% Preform cross correlation 
gyro_data = resampled_data(:,4:6);
gyro_data(:,end+1) = resampled_data(:,20);
[xcorr.corr,times] = xcorr_all_intresting_data(gyro_data,'normalized',"start");
xcorr = {xcorr};
times = {times};
% Load algo thresholds 
th1 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th1; 
th2 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th2; 
th3 = load("..\results after grid search\14-Aug-2020\thresholds.mat").th3; 
t2 = load("..\results after grid search\14-Aug-2020\thresholds.mat").t2;
% Preform labeling
[algo_labels,~] = get_algo_labels_new(...
                xcorr,times,th1,th2,t2,th3,hold_samp*Ts);
label_curr = algo_labels{1};
[~, ind_class] = find(label_curr);
if(~isempty(ind_class))
    msg = ind_class;
    next_i = curr_i+hold_samp;
else
    msg = -1;
    next_i = curr_i;
end


            



        
        
        
    
