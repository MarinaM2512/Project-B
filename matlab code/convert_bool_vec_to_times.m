function [real_times,algo_times] = convert_bool_vec_to_times(real_labels,algo_labels,times)
% func  get matrix of labels type bool size NXnum_of_move and save iv cell
% only the times with the '1' labels.
% INPUT:
% algo_labels - bool array NXnum_of_movments(4)
% real_labels - bool array NXnum_of_movments(4)
% times - times resampled in the raw data
% OUTPUT:
% real_times - times that we taged there is movement- prior
% algo_times - times that algorithem taged there is movement
num_of_movements = 4;
real_times = cell(1,num_of_movements);
algo_times = cell(1,num_of_movements);
for i=1:num_of_movements
    real_times{i} = times(find(real_labels(:,i)));
    algo_times{i} = times(find(algo_labels(:,i)));
end
end