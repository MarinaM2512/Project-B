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
%% Load saved templates
tmp = load("./templates/tap_template");
temp_tap = tmp.tap(:,:,1);
temp_tap_t = tmp.tap(:,:,2);
tmp = load("./templates/ank_template");
temp_ank = tmp.ank(:,:,1);
temp_ank_t = tmp.ank(:,:,2);
tmp = load("./templates/swl_template");
temp_swl = tmp.swl(:,:,1);
temp_swl_t = tmp.swl(:,:,2);
tmp = load("./templates/swr_template");
temp_swr = tmp.swr(:,:,1);
temp_swr_t = tmp.swr(:,:,2);
template_mat = cell(...
    [{temp_swl} {temp_swr} {temp_tap} {temp_ank}]);
%% Check and plot cross correlation
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
template_names = ["swipe left" , "swipe right" ,"tap", "side ankle"];
colors = ["r", "g","b","m"];
for i=1:length(list_moves)
    data_mat = loadMeasurmentMat("17_04",list_moves{i},1,"INIT"); %load one data mes
    time_vec = data_mat(:, end);
    gyro_mat = data_mat(:, 4:6);
    [corr_swl, corr_swr, corr_tap, corr_anc] = ...
                                    gyro_cross_corr(template_mat,gyro_mat,3);
    corr_mat = cat(4,corr_swl,corr_swr,corr_tap,corr_anc);
    figure;
    for j = 1:4
        curr_temp = template_mat{j};
        subplot(3,1,1);
        start_time = find(corr_mat(:,1,2,j)==-length(curr_temp));
        t_new = corr_mat(start_time:end,1,2,j);
        plot(t_new,corr_mat(start_time:end,1,1,j),colors(j));
        title("X");
        hold on;
        subplot(3,1,2);
        start_time = find(corr_mat(:,2,2,j)==-length(curr_temp));
        t_new = corr_mat(start_time:end,2,2,j);
        plot(t_new,corr_mat(start_time:end,2,1,j),colors(j));
        title("Y");
        hold on;
        subplot(3,1,3);
        start_time = find(corr_mat(:,3,2,j)==-length(curr_temp));
        t_new = corr_mat(start_time:end,3,2,j);
        plot(t_new,corr_mat(start_time:end,3,1,j),colors(j));
        title("Z");
        hold on;
    end
    legend("swipe left template","swipe right template","tap template","ankle template");
    newStr = strrep(list_moves{i},'_',' ');
    sgtitle(["correlation of " newStr " data" ]);
end
% % plot cross corr
% figure(1);
% subplot(3,1,1);
% t_new = corr_swl(:,1,2);
% plot(t_new,corr_swl(:,1,1));
% title("X");
% subplot(3,1,2);
% t_new = corr_swl(:,2,2);
% plot(t_new,corr_swl(:,2,1));
% title("Y");
% subplot(3,1,3);
% t_new = corr_swl(:,3,2);
% plot(t_new,corr_swl(:,3,1));
% title("Z");
% sgtitle("Swipe Left");
% figure(2);
% subplot(3,1,1);
% t_new = corr_swr(:,1,2);
% plot(t_new,corr_swr(:,1,1));
% title("X");
% subplot(3,1,2);
% t_new = corr_swr(:,2,2);
% plot(t_new,corr_swr(:,2,1));
% title("Y");
% subplot(3,1,3);
% t_new = corr_swr(:,3,2);
% plot(t_new,corr_swr(:,3,1));
% title("Z");
% sgtitle("Swipe right");
% figure(3);
% subplot(3,1,1);
% t_new = corr_tap(:,1,2);
% plot(t_new,corr_tap(:,1,1));
% title("X");
% subplot(3,1,2);
% t_new = corr_tap(:,2,2);
% plot(t_new,corr_tap(:,2,1));
% title("Y");
% subplot(3,1,3);
% t_new = corr_tap(:,3,2);
% plot(t_new,corr_tap(:,3,1));
% title("Z");
% sgtitle("tap");
% figure(4);
% subplot(3,1,1);
% t_new = corr_anc(:,1,2);
% plot(t_new,corr_anc(:,1,1));
% title("X");
% subplot(3,1,2);
% t_new = corr_anc(:,2,2);
% plot(t_new,corr_anc(:,2,1));
% title("Y");
% subplot(3,1,3);
% t_new = corr_anc(:,3,2);
% plot(t_new,corr_anc(:,3,1));
% title("Z");
% sgtitle("side ankle");
%% Calculate corelation with weighted template 
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr;

