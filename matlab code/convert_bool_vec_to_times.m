function [real_times,algo_times] = convert_bool_vec_to_times(algo_labels,real_labels,times)
mun_of_movements = 4;
real_times = cell(1,mun_of_movements);
algo_times = cell(1,mun_of_movements);
for i=1:mun_of_movements
    real_times{i} = times(real_labels(:,i));
    algo_times{i} = times(algo_labels(:,i));
end
end