function [TPR, FPR, TNR, PPV, th1_out, th2_out, t2_out ] = grid_search(...
            real_t_vec,n,xcorr_data,times,th1_range,th2_range,t2_range,FPR_max)
% func finds optimal params by the following demand:
% we limit FPR by FPR_max and find maximum for TPR under this demand.
% INPUT:
% 1. real_t_vec - times that we taged there is movement- prior
% 2. n - len of full labeled vector- we assume same lngth to algo and real
% labels
% 3. xcorr_data - cell array with 4 cells each containing - cross corelation of length:
% observation_window_size + largest correlation length and 3 channels, with
% one of the templates - "swipe left" , "swipe right" , "tap" & "ankle"
% 4. times - the times of the observed window.
% 5-6. th range - range to select th from 
% 7. t2_range - range to select duration th from in milisec
% 8. FPR_max - the limit in % for FPR in the demand 
% OUTPUT:
% 1. TPR - sensitivity : Probability of positive prediction given positive action.
% 2. FPR - Probability of positive prediction given negative action.
% 3. TNR - specifity: Probability of negative prediction given negative action.
% 4. PPV - presition: Probability of positive prediction to be correct.
% 5-6. th out - th value that gave us the maximal TPR under demand. 
% 7. t2_out - duration th in milisec that gave us the maximal TPR under demand.


op ='MinPeakHeight';
op1 = op;
op2 = op;
TPR = 0 ;
    for i1 = 1:length(th1_range)
        th1 = th1_range(i1);
        for i2 = 1:length(th2_range)
            th2 = th2_range(i2);
            TPR_vec = zeros(size(t2_range));
            FPR_vec = zeros(size(t2_range));
            TNR_vec = zeros(size(t2_range));
            PPV_vec = zeros(size(t2_range));
            for k = 1: length(t2_range)
                t2 = t2_range(k);
                [algo_labels,~,~,~] = tresholding_xcorr(xcorr_data,times,th1,op1,th2,op2,t2);
                algo_t_vec = times(algo_labels);

                    [TPR_vec(k) , FPR_vec(k), TNR_vec(k) , PPV_vec(k) ]= evaluation_rates(algo_t_vec, real_t_vec,template_len,n);
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
            end
        end
    end


end

