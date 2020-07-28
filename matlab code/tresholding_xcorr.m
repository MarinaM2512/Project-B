function [labels,xcorr_out,diff,p] = tresholding_xcorr(xcorr,times,th1,op1,th2,op2,t2)
% function select peacks based on op - we want only dominant peaks of normlised xcorr
% based on 2 conditions:
% condition 1: select peaks above th1
% condition 2: select peaks if they last t2 sec above th2
% input:
% xcorr -a cell array with 4 cells each containing - cross corelation of length:
% observation_window_size + largest correlation length and 3 channels, with
% one of the templates - "swipe left" , "swipe right" , "tap" & "ankle"
% th - threshold value selected based on op
% op - str inserted to "findpeaks" and select the opration we wand to preform:
%     'Threshold' - select peaks that exceed their immediate neighboring 
%                   values by at least the value of th.
%     'MinPeakHeight' - select those peaks higher than th.
% times - the times of the observed window.
% t2 - min duration time that movement cross corr value is above th2.
% output:
% diff - error in %
% corr_out - only peaks vector corresponds with corr times
% p - num of peack selected
% labels - bool vector with length num of movements.
% 1- if matched to conditions
% (-1) - error
% order: swl, swr, tap, ank
% ex. if labels(1)=1 then movement detected as swl

% inisilize
num_of_movements = 4; % swl, swr, tap, ank
labels = -1*ones(1,num_of_movements); %inisilised to -1 for self check
xcorr_out = cellfun(@(x) zeros(size(x)),xcorr,'UniformOutput',false);
diff = cell(size(xcorr_out));
p = zeros(size(xcorr_out));

for i = 1:num_of_movements
    [labels(i),xcorr_out{i},diff{i},p(i)]= thresholding_xcorr_single_temp(xcorr{i},times{i},th1,op1,th2,op2,t2);
end
end
%%
function [label,xcorr_out,diff,p] = thresholding_xcorr_single_temp(xcorr,times,th1,op1,th2,op2,t2)
neg_times = sort(-times);
times_corr = cat(neg_times,times);
label =0;
% condition 1:
[peak,ind1] = findpeaks(xcorr,op1,th1);
p = length(peak);
if( ~isempty(peak))
    peakT = times_corr(ind1);
    % condiotion 2:
    [move_vals , move_times] = extract_movement_from_corr(xcorr,times_corr ,th2,t2);
    % In the functiom "extract_movement_from_corr" check if its better to
    % select the largest sequence of ones and then check if the peak lies
    % within this sequence, or mabe pick the sequence that the peak lies within
    % and check if its length is above threshold.
    if (~isempty(move_vals) && peakT>move_times(1) && peakT<move_times(end))
        label = 1;
        xcorr_out = move_vals;
        if strcmp(op1,"Threshold")
            diff = 100*th/peak;
        elseif strcmp(op1,"MinPeakHeight")
            diff = 100*((peak-th)./peak);
        end
    end
        
end
end