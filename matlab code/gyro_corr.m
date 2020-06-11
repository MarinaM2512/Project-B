function [corr_swl, corr_swr, corr_tap, corr_anc] = ...
                                gyro_corr(template_mat,gyro_mat,start,lengths)
% function get 1 X 3 corr vector for each template and data
% scalar to each axis.
% lengths- tenplates len
num_of_params = 3 ; % x,y,z
corr_swl = zeros(1,num_of_params);
corr_swr = zeros(1,num_of_params);
corr_tap = zeros(1,num_of_params);
corr_anc = zeros(1,num_of_params);

% corr 2 vectors get scalar
for i=1:num_of_params %for each x,y,z
    tempSL = template_mat{1};
    tempSR = template_mat{2};
    tempTap = template_mat{3};
    tempAnc = template_mat{4};
    corr_swl(i) = corr( tempSL(:,i), gyro_mat(start:start-1+lengths(1),i));
    corr_swr(i) = corr( tempSR(:,i), gyro_mat(start:start-1+lengths(2),i));
    corr_tap(i) = corr( tempTap(:,i), gyro_mat(start:start-1+lengths(3),i));
    corr_anc(i) = corr( tempAnc(:,i), gyro_mat(start:start-1+lengths(4),i));
end
end
