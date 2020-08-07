%% NEED TO CHECK
function plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt)
new_real_labels = zeros(size(united_real_labels));
for i=1:n
    [j,flag] = is_movement(united_real_labels(i,:));
    if flag == 0
        continue
    else
        % Extreme Cases
        if i==1
            Ts = united_times(2)-united_times(1);
        else
            Ts = united_times(i)-united_times(i-1);
        end
        samples = floor(0.5*dt/Ts);                  %convert times to index
        ind0 = i-samples;
        indf = i+samples;
        if i<=samples %peak before dt
            ind0=1;
        elseif i>=n-samples %peak after t(end)-dt
            indf=n;
        end
        window = ind0:indf;                          % we look at [-0.5dt 0.5dt] time window
        k = is_movement(united_algo_labels(window,:));
        new_real_labels(k,j) = 1;
    end
end        
real_labels_out = add_class(new_real_labels);
algo_labels_out = add_class(united_algo_labels);
plotconfusion(real_labels_out',algo_labels_out');
end
%% 
function [ind,flags] = is_movement(labels)
flags = zeros(size(labels,1),1);
for i=1:length(flags)
    flags(i) = labels(i,1) | labels(i,2) | labels(i,3) | labels(i,4);
end
ind = find(flags);
end
    




