function [algo_labels,algo_labels_val] = get_algo_labels_new(...
                xcorr_data,times,th1,th2,t2,th3,hold_time) 
% function applies thresholding on xcorr result and labels it.
% The treshold values taken from grid_search
% INPUT:
% 1. xcorr_data - cell array for all measurments each cell containing -a struct:
%    field corr cross corelation of shape: Nx3x4 , where N is the measurment
%    length , 3 channels - x,y,z, 4 templates - "swipe left" , "swipe right" ,
%    "tap" & "ankle". field type is - 1 (for swipe left), 2 (for swipe right),
% 3 (for tap), 4 (for side ankle).
% 2. times - the times of the measurment arranged in a cell array with each
%    cell containing the time vector of each measurment.
% 3,4. th1=th2 - select peaks above th1
% 5. t2 - select peaks if they last t2 sec above th1
% 6. th3 - threshold appliyed after weighing xcorr.
% 7. hold_time - maximal time difference in samples in which we coose the
% largest peak for the final result.
% Ouput:
% labels - a Nx4 binary matrix which contains 1's at the vector locations
% of the start of a movement
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