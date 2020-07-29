function [tp ,fp, tn, fn] = performance_evaluation(algo_t_vec, real_t_vec,template_len,n)
% func calculates TP ,FP, TN, FN  in sampels by defnition to evaluate performance
% assume times diffrences in real_t_vec larger then dt
% assume times diffrences in algo_t_vec larger then dt
%  
% INPUT:
% 1. algo_t_vec - times when labels that our algorithem found is '1'
% 2. real_t_vec - times that we taged there is movement- prior
% 3. template_len - in sampels
% 4. n- len of full labeled vector- we assume same lngth to algo and real
% labels
% OUTPUT: in samples
% 1. tp - TP: both algo labels   & real labels is '1'
% 2. fp - FP: algo labels == '1' & real labels == '0'
% 3. tn - TN: both algo labels   & real labels is '0'
% 4. fn - FN: algo labels == '0' & real labels == '1'
% n_algo = length(find(algo_t_vec)); %num of '1' in labels
% n_real = length(find(real_t_vec));
tp = 0;
Ts = 20; %[ms]
dt = template_len*Ts;
algo_flag = 0;
fp_flag_array = zeros(size(algo_t_vec));
tp_flag_array = zeros(size(real_t_vec));
fn_flag_array = ones(size(real_t_vec));
for i = 1:length(algo_t_vec)     
    for k = 1:length(real_t_vec)
        t_tmp = algo_t_vec(i)- real_t_vec(k);
        
        if abs(t_tmp)<dt 
            algo_flag = 0;
            if tp_flag_array(k) ==1
                continue
            else
                tp_flag_array(k) = 1;
                fn_flag_array(k)=0;
                break
            end
        else
           algo_flag =1;
        end
    end
    if algo_flag == 1
        fp_flag_array(i) = 1;
        algo_flag=0;
    end
end
tp = sum(tp_flag_array);
fp = sum(fp_flag_array);
fn = sum(fn_flag_array);
tn = n-fp-fn-tp;


end 
