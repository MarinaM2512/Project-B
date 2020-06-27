%% NEED TO ADD not_a_movement_class
function confusion_matrix  = stats ( algo_labels, real_labels)
% confusion_matrix(i,j)- the real label is  j and i was detected
% in present
% is_eq = cellfun(@isequal,algo_labels,real_labels);
z = cell(size(real_labels)); 
swl_labels = cellfun(@(x) [ 1 0 0 0 ],z,'UniformOutput',false);
swr_labels = cellfun(@(x) [ 0 1 0 0 ],z,'UniformOutput',false);
tap_labels = cellfun(@(x) [ 0 0 1 0 ],z,'UniformOutput',false);
anc_labels = cellfun(@(x) [ 0 0 0 1 ],z,'UniformOutput',false);

real_is_swl = cellfun(@isequal,swl_labels,real_labels);
real_is_swr = cellfun(@isequal,swr_labels,real_labels);
real_is_tap = cellfun(@isequal,tap_labels,real_labels);
real_is_anc = cellfun(@isequal,anc_labels,real_labels);
real_is_eq = cat(2,real_is_swl,real_is_swr,real_is_tap,real_is_anc);


algo_is_swl = cellfun(@isequal,swl_labels,algo_labels);
algo_is_swr = cellfun(@isequal,swr_labels,algo_labels);
algo_is_tap = cellfun(@isequal,tap_labels,algo_labels);
algo_is_anc = cellfun(@isequal,anc_labels,algo_labels);
algo_is_eq = cat(2,algo_is_swl,algo_is_swr,algo_is_tap,algo_is_anc);

confusion_matrix = zeros(4);
for i=1:4
    for j=1:4
        a = arrayfun(@and, algo_is_eq(:,i), real_is_eq(:,j));
        confusion_matrix(i,j) = sum(a)/sum (real_is_eq(:,j));
    end
end
confusion_matrix = 100* confusion_matrix;

end

%% helper func

