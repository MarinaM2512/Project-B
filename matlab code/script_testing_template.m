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
[tmplt_swl_gyro,tmplt_swl_t] = pad_data_to_same_size(...
                   tmplt_swl_gyrox, tmplt_swl_gyroy, tmplt_swl_gyroz,...
                   tmplt_swl_tx,tmplt_swl_ty,tmplt_swl_tz,0.6,2/3);


% swipe R templates
[tmplt_swr_gyrox, tmplt_swr_tx] = make_tamplate_all_movments_x(date,swr_names,10000,500,10,7,0.1);
[tmplt_swr_gyroy, tmplt_swr_ty] = make_tamplate_all_movments_y(date,swr_names,10000,500,10,6,0.1);
[tmplt_swr_gyroz, tmplt_swr_tz] = make_tamplate_all_movments_z(date,swr_names,10000,500,10,9,0.1);
[tmplt_swr_gyro ,tmplt_swr_t]  = pad_data_to_same_size(...
                   tmplt_swr_gyrox, tmplt_swr_gyroy, tmplt_swr_gyroz,...
                   tmplt_swr_tx,tmplt_swr_ty,tmplt_swr_tz,0.6,2/3);

% tap templates
[tmplt_tap_gyrox, tmplt_tap_tx] = make_tamplate_all_movments_x(date,tap_names,10000,500,10,5,0.02);
[tmplt_tap_gyroy, tmplt_tap_ty] = make_tamplate_all_movments_y(date,tap_names,10000,500,10,6,0.1);
[tmplt_tap_gyroz, tmplt_tap_tz] = make_tamplate_all_movments_z(date,tap_names,10000,500,10,9,0.1);
[tmplt_tap_gyro,tmplt_tap_t] = pad_data_to_same_size(...
                   tmplt_tap_gyrox, tmplt_tap_gyroy, tmplt_tap_gyroz,...
                   tmplt_tap_tx,tmplt_tap_ty,tmplt_tap_tz,0.3,4/5);



% side anckle templates
[tmplt_anc_gyrox, tmplt_sancl_tx] = make_tamplate_all_movments_x(date,anc_names,10000,500,10,7,0.1);
[tmplt_anc_gyroy, tmplt_sancl_ty] = make_tamplate_all_movments_y(date,anc_names,10000,500,10,6,0.1);
[tmplt_anc_gyroz, tmplt_sancl_tz] = make_tamplate_all_movments_z(date,anc_names,10000,500,10,9,0.1);
[tmplt_anc_gyro,tmplt_anc_t] = pad_data_to_same_size(...
                    tmplt_anc_gyrox, tmplt_anc_gyroy, tmplt_anc_gyroz,...
                    tmplt_sancl_tx,tmplt_sancl_ty,tmplt_sancl_tz,0.7,2/3);


% put all templates in matrix
% dims: template_len X num_of_params(3- x,y,z) X num_of_movments(4)
template_mat = cell(...
    [{tmplt_swl_gyro} {tmplt_swr_gyro} {tmplt_tap_gyro} {tmplt_anc_gyro}]);