weightTap = temp_tap*vec_tap;
Tap = repmat(weightTap,1,4);
weightAnk = temp_ank*vec_ank;
Ank = repmat(weightAnk,1,4);
weightSwl = temp_swl*vec_swl;
Swl = repmat(weightSwl,1,4);
weightSwr = temp_swr*vec_swr;
Swr = repmat(weightSwr,1,4);
template_mat = cell(...
    [{Swl} {Swr} {Tap} {Ank} ]);
% calculate correlation om weighted_data
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
shift = 5 ; %index shift to corr
num_of_params = 4 ; % x,y,z
l = cellfun(@(x) size(x,1) ,template_mat , 'UniformOutput',false);
l = cell2mat(l);
corr = cell(length(list_moves),1);
for i = 1:length(list_moves) % run on mes
    data_mat = loadMeasurmentMat(date,list_moves{i},1,"INIT"); %load one data mes
    time_vec = data_mat(:, end);
    gyro_mat = data_mat(:, 4:6);
    weigthted_gyro = cat(2,gyro_mat*vec_swl,gyro_mat*vec_swr,gyro_mat*vec_tap,gyro_mat*vec_ank);
%     k = 1: shift: length(time_vec);
    ind = 1;
    % NEW: final length as gyro, same scale in time
    corr_swl = zeros( length(time_vec), num_of_params);
    corr_swr = zeros( length(time_vec), num_of_params);
    corr_tap = zeros( length(time_vec), num_of_params);
    corr_anc = zeros( length(time_vec), num_of_params);
    
    for k = 1: shift: (length(time_vec)-max(l)) %run on gyro mat

         [corr_swl(k,:), corr_swr(k,:), corr_tap(k,:), corr_anc(k,:)]...
                          = gyro_corr(template_mat,weigthted_gyro,k,l,num_of_params);
    end
    % corr1 is corr for one mes
    % dims: length(k) X num_of_params(3- x,y,z) X num_of_movments(4)
    corr1 = cat( 3, corr_swl, corr_swr,corr_tap,corr_anc);
    corr{i} = corr1;
end
%% plot weighted templates
figure;
subplot(2,2,1);
plot(1:length(weightAnk),weightAnk);
title("ankle template with anckle weights");
subplot(2,2,2);
plot(1:length(weightTap),weightTap);
title("tap template with tap weights");
subplot(2,2,3);
plot(1:length(weightSwl),weightSwl);
title("swipe left template with swipe left weights");
subplot(2,2,4);
plot(1:length(weightSwr),weightSwr);
title("swipe right template with swipe right weights");
figure;
subplot(2,2,1);

plot(1:length(weightSwl),temp_swl*vec_tap);
title("swl template with tap weights");
subplot(2,2,2);
plot(1:length(weightSwl),temp_swl*vec_swl);
title("swl template with swipe left weights");
subplot(2,2,3);
plot(1:length(weightSwl),temp_swl*vec_swr);
title("swl template template with swipe right weights");
subplot(2,2,4);
plot(1:length(weightSwl),temp_swl*vec_ank);
title("swl template template with ankle weights");

figure();
subplot(2,2,1);
plot(1:length(weightSwr),temp_swr*vec_tap);
title("swr template with tap weights");
subplot(2,2,2);
plot(1:length(weightSwr),temp_swr*vec_swl);
title("swr template with swl weights");
subplot(2,2,3);
plot(1:length(weightSwr),temp_swr*vec_swr);
title("swr template template with swipe left weights");
subplot(2,2,4);
plot(1:length(weightSwr),temp_swr*vec_ank);
title("swr template template with ankle weights");
%% Tap template weighted with different weights
figure();
subplot(2,2,1);
plot(1:length(weightTap),temp_tap*vec_tap,'Linewidth',2);
title("tap template with tap weights");
subplot(2,2,2);
plot(1:length(weightTap),temp_tap*vec_swl,'Linewidth',2);
title("tap template with swipe left weights");
subplot(2,2,3);
plot(1:length(weightTap),temp_tap*vec_swr,'Linewidth',2);
title("tap template template with swipe right weights");
subplot(2,2,4);
plot(1:length(weightTap),temp_tap*vec_ank,'Linewidth',2);
title("tap template template with ankle weights");

%% Plot test corelations 
name = ["anckle" , "swipe left", "swipe right", "tap"];
idx = [3 6 9 12];
for i=1:4
Corr = corr{idx(i)};
dataSwl = Corr(:,1,:);
dataSwr = Corr(:,2,:);
dataTap = Corr(:,3,:);
dataAnk = Corr(:,4,:);
figure;
subplot(2,2,1);
plot(1:length(dataTap),dataTap(:,:,3));
title("Tap template");
subplot(2,2,2);
plot(1:length(dataTap),dataTap(:,:,4));
title("Ankle template");
subplot(2,2,3);
plot(1:length(dataTap),dataTap(:,:,1));
title("Swipe left template");
subplot(2,2,4);
plot(1:length(dataTap),dataTap(:,:,2));
title("Swipe right template");
sgtitle(strcat("Correlation of " ,name(i), " data weighted with tap weights"));

