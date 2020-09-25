function [real_times,algo_times] = convert_bool_vec_to_times(real_labels,algo_labels,times)
% func  get matrix of labels type bool size NXnum_of_move and save iv cell
% only the times with the '1' labels.
% INPUT:
% algo_labels - bool vec
% real_labels - bool vec
% times - times resampled in the raw data
% OUTPUT:
% real_times - vec times that we taged there is movement- prior
% algo_times - vec times that algorithem taged there is movement

    real_times = times(find(real_labels));
    algo_times = times(find(algo_labels));
    
end