%% Print and save templates
t_tap = [{tmplt_tap_t(:,1)} {tmplt_tap_t(:,2)} {tmplt_tap_t(:,3)}];
t_anc = [{tmplt_anc_t(:,1)} {tmplt_anc_t(:,2)} {tmplt_anc_t(:,3)}];
t_sl = [{tmplt_swl_t(:,1)} {tmplt_swl_t(:,2)} {tmplt_swl_t(:,3)}];
t_sr = [{tmplt_swr_t(:,1)} {tmplt_swr_t(:,2)} {tmplt_swr_t(:,3)}];
print_templates(tmplt_anc_gyro(:,1),tmplt_anc_gyro(:,2),tmplt_anc_gyro(:,3),t_anc,"ancle");
print_templates(tmplt_tap_gyro(:,1),tmplt_tap_gyro(:,2),tmplt_tap_gyro(:,3),t_tap,"tap");
print_templates(tmplt_swl_gyro(:,1),tmplt_swl_gyro(:,2),tmplt_swl_gyro(:,3),t_sl,"swipe left");
print_templates(tmplt_swr_gyro(:,1),tmplt_swr_gyro(:,2),tmplt_swr_gyro(:,3),t_sr,"swipe right");
swl = cat(3,tmplt_swl_gyro,tmplt_swl_t);
swr = cat(3,tmplt_swr_gyro,tmplt_swr_t);
tap = cat(3,tmplt_tap_gyro,tmplt_tap_t);
ank = cat(3,tmplt_anc_gyro,tmplt_anc_t);
name = ["swl" "swr" "tap" "ank"];
for i = 1:4
    mat_name=strcat(".\templates\",name(i),"_template",".mat");
    save(mat_name,name(i));
end

%% cal corr new
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
%     k = 1: shift: length(time_vec);
    ind = 1;
    % NEW: final length as gyro, same scale in time
    corr_swl = zeros( length(time_vec), num_of_params);
    corr_swr = zeros( length(time_vec), num_of_params);
    corr_tap = zeros( length(time_vec), num_of_params);
    corr_anc = zeros( length(time_vec), num_of_params);
    
    for k = 1: shift: (length(time_vec)-max(l)) %run on gyro mat

         [corr_swl(k,:), corr_swr(k,:), corr_tap(k,:), corr_anc(k,:)]...
                          = gyro_corr(template_mat,gyro_mat,k,l);
    end
    % corr1 is corr for one mes
    % dims: length(k) X num_of_params(3- x,y,z) X num_of_movments(4)
    corr1 = cat( 3, corr_swl, corr_swr, corr_tap, corr_anc);
    corr{i} = corr1;
end
%% Calculate corelation with weighted template - To be contionued
tmp = load("./templates/tap_template");
temp_tap = tmp.tap(:,:,1);
tmp = load("./templates/ank_template");
temp_ank = tmp.ank(:,:,1);
tmp = load("./templates/swl_template");
temp_swl = tmp.swl(:,:,1);
tmp = load("./templates/swr_template");
temp_swr = tmp.swr(:,:,1);
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr;

weightTap = temp_tap(:,1)*vec_tap;


%% plot correlation with data to check when they correspond 
i=1;
data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
curr_meas = corr{i};
corrSL = curr_meas(:,3,1);  %z
corrSR = curr_meas(:,3,2);  %z
corrTap = curr_meas(:,1,3); %x
corrAnc = curr_meas(:,2,4); %y
t = data_mat(:,20);
t_new = t(1:length(corrSL));
   % plot gyro with corr to check when is the maximun correlation
    gyro_mat = data_mat(:, 4:6);
    max1=max(gyro_mat(:,3));
    %
figure(1);
plot(t_new,corrSL);
    % plot normlized gyro
    hold on;
    plot(t_new,gyro_mat(:,3)/max1);
legend("corr","gyro");
xlim([5e4 8e4]);
xlabel("t");
ylabel("normlized amp");
%% Calculate weighed corelation foe each movement
%% plot correlation results for all meas
for i = 1:length(list_moves)
   data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT");
   curr_meas = corr{i};
   corrSL = curr_meas(:,3,1);  %z
   corrSR = curr_meas(:,3,2);  %z
   corrTap = curr_meas(:,1,3); %x
   corrAnc = curr_meas(:,2,4); %y
   t = data_mat(:,20);
   t_new = t(1:length(corrSL));
   % plot all corr
   figure(i+1);
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
function [padedX,padedT]  = pad_data_to_same_size(x,y,z,tx,ty,tz,thresh,fraction_last)
% function make all parames be in same length
% thresh is the thereshold on the diff so that the last insignificant part
%        of the template would be reduced
%fraction_last - how much of the  the signal to cosider significant
trunckG = [{x} {y} {z}];
trunckT = [{tx} {ty} {tz}];
for i =1:3
    curr = trunckG{i};
    tmp = curr(floor(length(curr)*fraction_last):end);
    curr = curr(1:(length(curr)-length(tmp)));
    ind = find(diff(tmp)<thresh);
    tmp = tmp(1:ind(1)+1);
    curr(length(curr)+1:length(curr)+length(tmp)) = tmp;
    trunckG{i} = curr;
    t = trunckT{i};
    t=t(1:length(curr));
    trunckT{i} = t;
end
[x1 ,y1, z1] = trunckG{1:3};
[tx1,ty1,tz1] = trunckT{1:3};
len_x = length( x1);
len_y = length( y1);
len_z = length( z1);
max_len= max([len_x,len_y,len_z]);
x2 = padarray(x1,max_len-len_x,x1(end),'post');
y2 = padarray(y1,max_len-len_y,y1(end),'post');
z2 = padarray(z1,max_len-len_z,z1(end),'post');
tx2 = padarray(tx1, max_len-len_x,tx1(end),'post');
ty2 = padarray(ty1,max_len-len_y,ty1(end),'post');
tz2=  padarray(tz1,max_len-len_z,tz1(end),'post');

padedX = [x2 y2 z2];
padedT = [tx2 ty2 tz2];

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
