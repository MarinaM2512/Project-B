function [xcorr_swl,xcorr_swr,xcorr_tap,xcorr_anc] = xcorr_to_intresting_data(template_mat,currentSeg,prevSeg,factor,op)
% GOAL: check if movement occured in seg calculate correlation. 
% we do this in order to improve time complexity.
% the idea is to flag a window if the avrage of the new samples is bigger
% then the previus avg by a factor. we flag with an helper func below.
% INPUT:
% 1. template_mat - cell of templates for all movments
%           template_mat{1} - swipe left template
%           template_mat{2} - swipe right template
%           template_mat{3} - tap template
%           template_mat{4} - side anckle template
% 2. correntSd - current data segment for x,y,z
% (we check if the current seg is intresting to us)
% 3. prevSd - previous data segment for x,y,z
% (the previous segments are the system's memory)
% 4. factor - err factor above which we suspect movement occurence
% 5. op - optionof xcorr matlab func
% 'normalized' / 'none'
% OUTPUT:
% Return the cross correllation at lag 0 - Rxy(0) for each segment
%       dims : 1 X num_of_param(x,y,z) X 2 (xcorr data,lags)
% xcorr_swl - normlized cross corr result with swipe L template
% xcorr_swr - normlized cross corr result with swipe R template
% xcorr_tap - normlized cross corr result with tap template
% xcorr_anc - normlized cross corr result with side anckle template

len = length(currentSeg);
num_of_params = 3;
flag = do_correlation(currentSeg,prevSeg,factor);
xcorr_swl =[];
xcorr_swr = [];
xcorr_tap = [];
xcorr_anc =[];
     if (flag)
      [swl, swr, tap, anc] = ...
                      gyro_cross_corr_normlized(template_mat,currentSeg,num_of_params,op);
      [ind_swl,~] = find(swl(:,:,2) == 0);
      [ind_swr,~] = find(swr(:,:,2) == 0);
      [ind_tap,~] = find(tap(:,:,2) == 0); 
      [ind_anc,~] = find(anc(:,:,2) == 0); 
      xcorr_swl = swl(ind_swl(1),:,1);
      xcorr_swr = swr(ind_swr(1),:,1);
      xcorr_tap = tap(ind_tap(1),:,1);
      xcorr_anc = anc(ind_anc(1),:,1);            
     end
end
%% helper func
function flag = do_correlation(currentSeg,prevSeg,factor)
% boolian function
% the idea:
% err = (abs(prev_avg - curr_avg)/prev_avg);
% if err<factor return 1
% INPUT:
% currentSeg - data in selected seg
% prevSeg  - memory of old data
% factor - when the error is above the factor return 1
% OUTPUT:
% flag - eq 1 if we sespect the is a movemwnt in curr window

new_avg = mean (currentSeg); 
prev_avg = mean (prevSeg);

err = (abs(prev_avg - new_avg)/prev_avg);
    if  err< factor
        flag = 0;
    else
        flag = 1;
    end
end

