function [swl, swr, tap, anc] = ...
                                gyro_cross_corr(template_mat,gyro_mat,num_of_params)
%%%Function computes cross 3D cross correlation with 4 different templates - 
% swipe left , swipe right, tap & side ankle.
%%%Inputs:
%%template_mat - a cell containing 4 templtes in th order above.
%each template is [N_i x 3] where N_i is the template length and each
%column is X , Y ,Z part of the template.
%%gyro_mat - a matrix containig 3 axis gyro measur,ent with size- Nx3 
%where N is the length of the measured data.
%%num_of_params is 3 - x, y, z exept if thhere are weights.
temp_lengths= cellfun(@(x) length(x),template_mat,'UniformOutput',false);
max_tempalte_length =max([temp_lengths{1:4}]);
length_window = length(gyro_mat);
corr_swl = zeros(2*length_window-1,num_of_params);
corr_swr = zeros(2*length_window-1,num_of_params);
corr_tap = zeros(2*length_window-1,num_of_params);
corr_anc = zeros(2*length_window-1,num_of_params);
lags_swl = zeros(2*length_window-1,num_of_params);
lags_swr = zeros(2*length_window-1,num_of_params);
lags_tap = zeros(2*length_window-1,num_of_params);
lags_anc = zeros(2*length_window-1,num_of_params);
tempSL = template_mat{1};
tempSR = template_mat{2};
tempTap = template_mat{3};
tempAnc = template_mat{4};
% corr 2 vectors get scalar
for i=1:num_of_params %for each x,y,z
    [corr_swl(:,i),lags_swl(:,i)] = xcorr( gyro_mat(:,i),tempSL(:,i));
    [corr_swr(:,i),lags_swr(:,i)] = xcorr( gyro_mat(:,i),tempSR(:,i));
    [corr_tap(:,i),lags_tap(:,i)] = xcorr( gyro_mat(:,i),tempTap(:,i));
    [corr_anc(:,i),lags_anc(:,i)] = xcorr( gyro_mat(:,i),tempAnc(:,i));
end
swl = cat(3,corr_swl(length_window-max_tempalte_length:end,:),lags_swl(length_window-max_tempalte_length:end,:,:));
swr = cat(3,corr_swr(length_window-max_tempalte_length:end,:),lags_swr(length_window-max_tempalte_length:end,:,:));
tap = cat(3,corr_tap(length_window-max_tempalte_length:end,:),lags_tap(length_window-max_tempalte_length:end,:,:));
anc = cat(3,corr_anc(length_window-max_tempalte_length:end,:),lags_anc(length_window-max_tempalte_length:end,:,:));
end
