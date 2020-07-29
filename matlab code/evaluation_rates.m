function [TPR , FPR, TNR , PPV ]= evaluation_rates(algo_t_vec, real_t_vec,template_len,n)
% function calculates rates in % using known evaluation rates
% assume times diffrences in real_t_vec larger then dt
% assume times diffrences in algo_t_vec larger then dt
%  
% INPUT:
% 1. algo_t_vec - times when labels that our algorithem found is '1'
% 2. real_t_vec - times that we taged there is movement- prior
% 3. template_len - in sampels
% 4. n- len of full labeled vector- we assume same lngth to algo and real
% labels
% OUTPUT:
% 1. TPR - sensitivity : Probability of positive prediction given positive action.
% 2. FPR - Probability of positive prediction given negative action.
% 3. TNR - specifity: Probability of negative prediction given negative action.
% 4. PPV - presition: Probability of positive prediction to be correct.
[tp ,fp, tn, fn] = performance_evaluation(algo_t_vec, real_t_vec,template_len,n);
TPR = tp/(tp+fn);
FPR = FP/(tn+fp);
TNR = tn/(tn+fp);
PPV = tp/(tp+fp);


end