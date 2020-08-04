function labels = labeling_xcorr(xcorr_thresholded,thresh_val,hold_time)
%%% Goal: produce final binary labeling by preforming the following steps:
% 1. recieve xcorr after initial thresholding , use weights to combine 3
%axis xcorr to one dimetion. after weighting with each template weigth, we get matrix
% with shape Nx4, 
% 2. use threshold on the weighted vectors to remove irrelevant peaks.
% 3. check if in the period of time in samples marked as hold_time before the current
% peak there are other peaks and coose the largest.

%%% Input:
% 1. xcorr_thresholded - cell arry with 4 cells contaning xcorr after it has been thresholded. 
% shape Nx3.
% where N is the number of samples in the current measurment.
% 2. thresh_val - threshold appliyed after weighing xcorr.
% 3. hold_time - maximal time difference in samples in which we coose the
% largest peak for the final result.

%%% Ouput:
% labels - a Nx4 binary matrix which contains 1's at the vector locations
% of the start of a movement

%init 
labels = zeros(length(xcorr_thresholded{1}),4);
label_values =  zeros(length(xcorr_thresholded{1}),4);

%Load weights
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr; 
wight_vec = [vec_swl vec_swr vec_tap vec_ank];
%Take absolute value of weights (because otherwise detection is not good).
wight_vec = abs(wight_vec);
if (~isempty(xcorr_thresholded))
    xcorr_out = reshape(cell2mat(xcorr_thresholded),[length(xcorr_thresholded{1}),3,4]);
    xcorr_weighted = zeros(length(xcorr_out),4);
    for i = 1:length(xcorr_out)
        for j =1:4
            % if there is a slight shift (not more than 5 samples) 
            % between the peaks in different axis move them together so that
            % the weighing will give the correct result.
            ind1 = find(xcorr_out(i,:,j));
            ind2 = find(xcorr_out(i,:,j) == 0);
            vec_new = zeros(3,1);
            if(~isempty(ind1))
               vec_new(ind1) = xcorr_out(i,ind1,j);
               for k = 1:length(ind2)
                   if( i<=length(xcorr_out)-1)
                       num_ahead= min(length(xcorr_out)-i,10);
                       ind_other = find(xcorr_out(i:i+num_ahead,ind2(k),j));
                       if( ~isempty(ind_other))
                           vec_new(ind2(k)) = xcorr_out(i+ind_other(1)-1,ind2(k),j);
                           xcorr_out(i+ind_other(1)-1,ind2(k),j) = 0;
                       end
                   end
               end
            end    
            xcorr_weighted(i,j) = sum(vec_new.* wight_vec(:,j));
        end
    end
    thresholded = zeros(size(xcorr_weighted));
    for i=1:4
        thresholded(:,i) =  xcorr_weighted(:,i).*(xcorr_weighted(:,i) > thresh_val);
    end
    for i = 1: length(thresholded)
        peak_ind = find(thresholded(i,:),1);
        if(~isempty(peak_ind))
            is_larger = 0;
            [curr_max,max_ind] = max(thresholded(i,:)); 
            if(i>1)
                hold = min(hold_time,i-1);
                for j = 1:4
                    is_larger = is_larger || ~isempty(find(label_values(i-hold:i-1,j)>curr_max,1));
                end
            end
            labels(i,max_ind) = (~is_larger);
            label_values(i,max_ind) = (~is_larger)*curr_max;
        end
    end
end
end

