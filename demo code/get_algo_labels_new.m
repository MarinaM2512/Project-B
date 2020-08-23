function [algo_labels,algo_labels_val] = get_algo_labels_new(xcorr_data,times,th1,th2,t2,th3,hold_time) 
op1 ='MinPeakHeight'; 
algo_labels  = cell(length(xcorr_data),1); 
algo_labels_val  = cell(length(xcorr_data),1); 
for j = 1:length(xcorr_data) 
    curr_times = times{j}; 
    Ts = curr_times(2)- curr_times(1); 
    hold_samp =  floor(hold_time/Ts); 
    xcorr_out = tresholding_xcorr(xcorr_data{j}.corr,curr_times,th1,op1,th2,t2); 
    [algo_labels_tmp,algo_labels_val{j}] = labeling_xcorr(xcorr_out,th3,hold_samp); 
    algo_labels{j}  = algo_labels_tmp; 
end 
end