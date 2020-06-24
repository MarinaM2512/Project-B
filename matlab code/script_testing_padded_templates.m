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
template_mat1 = cell(...
    [{tmplt_swl_gyro} {tmplt_swr_gyro} {tmplt_tap_gyro} {tmplt_anc_gyro}]);

d_sl = [{tmplt_swl_gyro(:,1)} {tmplt_swl_gyro(:,2)} {tmplt_swl_gyro(:,3)}];
d_sr = [{tmplt_swr_gyro(:,1)} {tmplt_swr_gyro(:,2)} {tmplt_swr_gyro(:,3)}];
d_tap = [{tmplt_tap_gyro(:,1)} {tmplt_tap_gyro(:,2)} {tmplt_tap_gyro(:,3)}];
d_anc = [{tmplt_anc_gyro(:,1)} {tmplt_anc_gyro(:,2)} {tmplt_anc_gyro(:,3)}];

t_sl = [{tmplt_swl_t(:,1)} {tmplt_swl_t(:,2)} {tmplt_swl_t(:,3)}];
t_sr = [{tmplt_swr_t(:,1)} {tmplt_swr_t(:,2)} {tmplt_swr_t(:,3)}];
t_tap = [{tmplt_tap_t(:,1)} {tmplt_tap_t(:,2)} {tmplt_tap_t(:,3)}];
t_anc = [{tmplt_anc_t(:,1)} {tmplt_anc_t(:,2)} {tmplt_anc_t(:,3)}];

%%
template_mat = loadTemplateMatAndPad;
d_sl_p = template_mat{1}(:,:,1);
d_sr_p = template_mat{2}(:,:,1);
d_tap_p = template_mat{3}(:,:,1);
d_anc_p = template_mat{4}(:,:,1);

t_sl_p = template_mat{1}(:,:,2);
t_sr_p = template_mat{2}(:,:,2);
t_tap_p = template_mat{3}(:,:,2);
t_anc_p = template_mat{4}(:,:,2);

%%
close all;
print_templates_and_paded(d_sl,t_sl,d_sl_p,t_sl_p,"Swipe Left");
print_templates_and_paded(d_sr,t_sr,d_sr_p,t_sr_p,"Swipe Right");
print_templates_and_paded(d_tap,t_tap,d_tap_p,t_tap_p,"Tap");
print_templates_and_paded(d_anc,t_anc,d_anc_p,t_anc_p,"Side Ankle");

%% print_paded_and_templates
print_paded_and_templates(d_sl,t_sl,d_sl_p,t_sl_p,"Swipe Left");
print_paded_and_templates(d_sr,t_sr,d_sr_p,t_sr_p,"Swipe Right");
print_paded_and_templates(d_tap,t_tap,d_tap_p,t_tap_p,"Tap");
print_paded_and_templates(d_anc,t_anc,d_anc_p,t_anc_p,"Side Ankle");
%%

function print_templates_and_paded(d,t,d_p,t_p,move_name)
    figure;
    %x
    subplot(3,1,1);
    plot(t{1},d{1},'r');
    hold on;
    plot(t_p(:,1),d_p(:,1),'b--');
    title("X");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    %y
    subplot(3,1,2);
    plot(t{2},d{2},'r');
    hold on;
    plot(t_p(:,2),d_p(:,2),'b--');
    title("Y");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    %z
    subplot(3,1,3);
    plot(t{3},d{3},'r');
    hold on;
    plot(t_p(:,3),d_p(:,3),'b--');
    title("Z");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    sgtitle(move_name);
    legend("regular","padded");
end
%% same as prev but plot padded befor template
function print_paded_and_templates(d,t,d_p,t_p,move_name)
    figure;
    %x
    subplot(3,1,1);
    plot(t_p(:,1),d_p(:,1),'b');
    hold on;
    plot(t{1},d{1},'r--');
    title("X");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    %y
    subplot(3,1,2);
    plot(t_p(:,2),d_p(:,2),'b');
    hold on;
    plot(t{2},d{2},'r--');
    title("Y");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    %z
    subplot(3,1,3);
    plot(t_p(:,3),d_p(:,3),'b');
    hold on;
    plot(t{3},d{3},'r--');
    title("Z");
    xlabel("time [msec]");
    ylabel("\omega [rad/sec]");
    sgtitle(move_name);
    legend("padded","regular");
end