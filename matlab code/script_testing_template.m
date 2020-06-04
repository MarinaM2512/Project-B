%% list of names for all movments
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
    swl_names = names_of_move( list_moves, "swipe_L");
    swr_names = names_of_move(list_moves, "swipe_R");
    tap_names = names_of_move( list_moves, "tap");
    anc_names =names_of_move(list_moves, "side_ancle");

%% templates for all moveents:

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
[tmplt_tap_gyrox, tmplt_tap_tx] = make_tamplate_all_movments_x(date,tap_names,10000,200,10,6,0.1);
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
template_mat = cell(...
    [{tmplt_swl_gyro} {tmplt_swr_gyro} {tmplt_tap_gyro} {tmplt_anc_gyro}]);
%%
t_tap = [{tmplt_tap_tx} {tmplt_tap_ty} {tmplt_tap_tz}];
t_anc = [{tmplt_sancl_tx} {tmplt_sancl_ty} {tmplt_sancl_tz}];
t_sl = [{tmplt_swl_tx} {tmplt_swl_ty} {tmplt_swl_tz}];
t_sr = [{tmplt_swr_tx} {tmplt_swr_ty} {tmplt_swr_tz}];
print_templates(tmplt_anc_gyrox,tmplt_anc_gyroy,tmplt_anc_gyroz,t_anc,"ancle");
print_templates(tmplt_tap_gyrox,tmplt_tap_gyroy,tmplt_tap_gyroz,t_tap,"tap");
print_templates(tmplt_swl_gyrox,tmplt_swl_gyroy,tmplt_swl_gyroz,t_sl,"swipe left");
print_templates(tmplt_swr_gyrox,tmplt_swr_gyroy,tmplt_swr_gyroz,t_sr,"swipe right");
%%
txt = ["x","y","z"];
shift = 5 ; %index shift to corr
num_of_params = 3 ; % x,y,z
l = cellfun(@(x) size(x,1) ,template_mat , 'UniformOutput',false);
l = cell2mat(l);
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
    for k = 1: shift: (length(time_vec)-max(l)) %run on gyro mat
%        [corr_swl(ind,:), corr_swr(ind,:), corr_tap(ind,:), corr_anc(ind,:)]...
%                         = gyro_corr(template_mat,gyro_mat(k:k-1+l,:));
         [corr_swl(ind,:), corr_swr(ind,:), corr_tap(ind,:), corr_anc(ind,:)]...
                          = gyro_corr(template_mat,gyro_mat,k,l);
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
%% plor correlation results for all meas
for i = 1:length(list_moves)
   data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
   curr_meas = corr{i};
   corrSL = curr_meas(:,3,1);
   corrSR = curr_meas(:,3,2);
   corrTap = curr_meas(:,1,3);
   corrAnc = curr_meas(:,2,4);
   t = data_mat(:,20);
   t_new = t(1:length(corrSL));
   figure(i);
   subplot(2,2,1);
   plot(t_new,corrSL);
   title("Swipe Left");
   subplot(2,2,2);
   plot(t_new,corrSR);
   title("Swipe Right");
   subplot(2,2,3);
   plot(t_new,corrTap);
   title("Tap");
   subplot(2,2,4);
   plot(t_new,corrAnc);
   title("Ancle");
   newStr = strrep(list_moves(i),'_',' ');
   sgtitle(newStr);
end
%% Not finished yet
%For each measurment find the peaks of the corelation with template at the 
%prime axis. corelation responces order : SL -Z , SR - Z, Tap - X ,Ancle -
%Y
corr_peaks = cell(length(list_moves),1);
for i = 1:length(list_moves)
   curr_meas = corr{i};
   [peaksSL,locsSL] = findpeaks(curr_meas(:,3,1));
   [peaksSR,locsSR] = findpeaks(curr_meas(:,3,2));
   [peaksTap,locsTap] = findpeaks(curr_meas(:,1,3));
   [peaksAnc,locsAnc] = findpeaks(curr_meas(:,2,4));
   peaks = cat(2,peaksSL,peaksSR,peaksTap,peaksAnc);
   locs = cat(2,locsSL,locsSR,locsTap,locsAnc);
   corr_peaks{i} = cat(3,peaks,locs);
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
                                gyro_corr(template_mat,gyro_mat,start,lengths)
% function get 1 X 3 corr vector for each template and data
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

function list = names_of_move(list_moves,move)
    sit_moves_idx = cellfun(@(x) ~contains(x,"stand"),list_moves,'UniformOutput',false);
    moves = list_moves(cell2mat(sit_moves_idx));
    pos_move = strfind( moves, move);
    idx = cellfun(@(x) length(x)>0,pos_move,'UniformOutput',false);
    idx = cell2mat(idx);
    list = moves(find(idx));
end

function print_templates(x,y,z,t,move_name)
    figure;
    subplot(3,1,1);
    plot(t{1},x);
    title("X");
    subplot(3,1,2);
    plot(t{2},y);
    title("Y");
    subplot(3,1,3);
    plot(t{3},z);
    title("Z");
    sgtitle(move_name);
end
