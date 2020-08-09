function [TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out,th3_out] = grid_search(...
            real_labels,n,xcorr_data,times,th1_range,th2_range,t2_range,th3_range,FPR_max,hold_time)
% func finds optimal params by the following demand:
% we limit FPR by FPR_max and find maximum for TPR under this demand.
% INPUT:
% 1. real_labels - cell array of labels that we taged movement times- prior. combined to
% all measurments. each cell contains Nx4 bynary matrix.
% 2. n - len of full labeled vector- we assume same lngth to algo and real
% labels
% 3. xcorr_data - cell array for all measurments each cell containing -a struct:
% field corr cross corelation of shape: Nx3x4 , where N is the measurment
% length , 3 channels - x,y,z, 4 templates - "swipe left" , "swipe right" ,
% "tap" & "ankle". field type is - 1 (for swipe left), 2 (for swipe right),
% 3 (for tap), 4 (for side ankle).
% 4. times - the times of the measurment arranged in a cell array with each
% cell containing the time vector of each measurment.
% 5-6. th range - range to select th from 
% 7. t2_range - range to select duration th from in milisec
% 8. th3_range - range to select th3 for final thresholding.
% 9. FPR_max - the limit in % for FPR in the demand 
% 10 . hold_time - maximal time difference in milli seconds in which we coose the
% largest peak for labeling.
% OUTPUT:
% 1. TPR - sensitivity : Probability of positive prediction given positive action.
% 2. FPR - Probability of positive prediction given negative action.
% 3. TNR - specifity: Probability of negative prediction given negative action.
% 4. PPV - presition: Probability of positive prediction to be correct.
% 5-6. th out - th value that gave us the maximal TPR under demand. 
% 7. t2_out - duration th in milisec that gave us the maximal TPR under demand.
% 8. t3_out - th3 for final labeling that gave us the maximal TPR under demand.

op ='MinPeakHeight';
op1 = op;
op2 = op;
TPR = 0 ;
template_len = 63;

    for i1 = 1:length(th1_range)
        th1 = th1_range(i1);
        for i2 = 1:length(th2_range)
            th2 = th2_range(i2);
            for i3 = 1:length(th3_range)
                th3 = th3_range(i3);
                TPR_vec = zeros(size(t2_range));
                FPR_vec = zeros(size(t2_range));
                TNR_vec = zeros(size(t2_range));
                PPV_vec = zeros(size(t2_range));
                for k = 1: length(t2_range)
                    t2 = t2_range(k);
                    algo_labels = cell(length(xcorr_data),4);
                    real_labels_final = cell(length(xcorr_data),4);
                    for j = 1:length(xcorr_data)
                        move_type = xcorr_data{j}.type;
                        curr_times = times{j};
                        Ts = curr_times(2)- curr_times(1);
                        hold_samp =  floor(hold_time/Ts);
                        xcorr_out = tresholding_xcorr(xcorr_data{j}.corr,curr_times,th1,op1,th2,t2);
                        [algo_labels_tmp,~] = labeling_xcorr(xcorr_out,th3,hold_samp);
                        real_labels_tmp = real_labels{j};
                        for a=1:4
                            algo_labels{j,a} = algo_labels_tmp(:,a);
                            real_labels_final{j,a} = real_labels_tmp(:,a); 
                        end
%                         algo_labels{j} = algo_labels_tmp(:,move_type);
%                         real_labels_final{j} = real_labels_tmp(:,move_type);
                    end
                    for a = 1:4
                        [united_times,united_algo_labels,...
                        united_real_labels] = unite(times,algo_labels(:,a),...
                        real_labels_final(:,a),template_len);
                        [real_times{a},algo_times{a}] = convert_bool_vec_to_times(...
                            united_real_labels,united_algo_labels,united_times);
                    end                    
                        [TPR_vec(k) , FPR_vec(k), TNR_vec(k) , PPV_vec(k) ]= evaluation_rates_full(algo_times, real_times,template_len,n);
                end
                ind = FPR_vec<=FPR_max; % damand
                tpr_tmp = zeros(size(t2_range));
                tpr_tmp(ind) = TPR_vec(ind);
                [TPR_tmp_max,ind_max] = max(tpr_tmp);
                if TPR_tmp_max>TPR
                    TPR = TPR_tmp_max;
                    FPR = FPR_vec(ind_max);
                    TNR = TNR_vec(ind_max);
                    PPV = PPV_vec(ind_max);
                    t2_out = t2_range(ind_max);
                    th1_out = th1;
                    th2_out = th2;
                    th3_out = th3;
                end
            end
        end
    end


end

