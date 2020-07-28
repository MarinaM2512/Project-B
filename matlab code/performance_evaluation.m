function [TP ,FP, TN, FN] = performance_evaluation(algo_labels, real_labels)
% func calculates TP ,FP, TN, FN  in % by defnition to evaluate performance
% INPUT:
% 1. algo_labels - labels that our algorithem found
% 2. real_labels - accual labels based on prior info
% OUTPUT: in %
% 1. TP - both algo labels   & real labels is '1'
% 2. FP - algo labels == '1' & real labels == '0'
% 3. TN - both algo labels   & real labels is '0'
% 4. FN - algo labels == '0' & real labels == '1'
n1 = length(find(algo_labels)); %num of '1' in labels
n2 = length(find(real_labels));
tp = 0;
fp = 0;
tn = 0;
fn = 0;

for i = 1:length(algo_labels)
    if (algo_labels(i) == 1) && (real_labels(i) == 1)
        tp = tp+1;
    elseif (algo_labels(i) == 1) && (real_labels(i) == 0)
        fp = fp+1;
    elseif (algo_labels(i) == 0) && (real_labels(i) == 0)
        tn = tn+1;
    elseif (algo_labels(i) == 0) && (real_labels(i) == 1)
        fn = fn+1;
    end
end
%convert to %
TP = 100*tp/n1;
FP = 100*fp/n1;
TN = 100*tn/n2;
FN = 100*fn/n2;

end 