figure;
subplot(2,2,1);
plot(1:length(dataAnk),dataAnk(:,:,3));
title("Tap template");
subplot(2,2,2);
plot(1:length(dataAnk),dataAnk(:,:,4));
title("Ankle template");
subplot(2,2,3);
plot(1:length(dataAnk),dataAnk(:,:,1));
title("Swipe left template");
subplot(2,2,4);
plot(1:length(dataAnk),dataAnk(:,:,2));
title("Swipe right template");
sgtitle(strcat("Correlation of " ,name(i), " data weighted with ancle weights"));

figure;
subplot(2,2,1);
plot(1:length(dataSwl),dataSwl(:,:,3));
title("Tap template");
subplot(2,2,2);
plot(1:length(dataSwl),dataSwl(:,:,4));
title("Ankle template");
subplot(2,2,3);
plot(1:length(dataSwl),dataSwl(:,:,1));
title("Swipe left template");
subplot(2,2,4);
plot(1:length(dataSwl),dataSwl(:,:,2));
title("Swipe right template");
sgtitle(strcat("Correlation of " ,name(i), " data weighted with swipe left weights"));

figure;
subplot(2,2,1);
plot(1:length(dataSwr),dataSwr(:,:,3));
title("Tap template");
subplot(2,2,2);
plot(1:length(dataSwr),dataSwr(:,:,4));
title("Ankle template");
subplot(2,2,3);
plot(1:length(dataSwr),dataSwr(:,:,1));
title("Swipe left template");
subplot(2,2,4);
plot(1:length(dataSwr),dataSwr(:,:,2));
title("Swipe right template");
sgtitle(strcat("Correlation of " ,name(i), " data weighted with swipe right weights"));
end
%% Check weighted data
name = ["anckle" , "swipe left", "swipe right", "tap"];
idx = [3 6 9 12];
for i=1:4
data_mat = loadMeasurmentMat(date,list_moves{idx(i)},1,"INIT"); %load one data mes
gyro_mat = data_mat(:, 4:6);
t = data_mat(:,20);
weighted_mat = cat(2,gyro_mat*vec_tap,gyro_mat*vec_ank,gyro_mat*vec_swl,gyro_mat*vec_swr);
figure;
subplot(2,2,1)
plot(t,weighted_mat(:,1));
title(strcat(name(i)," data weighted with tap"));
subplot(2,2,2)
plot(t,weighted_mat(:,2));
title(strcat(name(i), " data weighted with ankle"));
subplot(2,2,3)
plot(t,weighted_mat(:,3));
title(strcat(name(i)," data weighted with swipe left"));
subplot(2,2,4)
plot(t,weighted_mat(:,4));
title(strcat(name(i),"data weighted with swipe right"));
end

%% cal corr new
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
shift = 5 ; %index shift to corr
corr = gyro_corr_all_data(date,template_mat,list_moves,shift);
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
%% Calculate weighed corelation for each movement
tmp = load("./templates/tap_template");
temp_tap = tmp.tap(:,:,1);
tmp = load("./templates/ank_template");
temp_ank = tmp.ank(:,:,1);
tmp = load("./templates/swl_template");
temp_swl = tmp.swl(:,:,1);
tmp = load("./templates/swr_template");
temp_swr = tmp.swr(:,:,1);

