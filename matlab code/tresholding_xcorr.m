function [labels,xcorr_out,diff,p] = tresholding_xcorr(xcorr,th1,op1,th2,op2,t2)
% function select peacks based on op - we want only dominant peaks of normlised xcorr
% based on 2 conditions:
% condition 1: select peaks above th1
% condition 2: select peaks if they last t2 sec above th2
% input:
% corr - data vector correspondes to times
% th - thresh hold value selected based on op
% op - str inserted to "findpeaks" and select the opration we wand to preform:
%     'Threshold' - select peaks that exceed their immediate neighboring 
%                   values by at least the value of th.
%     'MinPeakHeight' - select those peaks higher than th.
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
xcorr_out = zeros(size(xcorr));
% confition 1:
    [peak1,ind1] = findpeaks(xcorr,op1,th1);

diff = zeros(size(peak));
p = length(peak);
xcorr_out(ind)= peak;
if strcmp(op,"Threshold")
    diff = 100*th/peak;
elseif strcmp(op,"MinPeakHeight")
    diff = 100*((peak-th)./peak);
end
end