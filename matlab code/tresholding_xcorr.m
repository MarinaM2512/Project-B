function [labels,xcorr_out] = tresholding_xcorr(xcorr,times,th1,op1,th2,t2)
% function select peacks based on op - we want only dominant peaks of normlised xcorr
% based on 2 conditions:
% condition 1: select peaks above th1
% condition 2: select peaks if they last t2 sec above th2
% input:
% xcorr -a cell array with 4 cells each containing - cross corelation of length:
% original measurement length by 3 channels - x,y,z. each cel coressponds
% to one of the templates - "swipe left" , "swipe right" , "tap" & "ankle"
% th - threshold value selected based on op
% op - str inserted to "findpeaks" and select the opration we wand to preform:
%     'Threshold' - select peaks that exceed their immediate neighboring 
%                   values by at least the value of th.
%     'MinPeakHeight' - select those peaks higher than th.
% times - the times of the observed window.
% t2 - min duration time that movement cross corr value is above th2.
% output:
% corr_out - only peaks vector corresponds with corr times
% p - num of peack selected
% labels - bool vector with dimentions Nx3x4, where N is the xcorr length.
% 1- if matched to conditions
% (-1) - error
% order: swl, swr, tap, ank


% inisilize
num_of_movements = 4; % swl, swr, tap, ank
labels = cellfun(@(x) zeros(size(x)),xcorr,'UniformOutput',false); %inisilised to -1 for self check
xcorr_out = cellfun(@(x) zeros(size(x)),xcorr,'UniformOutput',false);
% diff = cell(size(xcorr_out));


for i = 1:num_of_movements
    [labels{i},xcorr_out{i}]= thresholding_xcorr_single_temp(xcorr{i},times,th1,op1,th2,t2);
end
end
%%
function [labels,xcorr_out] = thresholding_xcorr_single_temp(xcorr,times,th1,op1,th2,t2)
times_corr = times;
labels = zeros(size(xcorr));
xcorr_out = zeros(size(xcorr));
% condition 1:
[peakX,indX] = findpeaks(xcorr(:,1),op1,th1);
[peakY,indY] = findpeaks(xcorr(:,2),op1,th1);
[peakZ,indZ] = findpeaks(xcorr(:,3),op1,th1);
% condiotion 2:
[~ , move_times] = extract_movement_from_corr(xcorr,times_corr ,th2,t2); %problem here because need to pass each channel separetly
if( ~isempty(move_times))
    if( ~isempty(peakX) || ~isempty(peakY) ||~isempty(peakZ) )
        for i = 1:length(xcorr)
            checkTh2 = cellfun(@(x) ismember(times_corr(i),x),move_times,...
               'UniformOutput',false);
            checkTh2 = sum(cell2mat(checkTh2))>0;
            if (ismember(i,indX))
                labels(i,1) = checkTh2;
                xcorr_out(i,1) = checkTh2*xcorr(i,1);
            end
            if (ismember(i,indY))
                labels(i,2) = checkTh2;
                xcorr_out(i,2) = checkTh2*xcorr(i,2);
            end
            if (ismember(i,indZ))
                labels(i,3) = checkTh2;
                xcorr_out(i,3) = checkTh2*xcorr(i,3);
            end
        end
    end
end     
end
