%% NEEd to change to xcorr insedof corr
%% NEED TO CHECK
function corr1 = effective_corr_calculation(data,win_s_len,win_s_shift,factor)
% GOAL: calculate correlation only on windows in which we suspect that a
% movement occured. we do this in order to improve time complexity.
% the idea is to flag a window if the avrage of the new samples is bigger
% then the previus avg by a factor. we flag with an helper func below.
% INPUT:
% data - gyro mat + time_vec
% win_s_len -  window length in sec
% win_s_shift - windows scan in sec
% factor - err factor above wich we sespect movement occurence
% OUTPUT:
% corr1 - cor result with all movements templates 
%       dims : window length X num_of_param(x,y,z) X num_of_movements (4)
% corr1(:,:,1) = corr_swl - corr result with swipe L template
% corr1(:,:,2) = corr_swr - corr result with swipe R template
% corr1(:,:,3) = corr_tap - corr result with tap template
% corr1(:,:,4) = corr_anc - corr result with side anckle template


% convert win params drom sec to index
Fs = 50 ; %[Hz]
win_len   = Fs *win_s_len;
win_shift = Fs *win_s_shift;
num_of_params = 3;
xcorr_swl = zeros( win_len, num_of_params);
xcorr_swr = zeros( win_len, num_of_params);
xcorr_tap = zeros( win_len, num_of_params);
xcorr_anc = zeros( win_len, num_of_params);
template_mat = loadTemplateMat;
lengths = zeros(size(template_mat));
for l=1:length(lengths)
    lengths(l) = size(template_mat{l},1);
end
prev_gmat = data(1:1+win_len,:);% data inside previus window (memory)
for i = 1:win_shift: length(data) % run on data vec with widows
    current_gmat = data(i+1,i+1+win_len,:); % data inside current window
    if (do_correlation(current_gmat,prev_gmat,win_shift,factor)) 
      [xcorr_swl(i,:), xcorr_swr(i,:), xcorr_tap(i,:), xcorr_anc(i,:)] = ...
                      gyro_xcorr(template_mat,current_gmat,i,lengths);
    end
    prev_gmat = current_gmat;
end
    corr1 = cat( 3, xcorr_swl, xcorr_swr, xcorr_tap, xcorr_anc);

end
%% helper func
function flag = do_correlation(current_data_window,prev_data_window,shift,factor)
% boolian function
% the idiea:
% err = (abs(prev_avg - curr_avg)/prev_avg);
% if err<factor return 1
% INPUT:
% current_data_window - data in selected window
% prev_data_window  - memory of old data
% shift - change between prev and current
% factor - when the error is above the factor return 1
% OUTPUT:
% flag - eq 1 if we sespect the is a movemwnt in curr window.
new_mes_vec = current_data_window(end-shift:end);
prev_avg = mean (prev_data_window);
l= length(new_mes_vec);
new_window = [prev_data_window(l:end) ; new_mes_vec];
new_avg = mean (new_window); 
err = (abs(prev_avg - new_avg)/prev_avg);
    if  err< factor
        flag = 0;
    else
        flag = 1;
    end
end

