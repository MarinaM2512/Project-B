function [united_orig_times,united_algo_labels,united_real_labels] = unite(...
                  orig_times,algo_labels,real_labels,template_length)
% func unite all input cells to one united output
% all inputs type cell num_of_measx1, each meas in different cell
% we united the times to be continuous
% INPUT: 
% 1. xcorr_data - xcorr result
% 2. xcorr_times - times compatible with xcorr result
% 3. orig_times - times resampled in the raw data
% 4. algo_labels - bool array NXnum_of_movments(4)
% 5. real_labels - bool array NXnum_of_movments(4)
% 6. template_length - is samples
% OUTPUT: 
% in general, the input cell is converted to one long vec
% while maintaining a continuous time sequence
% 1. united_xcorr - xcorr results in one united vetor
% 2. united_xcorr_times - times compatible with xcorr result in one united
% vec
% 3. united_orig_times - times resampled in the raw data united in one vec
% 4. united_algo_labels -  bool array length of all meas X num_of_movments(4)
% 5. united_real_labels -  bool array length of all meas X num_of_movments(4)

prev_orig_times = [];
% unite xcorr data
united_algo_labels = cell2mat(algo_labels);
united_real_labels = cell2mat(real_labels);
    for i=1:length(orig_times) 
        curr_orig_times = orig_times{i};
        prev_orig_times = aux_unite_time(prev_orig_times,curr_orig_times,template_length);
         
    end 
   united_orig_times = prev_orig_times;
end
%% help func
function new_times = aux_unite_time(prev_times,curr_times,template_length)
% func unite two time vectors and maintain a time sequence as if the
% curr_times started when prev_times ended.
% INPUT:
% 1. prev_times - first vec to unite
% 2. curr_times -second vec to unite
% 3. template_length - is samples
% OUTPUT:
% new_times - new united and continuous time vector
if (~isempty(prev_times))  
    % unite times and maintain a time sequence
    prev_tf = prev_times(end);                          %[msec]
    Ts = curr_times(2)-curr_times(1);                   % time between two sampels [msec]
    dt = template_length*Ts;
    t0 = prev_tf + dt;                                  % the curr times need to start from t0
    t0_vec = t0 * ones(size(curr_times));               % convert to vec
    n_curr_times = t0_vec + curr_times;                 % add to curr_times t0
    new_times = cat(1,prev_times,n_curr_times);         % unite 
else  
    % init all to first loop 
    new_times = curr_times; 
end 
end