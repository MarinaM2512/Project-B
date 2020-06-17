function corr_after_th_and_norm = tresholding_and_normlise_corr(times,corr,th,op)
% function select peacks based on op - we want only dominant peaks of corr
% normlise data based on th and returns peaks vec with original times
% input:
% times - vector -time stemps, uniform sampled
% corr - data vector correspondes to times
% th - thresh hold value selected based on op
% op - str inserted to "findpeaks" and select the opration we wand to preform:
%     'Threshold' - select peaks that exceed their immediate neighboring 
%                   values by at least the value of 'Threshold'.
%     'MinPeakHeight' - select those peaks higher than 'MinPeakHeight'
% output:
corr_out = zeros(size(corr));
n = max(corr);
corr = corr/n; % normilize
[p,ind] = findpeaks(corr,op,th);
corr_out(ind)= p;
diff = p-th;