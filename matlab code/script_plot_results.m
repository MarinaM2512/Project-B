%%
clear all;
close all;
clc;
%% Plot classification results
xcorr_data = load("./to grid search/xcorr_data.mat").val;
times = load("./to grid search/times.mat").val;
real_labels = load("./to grid search/real_labels.mat").val;
n = load("./to grid search/n.mat").val;
real_labels_relevant_move  = cell(length(xcorr_data),1);
algo_labels  = cell(length(xcorr_data),1);
algo_labels_relevant_move  = cell(length(xcorr_data),1);
for j = 1:length(xcorr_data)
    move_type = xcorr_data{j}.type;
    curr_times = times{j};
    Ts = curr_times(2)- curr_times(1);
    hold_samp =  floor(hold_time/Ts);
    [~,xcorr_out] = tresholding_xcorr(xcorr_data{j}.corr,curr_times,th1,'',th2,t2);
    xcorr_out =cellfun(@(x) padarray(x,[(length(curr_times)-length(xcorr_out{1})),0],...
        0,'post'),xcorr_out,'UniformOutput',false);
    algo_labels_tmp = labeling_xcorr(xcorr_out,th3,hold_samp);
    algo_labels{j} = algo_labels;
    algo_labels_relevant_move{j} = algo_labels_tmp(:,move_type);
    real_labels_tmp = real_labels{j};
    real_labels_relevant_move{j} = real_labels_tmp(:,move_type);
end

%% Preformance evaluation
%% Confusion matrix 