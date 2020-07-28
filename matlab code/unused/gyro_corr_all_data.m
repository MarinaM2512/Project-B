function corr = gyro_corr_all_data (date,template_mat,list_moves,shift)
%index shift to corr
num_of_params = 3 ; % x,y,z
l = cellfun(@(x) size(x,1) ,template_mat , 'UniformOutput',false);
l = cell2mat(l);
corr = cell(length(list_moves),1);
for i = 1:length(list_moves) % run on mes
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT"); %load one data mes
    time_vec = data_mat(:, end);
    gyro_mat = data_mat(:, 4:6);
    % final length as gyro, same scale in time
    corr_swl = zeros( length(time_vec), num_of_params);
    corr_swr = zeros( length(time_vec), num_of_params);
    corr_tap = zeros( length(time_vec), num_of_params);
    corr_anc = zeros( length(time_vec), num_of_params);
    
    for k = 1: shift: (length(time_vec)-max(l)) %run on gyro mat

         [corr_swl(k,:), corr_swr(k,:), corr_tap(k,:), corr_anc(k,:)]...
                          = gyro_corr(template_mat,gyro_mat,k,l,num_of_params);
    end
    % corr1 is corr for one mes
    % dims: length(k) X num_of_params(3- x,y,z) X num_of_movments(4)
    corr1 = cat( 3, corr_swl, corr_swr, corr_tap, corr_anc);
    corr{i} = corr1;
end
end
