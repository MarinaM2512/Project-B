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
TPR = -1 ;
FPR = -1;
TNR = -1;
PPV = -1;

template_len = 63;
warning_msg = 'signal:findpeaks:largeMinPeakHeight';
num_itr = length(th1_range)*length(th2_range)*length(th3_range)*...
    length(t2_range);
itr = 1;
f = waitbar(0,'starting grid search');
TPR_vec = zeros(num_itr,1);
FPR_vec = 2*ones(num_itr,1);
TNR_vec = zeros(num_itr,1);
PPV_vec = zeros(num_itr,1);
t2_out_vec = zeros(num_itr,1);
th1_out_vec = zeros(num_itr,1);
th2_out_vec = zeros(num_itr,1);
th3_out_vec = zeros(num_itr,1);
    for i1 = 1:length(th1_range)
        th1 = th1_range(i1);
        for i2 = 1:length(th2_range)
            th2 = th2_range(i2);
            for i3 = 1:length(th3_range)
                th3 = th3_range(i3);
                for k = 1: length(t2_range)
                    t2 = t2_range(k);
                    algo_labels = cell(length(xcorr_data),4);
                    real_labels_final = cell(length(xcorr_data),4);
                     waitbar(itr/num_itr,f,"Iteration: " + num2str(itr) + " out of: " + ...  
                        num2str(num_itr));
                    itr = itr+1;
                    for j = 1:length(xcorr_data)
                        curr_times = times{j};
                        Ts = curr_times(2)- curr_times(1);
                        hold_samp =  floor(hold_time/Ts);
                        xcorr_out = tresholding_xcorr(xcorr_data{j}.corr,curr_times,th1,op1,th2,t2);
                        [algo_labels_tmp,~] = labeling_xcorr(xcorr_out,th3,hold_samp);
                        [~, msgid] = lastwarn;
                        if(strcmp(msgid,warning_msg))
                            lastwarn('');
                            continue;
                        end
                        real_labels_tmp = real_labels{j};
                        for a=1:4
                            algo_labels{j,a} = algo_labels_tmp(:,a);
                            real_labels_final{j,a} = real_labels_tmp(:,a); 
                        end
                    end
                    for a = 1:4
                        [united_times,united_algo_labels,...
                        united_real_labels] = unite(times,algo_labels(:,a),...
                        real_labels_final(:,a),template_len);
                        [real_times{a},algo_times{a}] = convert_bool_vec_to_times(...
                            united_real_labels,united_algo_labels,united_times);
                    end                    
                        [TPR_vec(itr) , FPR_vec(itr), TNR_vec(itr) , PPV_vec(itr) ]= evaluation_rates_modified_FP(algo_times, real_times,template_len,n);
                        t2_out_vec(itr) = t2;
                        th1_out_vec(itr) = th1;
                        th2_out_vec(itr) = th2;
                        th3_out_vec(itr) = th3;
%                         TPR_vec_tmp(k)=TPR_vec(itr);
%                         FPR_vec_tmp(k) =FPR_vec(itr);
%                         TNR_vec_tmp(k) =TNR_vec(itr);
%                         PPV_vec_tmp(k) = PPV_vec(itr);
                end
%                 ind = FPR_vec_tmp<=FPR_max; % damand
%                 %tpr_tmp = zeros(size(t2_range));
%                 tpr_tmp = TPR_vec_tmp(ind);
%                 [TPR_tmp_max,ind_max] = max(tpr_tmp);
%                 if TPR_tmp_max>TPR
%                     TPR = TPR_tmp_max;
%                     FPR = FPR_vec(ind_max);
%                     TNR = TNR_vec(ind_max);
%                     PPV = PPV_vec(ind_max);
%                     t2_out = t2_range(ind_max);
%                     th1_out = th1;
%                     th2_out = th2;
%                     th3_out = th3;
%                 end
            end
        end  
    end
close(f);
ind_FPR_demand = find(FPR_vec<=FPR_max);
if(~isempty(ind_FPR_demand))
    TPR_under_FPR_demand = TPR_vec(ind_FPR_demand);
    [TPR,ind_opt_tmp] = max(TPR_under_FPR_demand);
    ind_opt= ind_FPR_demand(ind_opt_tmp);
    FPR = FPR_vec(ind_opt);
    TNR = TNR_vec(ind_opt);
    PPV = PPV_vec(ind_opt);
    t2_out = t2_out_vec(ind_opt);
    th1_out = th1_out_vec(ind_opt);
    th2_out = th2_out_vec(ind_opt);
    th3_out = th3_out_vec(ind_opt);
    plot_ROC (TPR_vec, FPR_vec, TNR_vec, PPV_vec, t2_out_vec,th1_out_vec,th2_out_vec,th3_out_vec);
    stats = [TPR,FPR,TNR,PPV];
    stats_vec = cat(2,TPR_vec,FPR_vec,TNR_vec,PPV_vec);
    thresholds = [t2_out,th1_out,th2_out,th3_out];
    save_outputs(stats,stats_vec,thresholds)
else
    fprintf(" No results under FPR_max found");
end
end
%% Save all grid search outputs
function save_outputs(stats,stats_vec,thresholds)
s.tpr = stats(1);
s.fpr = stats(2);
s.tnr = stats(3);
s.ppv = stats(4);

s_vec.tpr_vec = stats_vec(:,1);
s_vec.fpr_vec = stats_vec(:,2);
s_vec.tnr_vec = stats_vec(:,3);
s_vec.ppv_vec = stats_vec(:,4);

res.t2 = thresholds(1);
res.th1 = thresholds(2);
res.th2 = thresholds(3);
res.th3 = thresholds(4);
destdirectory = strcat("./results after grid search/",date);
if ~exist(destdirectory, 'dir')
    mkdir(destdirectory);
end
param_names = ["stats.mat","stats_vec.mat","thresholds.mat"];
struct_names = ["s","s_vec","res"];
for i =1:3
    fulldestination = fullfile(destdirectory, param_names(i));
    save(fulldestination,'-struct',struct_names(i));
end
end