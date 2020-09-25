function resa_all_data = resample_all_data(all_data)
% func uses the time stemp in raw data and resamples all_data
% INPUT- all_data :  raw-data 2D matrix size len_of_movment X 20
% OUTPUT- resa_all_data : resampled raw-data 2D matrix size len_of_muvment X 20
v  = all_data(:,1:end-1);
t  = all_data(:,end);
tr = linspace(min(t), max(t), length(t));       % Uniformly-Sampled Time Vector
resa_all_data = zeros(length(tr),size(all_data,2));
resa_all_data(:,end) = tr;
for i = 1:size(v,2)
    resa_all_data(:,i) = resample(v(:,i), tr);                   % Resampled Signal Vector
end
end
