function plot_confusion_matrix(united_real_labels,united_algo_labels,united_times,n,dt)
% func plot confusion matrix for labels that not has the same index but refer to the 
% same movement.
% we define new_labels that represents the real labels shifted to the
% same index in it algo has movement.
% we assume that in the time window defined by dt only one movement accures
% func chooses only the movements accured based on real_labels and look at
% algo labels in that time window.
% we falg new_label same as the real_label value but at the index algo has
% movement
% if algo didnt detected move in window the new is same as real
% if algo detected more then one movement we choose the closest in time to
% the real move found.
% INPUT:
% 1.united_real_labels - bool array length of all meas X num_of_movments(4)
% 2.united_algo_labels -  bool array length of all meas X num_of_movments(4)
% 3.united_times - times resampled in the raw data united in one vec
% 4.n - length of times
% 5.dt - the time range in which we can assume a single movement occurence
%       (or no movement occurence). the time window defined by [t-0.5dt t+0.5dt]
%       where t is the occurence time of the real movement.
% OUTPUT: non, the function plots the matrix.

new_real_labels = zeros(size(united_real_labels));
[move_ind,~] = is_movement(united_real_labels); % in each labels check if movement accured
for i1=1:length(move_ind)                                          % run on length of labels 
    i=move_ind(i1);  
    move_type = find(united_real_labels(i,:));   % which movement accured
    % Extreme Cases
    if i==1
        Ts = united_times(2)-united_times(1);
    else
        Ts = united_times(i)-united_times(i-1);
    end
    samples = floor(0.5*dt/Ts);                  %convert times to index
    ind0 = i-samples;                            % start window at t0=t-0.5dt
    indf = i+samples;                            % end window at tf=t+0.5dt
    if i<=samples                                % if t-0.5dt<0
        ind0=1;                                  % then t0=0
    elseif i>=n-samples                          % if t+0.5dt>t(end)
        indf=n;                                  % then tf=t(end)
    end
    window = ind0:indf;                          % we look at [t-0.5dt t+0.5dt] time window
    [k_vec,~] = is_movement(united_algo_labels(window,:)); % find where algo detected move
    if (isempty(k_vec))                          % if no movement was detected in algo
        new_real_labels(i,:)= united_real_labels(i,:); % use original real label
    else
        k = closest_to_i(i,ind0+k_vec);          % in algo choose the closest to real movement 
        new_real_labels(k,move_type) = 1;        % in the places that algo detected movements-
                                                 % insted of the algo label detected,
                                                 % put the real label
    end
end
% most of the labels are 4d zeros- we ignor them
real_labels_out = delete_zeros(new_real_labels);
algo_labels_out = delete_zeros(united_algo_labels);
% plot confusion matrix- comparing new and algo
plotconfusion(real_labels_out',algo_labels_out');
end
%% 
function [ind,flags] = is_movement(labels)
% func gets NX4 labels array and returns the indexs in which any movement
% happend and NX1 flags vector where has '1' where any movement happend
flags = labels(:,1) | labels(:,2) | labels(:,3) | labels(:,4);
ind = find(flags);
end
%% 
function min_val = closest_to_i(i,k)
[~,idx]=min(abs(k-i));
min_val=k(idx);
end
%%
function labels_out = delete_zeros(labels_in)
[~,flags] = is_movement(labels_in);
labels_out = labels_in(flags,:);
end



