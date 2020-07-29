function [TPR , FPR, TNR , PPV , AUC] = grid_search(real_t_vec,n,op,xcorr_data,times,th1_range,th2_range,t2_range)
% func finds optimal params using ROC-the optimal thresholdingvalues are
% for maximum Area Under the (ROC)Curve -AUC
% op = ['MinPeakHeight','Threshold'];
for p1 = 1:length(op)
    op1 = op(p1);
    for p2 = 1: 1:length(op)
        op2 = op(p2);
        for i1 = 1:length(th1_range)
            th1 = th1_range(i1);
            for i2 = 1:length(th2_range)
                th2 = th2_range(i2);
                for k = 1: length(t2_range)
                    t2 = t2_range(k);
                    [algo_labels,xcorr_out,diff,p] = tresholding_xcorr(xcorr_data,times,th1,op1,th2,op2,t2);
                    algo_t_vec = times(find(algo_labels));
%                     [TPR( , FPR, TNR , PPV ]= evaluation_rates(algo_t_vec, real_t_vec,template_len,n)
                end
            end
        end
    end
end
end

