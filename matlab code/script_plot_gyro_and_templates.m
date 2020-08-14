%clc;clear all;close all;
%% load saved templates
tmp = load("./templates/swl_template");
temp_swl = tmp.swl(:,:,1);
temp_swl_t = tmp.swl(:,:,2);
tmp = load("./templates/swr_template");
temp_swr = tmp.swr(:,:,1);
temp_swr_t = tmp.swr(:,:,2);
tmp = load("./templates/tap_template");
temp_tap = tmp.tap(:,:,1);
temp_tap_t = tmp.tap(:,:,2);
tmp = load("./templates/ank_template");
temp_ank = tmp.ank(:,:,1);
temp_ank_t = tmp.ank(:,:,2);

template_mat = cell(...
    [{temp_swl} {temp_swr} {temp_tap} {temp_ank}]);
t_sl = [{temp_swl_t(:,1)} {temp_swl_t(:,2)} {temp_swl_t(:,3)}];
t_sr = [{temp_swr_t(:,1)} {temp_swr_t(:,2)} {temp_swr_t(:,3)}];
t_tap = [{temp_tap_t(:,1)} {temp_tap_t(:,2)} {temp_tap_t(:,3)}];
t_anc = [{temp_ank_t(:,1)} {temp_ank_t(:,2)} {temp_ank_t(:,3)}];

%% plot
names =["swipe left", "swipe right","tap","ancle"];
print_templates(temp_swl(:,1),temp_swl(:,2),temp_swl(:,3),t_sl,names(1));
print_gyro(t_sl,names(1));

print_templates(temp_swr(:,1),temp_swr(:,2),temp_swr(:,3),t_sr,names(2));
print_gyro(t_sr,names(2));

print_templates(temp_tap(:,1),temp_tap(:,2),temp_tap(:,3),t_tap,names(3));
print_gyro(t_tap,names(3));

print_templates(temp_ank(:,1),temp_ank(:,2),temp_ank(:,3),t_anc,names(4));
print_gyro(t_anc,names(4));

%%
function print_gyro(t_cell,name)
% function plots gyro Vs time for one ramdom  movement in x,y,z
% INPUTS: 
% 1. t_cell- time vec of templates to plot gyro in relation to it
% type 1X3 cell,each cell is time vec in same length as the movement template
% 2. name- name of movement to plot one of the following:"swipe left", "swipe right","tap","ancle"

list_names =["swipe left", "swipe right","tap","ancle"]; % needs to include string same as name 

%load gyro data
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
% choose movement to plot
chosen_meas_names = [ 6,10,12,5]; % randomly chosen from sit only, order according to list_names
chosen_window_num = 4; % random

thresholds = [500,7,7];
i = find (name ==list_names);
meas_name = list_moves{chosen_meas_names(i)};
% find all movements in the meas- chosen_meas_names
[to_avgX, to_avgY, to_avgZ] = join_measurments_of_movements(date,meas_name,10000,...
    thresholds(1),thresholds(2),thresholds(3));
% chose one movement from all
gyro_window_x = to_avgX(:,chosen_window_num,1);
gyro_window_y = to_avgY(:,chosen_window_num,1);
gyro_window_z = to_avgZ(:,chosen_window_num,1);
% times from templates
tx = t_cell{1};
ty = t_cell{2};
tz = t_cell{3};
% length of arrays for future padding
tmp_len = length(t_cell{1});
lx = length(gyro_window_x);
ly = length(gyro_window_y);
lz = length(gyro_window_z);
n = max([lx,ly,lz,tmp_len]);
% padd all to same size
        gyro_window_x = padarray(gyro_window_x,n-lx,'replicate','post');
        tx = padarray(tx,n-tmp_len,'replicate','post');
        gyro_window_y = padarray(gyro_window_y,n-ly,'replicate','post');
        ty = padarray(ty,n-tmp_len,'replicate','post');
        gyro_window_z = padarray(gyro_window_z,n-lz,'replicate','post');
        tz = padarray(tz,n-tmp_len,'replicate','post'); 
% plot- on same figure as templates
    subplot(3,1,1);
    hold on;
    plot(tx,gyro_window_x);
    legend("template","gyro");
    subplot(3,1,2);
    hold on;
    plot(ty,gyro_window_y);
    subplot(3,1,3);
    hold on;
    plot(tz,gyro_window_z);
end
%%