%% listof manes to all movments
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
    swl_names = list_moves( cell2mat( strfind( list_moves, "swipe_L"   )));
    swr_names = list_moves( cell2mat( strfind( list_moves, "swipe_R"   )));
    tap_names = list_moves( cell2mat( strfind( list_moves, "tap"       )));
    anc_names = list_moves( cell2mat( strfind( list_moves, "side_ancle")));

%% templates to all moveents:

% swipe L templates
[tmplt_swl_gyrox, tmplt_swl_tx] = make_tamplate_all_movments_x(date,swl_names,10000,500,10,7,0.1);
[tmplt_swl_gyroy, tmplt_swl_ty] = make_tamplate_all_movments_y(date,swl_names,10000,500,10,6,0.1);
[tmplt_swl_gyroz, tmplt_swl_tz] = make_tamplate_all_movments_z(date,swl_names,10000,500,10,9,0.1);
tmplt_swl_gyro = pad_data_to_same_size(...
                   tmplt_swl_gyrox, tmplt_swl_gyroy, tmplt_swl_gyroz);

% swipe R templates
[tmplt_swr_gyrox, tmplt_swr_tx] = make_tamplate_all_movments_x(date,swr_names,10000,500,10,7,0.1);
[tmplt_swr_gyroy, tmplt_swr_ty] = make_tamplate_all_movments_y(date,swr_names,10000,500,10,6,0.1);
[tmplt_swr_gyroz, tmplt_swr_tz] = make_tamplate_all_movments_z(date,swr_names,10000,500,10,9,0.1);
tmplt_swr_gyro = pad_data_to_same_size(...
                   tmplt_swr_gyrox, tmplt_swr_gyroy, tmplt_swr_gyroz);

% tap templates
[tmplt_tap_gyrox, tmplt_tap_tx] = make_tamplate_all_movments_x(date,tap_names,10000,500,10,7,0.1);
[tmplt_tap_gyroy, tmplt_tap_ty] = make_tamplate_all_movments_y(date,tap_names,10000,500,10,6,0.1);
[tmplt_tap_gyroz, tmplt_tap_tz] = make_tamplate_all_movments_z(date,tap_names,10000,500,10,9,0.1);
tmplt_tap_gyro = pad_data_to_same_size(...
                   tmplt_tap_gyrox, tmplt_tap_gyroy, tmplt_tap_gyroz);

% side anckle templates
[tmplt_anc_gyrox, tmplt_sancl_tx] = make_tamplate_all_movments_x(date,anc_names,10000,500,10,7,0.1);
[tmplt_anc_gyroy, tmplt_sancl_ty] = make_tamplate_all_movments_y(date,anc_names,10000,500,10,6,0.1);
[tmplt_anc_gyroz, tmplt_sancl_tz] = make_tamplate_all_movments_z(date,anc_names,10000,500,10,9,0.1);
tmplt_anc_gyro = pad_data_to_same_size(...
                    tmplt_anc_gyrox, tmplt_anc_gyroy, tmplt_anc_gyroz);
% put all templates in matrix
% dims: template_len X num_of_params(3- x,y,z) X num_of_movments(4)
template_mat = cat(3, ...
    tmplt_swl_gyro, tmplt_swl_gyro, tmplt_tap_gyro, tmplt_anc_gyro);
%%
txt = ["x","y","z"];
shift = 5 ; %index shift to corr
num_of_params = 3 ; % x,y,z
l = size(template_mat,1);
corr = cell(length(list_moves),1);
for i = 1:length(list_moves) % run on mes
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT"); %load one data mes
    time_vec = data_mat(:, end);
    gyro_mat = data_mat(:, 4:6);
    k = 1: shift: length(time_vec);
    ind = 1;
    corr_swl = zeros( length(k), num_of_params);
    corr_swr = zeros( length(k), num_of_params);
    corr_tap = zeros( length(k), num_of_params);
    corr_anc = zeros( length(k), num_of_params);
%     h= figure;
%     axis tight manual
%     filename = 'testAnimated.gif';
    for k = 1: shift: length(time_vec) %run on gyro mat
       [corr_swl(ind,:), corr_swr(ind,:), corr_tap(ind,:), corr_anc(ind,:)]...
                        = gyro_corr(template_mat,gyro_mat(k:k-1+l,:));
        ind = ind+1;
%         for s=1:3
%             subplot(3,1,s);
%             plot(time_vec(k:k-1+l),template_mat(:,s,1),'r');
%             hold on;
%             plot(time_vec(k:k-1+l),gyro_mat(k:k-1+l,s));
%             title(['swipe L for gyro ',txt(s)]);
%         end
%         drawnow
%               % Capture the plot as an image 
%       frame = getframe(h); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
% 
%       % Write to the GIF File 
%       if k == 1 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
    end
    % corr1 is corr for one mes
    % dims: length(k) X num_of_params(3- x,y,z) X num_of_movments(4)
    corr1 = cat( 3, corr_swl, corr_swr, corr_tap, corr_anc);
    corr{i} = corr1;
end
%%
function paded = pad_data_to_same_size(x,y,z)
% function make all parames be in same length
len_x = length(x);
len_y = length(y);
len_z = length(z);
max_len= max([len_x,len_y,len_z]);
x1 = padarray(x,max_len-len_x,0,'post');
y1 = padarray(y,max_len-len_y,0,'post');
z1 = padarray(z,max_len-len_z,0,'post');
paded = [x1 y1 z1];

end
%%
function [corr_swl, corr_swr, corr_tap, corr_anc] = ...
                                gyro_corr(template_mat,gyro_mat)
% function get 1 X 3 corr vector for each template and data
num_of_params = 3 ; % x,y,z
corr_swl = zeros(1,num_of_params);
corr_swr = zeros(1,num_of_params);
corr_tap = zeros(1,num_of_params);
corr_anc = zeros(1,num_of_params);

% corr 2 vectors get scalar
for i=1:num_of_params %for each x,y,z
corr_swl(i) = corr( template_mat(:,i,1), gyro_mat(:, i));
corr_swr(i) = corr( template_mat(:,i,2), gyro_mat(:, i));
corr_tap(i) = corr( template_mat(:,i,3), gyro_mat(:, i));
corr_anc(i) = corr( template_mat(:,i,4), gyro_mat(:, i));
end
end
