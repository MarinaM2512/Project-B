function [TPR , FPR, TNR , PPV ] =  evaluation_rates_modified_FP(algo_t_vec, real_t_vec,template_len,n)
% function calculates rates in % using known evaluation rates
% this function takes into consideration the false recognition of movements
% of the wrong type.
% it calculates the statistical measures for each movement type separetley
% and the final measures are their mean value. 
% INPUT:
% 1. algo_t_vec - times when labels that our algorithem found is '1' ( cell array for 4
% channels) - Nx4
% 2. real_t_vec - times that we taged there is movement- prior, cell array
% for 4 channels
% 3. template_len - in sampels
% 4. n- len of full real labeled vector
% OUTPUT:
% 1. TPR - sensitivity : Probability of positive prediction given positive action.
% 2. FPR - Probability of positive prediction given negative action.
% 3. TNR - specifity: Probability of negative prediction given negative action.
% 4. PPV - presition: Probability of positive prediction to be correct.
TP_tot = zeros(4,1);
TN_tot = zeros(4,1);
FP_tot = zeros(4,1);
FN_tot = zeros(4,1);
TPR_tot = zeros(4,1);
TNR_tot = zeros(4,1);
FPR_tot = zeros(4,1);
PPV_tot = zeros(4,1);
for i=1:length(algo_t_vec)
    for j = 1:length(real_t_vec)
        [tp ,fp, ~, fn] = performance_evaluation(algo_t_vec{i}, real_t_vec{j},template_len,n);
        if (i==j)
           TP_tot(i) = TP_tot(i)+ tp;
           FP_tot(i) = FP_tot(i) +fp;
           FN_tot(i) = FN_tot(i) +fn;
        else
           FP_tot(i) = FP_tot(i) +tp; 
        end
    end
    TN_tot(i) = n - (TP_tot(i)+FP_tot(i)+FN_tot(i));
    TPR_tot(i) = TP_tot(i)/(TP_tot(i)+FN_tot(i));
    TNR_tot(i) = TN_tot(i)/(TN_tot(i)+FP_tot(i));
    PPV_tot(i) = TP_tot(i)/(TP_tot(i)+FP_tot(i));
    FPR_tot(i) = 1-PPV_tot(i);
end
TPR = mean(TPR_tot);
FPR = mean(FPR_tot);
TNR = mean(TNR_tot); 
PPV = mean(PPV_tot);
end
