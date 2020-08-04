function [united_xcorr, united_xcorr_times, united_real_t_vec,n] = unite2(move_name)%,wight_vec) 
%% NEED TO ADD COMENTS -NOT relevent
prev_xcorr=[]; 
prev_xcorr_times=[]; 
prev_real_t_vec=[]; 
prev_times = []; 
prev_n=0; 
    for i=1:length(move_name) 
        %load data 
        data_mat = loadMeasurmentMat(date,move_name{i},1,"INIT");  
        %gyro_data = data_mat(:,4:6); 
        curr_times = data_mat(:,20); 
        gyro = cat(2,data_mat(:,4:6),data_mat(:,20)); 
        % cal xcorr 
        [curr_xcorr,curr_xcorr_times] = xcorr_all_intresting_data(gyro,-1000,'normalized',"start");%? need another normlize? 
        % only times of start movment - length as num of movements in vec 
        orig_times = cell2mat(get_movment_times("start",{move_name{i}}));  
        curr_real_t_vec = orig_times; 
        % length as times 
        %orig_times = ismember(times,orig_times).*times;  
        curr_n = length(times); 
         
        [new_xcorr, new_xcorr_times, new_real_t_vec,new_times,n] = unite_two2one(... 
            prev_xcorr ,curr_xcorr, prev_xcorr_times,curr_xcorr_times,... 
            prev_real_t_vec,curr_real_t_vec, prev_times,curr_times,prev_n,curr_n); 
        prev_xcorr = new_xcorr; 
        prev_xcorr_times = new_xcorr_times; 
        prev_real_t_vec = new_real_t_vec; 
        prev_times = new_times; 
        prev_n = n; 
    end 
   united_xcorr = new_xcorr; 
   united_xcorr_times = new_xcorr_times; 
   united_real_t_vec =  new_real_t_vec; 
     
end 
%% help func 
function [new_xcorr, new_xcorr_times, new_real_t_vec,new_times,n] = unite_two2one(... 
            prev_xcorr ,curr_xcorr, prev_xcorr_times,curr_xcorr_times,... 
            prev_real_t_vec,curr_real_t_vec, prev_times,curr_times,prev_n,curr_n) 
if (~isempty(prev_xcorr))  
    n = prev_n+curr_n; 
    % unite xcorr data 
    new_xcorr = cat(1,prev_xcorr,curr_xcorr); 
    tf_xcorr = prev_xcorr_times(end)*ones(size(curr_xcorr_times)); 
    n_curr_xcorr_times = tf_xcorr + curr_xcorr_times; 
    new_xcorr_times = cat(1,prev_xcorr_times,n_curr_xcorr_times); 
    % unite xcorr times 
    tf_orig = prev_times(end)*ones(size(curr_real_t_vec)); 
    n_curr_real_t_vec = tf_orig +curr_real_t_vec; 
    new_real_t_vec = cat(1,prev_real_t_vec,n_curr_real_t_vec); 
    % unite original times 
    tf = prev_times(end)*ones(size(curr_times)); 
    n_curr_times = tf+curr_times; 
    new_times = cat(1,prev_times,n_curr_times); 
else  
    % init all to first loop 
    new_xcorr=curr_xcorr; 
    new_xcorr_times=curr_xcorr_times; 
    new_real_t_vec=curr_real_t_vec; 
    new_times = curr_times; 
    n=curr_n; 
end 
 
end 