list_moves  = get_all_meas_names("17_04", "FILTERED_INIT", 1);
tmp = load("./templates/tap_principle_vec");
vec_tap = tmp.tap;
vec_tap = vec_tap.*(vec_tap>0);
vec_tap = vec_tap / sqrt(vec_tap' * vec_tap);  
tmp = load("./templates/ank_principle_vec");
vec_ank = tmp.ank;
vec_ank = vec_ank.*(vec_ank>0);
vec_ank = vec_ank / sqrt(vec_ank' * vec_ank);  
tmp = load("./templates/swl_principle_vec");
vec_swl = tmp.swl;
vec_swl = vec_swl.*(vec_swl>0);
vec_swl = vec_swl / sqrt(vec_swl' * vec_swl);  
tmp = load("./templates/swr_principle_vec");
vec_swr = tmp.swr;
vec_swr = vec_swr.*(vec_swr>0);
vec_swr = vec_swr / sqrt(vec_swr' * vec_swr);  
weighted_corr = cell(length(list_moves),1);
% length X wighted templtes X movements wights
for i = 1:length(list_moves)
   curr_meas = corr{i};
   weightTap = cat(2,curr_meas(:,:,1)*vec_tap,curr_meas(:,:,2)*vec_tap,...
       curr_meas(:,:,3)*vec_tap,curr_meas(:,:,4)*vec_tap);
   weightAnk = cat(2,curr_meas(:,:,1)*vec_ank,curr_meas(:,:,2)*vec_ank,...
       curr_meas(:,:,3)*vec_ank,curr_meas(:,:,4)*vec_ank);
   weightSwl = cat(2,curr_meas(:,:,1)*vec_swl,curr_meas(:,:,2)*vec_swl,...
       curr_meas(:,:,3)*vec_swl,curr_meas(:,:,4)*vec_swl);
   weightSwr = cat(2,curr_meas(:,:,1)*vec_swr,curr_meas(:,:,2)*vec_swr,...
       curr_meas(:,:,3)*vec_swr,curr_meas(:,:,4)*vec_swr);
   weighted_corr(i) = {cat(3,weightSwl,weightSwr,weightTap,weightAnk)};
end
%% Plot test corelations 
name = ["anckle" , "swipe left", "swipe right", "tap"];
idx = [3 6 9 12];
for i=1%:4
sideCorr = weighted_corr{idx(i)};
dataSwl = sideCorr(:,:,1);
dataSwr = sideCorr(:,:,2);
dataTap = sideCorr(:,:,3);
dataAnk = sideCorr(:,:,4);

figure;
subplot(2,2,1);
plot(1:length(dataTap),dataTap(:,1));
title("swl template");
subplot(2,2,2);
plot(1:length(dataTap),dataTap(:,2));
title("swr template");
subplot(2,2,3);
plot(1:length(dataTap),dataTap(:,3));
title("tap template");
subplot(2,2,4);
plot(1:length(dataTap),dataTap(:,4));
title("ank template");
sgtitle(strcat("Correlation of " , name(i) , " data weighted with tap weights"));

figure;
subplot(2,2,1);
plot(1:length(dataAnk),dataAnk(:,1));
title("swl template");
subplot(2,2,2);
plot(1:length(dataAnk),dataAnk(:,2));
title("swr template");
subplot(2,2,3);
plot(1:length(dataAnk),dataAnk(:,3));
title("tap template");
subplot(2,2,4);
plot(1:length(dataAnk),dataAnk(:,4));
title("ank template");
sgtitle(strcat("Correlation of " , name(i) , " data weighted with ancle weights"));

figure;
subplot(2,2,1);
plot(1:length(dataSwl),dataSwl(:,1));
title("swl template");
subplot(2,2,2);
plot(1:length(dataSwl),dataSwl(:,2));
title("swr template");
subplot(2,2,3);
plot(1:length(dataSwl),dataSwl(:,3));
title("tap template");
subplot(2,2,4);
plot(1:length(dataSwl),dataSwl(:,4));
title("ank template");
sgtitle(strcat("Correlation of " , name(i) , " data weighted with swipe left weights"));

figure;
subplot(2,2,1);
plot(1:length(dataSwr),dataSwr(:,1));
title("swl template");
subplot(2,2,2);
plot(1:length(dataSwr),dataSwr(:,2));
title("swr template");
subplot(2,2,3);
plot(1:length(dataSwr),dataSwr(:,3));
title("tap template");
subplot(2,2,4);
plot(1:length(dataSwr),dataSwr(:,4));
title("ank template");
sgtitle(strcat("Correlation of " , name(i) , " data weighted with swipe right weights"));
end


%%
name = ["swipe left", "swipe right", "tap","ankel"];
color = [ 'r','b','g','m'];
op = 'MinPeakHeight';
th = 0.75;
% for d = [ dataSwl dataSwr dataTap dataAnk]
for k = 1:4
   d = sideCorr(:,:,k);
   figure();
   hold on;
   for i = 1:4
        [corr_out,diff1,p] = tresholding_and_normlise_corr(d(:,i),th,op);
        plot(1:length(d),corr_out,color(i));
   end 
    title([name(k)," weight"]);
    legend(name);
end
%%
name = ["swipe left", "swipe right", "tap","ankel"];
color = [ 'r','b','g','m'];
op = 'MinPeakHeight';
th = 0.75;
figure();
for k = 1:4
   d = sideCorr(:,:,k);
   for i = 1:4
        [corr_out,diff1,p] = tresholding_and_normlise_corr(d(:,i),th,op);
        subplot(2,2,i);
        plot(1:length(d),corr_out,color(k));
        hold on;
        title([name(i)," template"]);
   end 
   
end
legend(name);
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
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    subplot(3,1,2);
    plot(t{2},y);
    title("Y");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    subplot(3,1,3);
    plot(t{3},z);
    title("Z");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    sgtitle(move_name);
end
