function [swl, swr, tap, anc] = ...
                                gyro_cross_corr_normlized(template_mat,gyro_seg,num_of_params,op)
%%%Function computes cross 3D cross correlation with 4 different templates - 
% swipe left , swipe right, tap & side ankle.
%%%Inputs:
%1. template_mat - a cell containing 4 templtes in th order above.
% all templates at same size
%each cell is [N x 3 X2] where N is the template length and each
%column is X , Y ,Z part of the template.
% template_mat{i}(:,:,1) - data
% template_mat{i}(:,:,2) - time
%2. gyro_seg - a matrix containig 3 axis gyro measurment with size- Nx3 
%where N is the length of the data segmented.
%3.num_of_params is 3 - x, y, z exept if thhere are weights.
%4. op : parameter of xcorr matlab function
%  'none' -
% 'normlized' - 

%temp_lengths= cellfun(@(x) length(x),template_mat,'UniformOutput',false);
% max_tempalte_length =max([temp_lengths{1:4}]);
length_window = length(gyro_seg);
corr_swl = zeros(2*length_window-1,num_of_params);
corr_swr = zeros(2*length_window-1,num_of_params);
corr_tap = zeros(2*length_window-1,num_of_params);
corr_anc = zeros(2*length_window-1,num_of_params);
lags_swl = zeros(2*length_window-1,num_of_params);
lags_swr = zeros(2*length_window-1,num_of_params);
lags_tap = zeros(2*length_window-1,num_of_params);
lags_anc = zeros(2*length_window-1,num_of_params);
tempSL = template_mat{1}(:,:,1);
tempSR = template_mat{2}(:,:,1);
tempTap = template_mat{3}(:,:,1);
tempAnc = template_mat{4}(:,:,1);
% corr 2 vectors get scalar
for i=1:num_of_params %for each x,y,z
    [corr_swl(:,i),lags_swl(:,i)] = xcorr( gyro_seg(:,i),tempSL(:,i),op);
    [corr_swr(:,i),lags_swr(:,i)] = xcorr( gyro_seg(:,i),tempSR(:,i),op);
    [corr_tap(:,i),lags_tap(:,i)] = xcorr( gyro_seg(:,i),tempTap(:,i),op);
    [corr_anc(:,i),lags_anc(:,i)] = xcorr( gyro_seg(:,i),tempAnc(:,i),op);
end
swl = cat(3,corr_swl,lags_swl);
swr = cat(3,corr_swr,lags_swr); 
tap = cat(3,corr_tap,lags_tap);
anc = cat(3,corr_anc,lags_anc);
end
