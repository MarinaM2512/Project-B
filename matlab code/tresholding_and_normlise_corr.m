function [corr_out,diff,p] = tresholding_and_normlise_corr(corr,th,op)
% function select peacks based on op - we want only dominant peaks of corr
% normlise data based on th and returns peaks vec with original times
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
corr_out = zeros(size(corr));
% n = max(corr);
% corr = corr/n; % normilize
[peak,ind] = findpeaks(corr,op,th);
diff = zeros(size(peak));
p = length(peak);
corr_out(ind)= peak;
if strcmp(op,"Threshold")
    diff = 100*th/peak;
elseif strcmp(op,"MinPeakHeight")
    diff = 100*((peak-th)./peak);
end
end