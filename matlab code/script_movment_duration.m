%% list of names for all movments
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);
    swl_names = names_of_move( list_moves, "swipe_L");
    swr_names = names_of_move( list_moves, "swipe_R");
    tap_names = names_of_move( list_moves, "tap");
    anc_names = names_of_move( list_moves, "side_ancle");

%% plot all gyro
str = list_moves;
for i=1:length(str)
    [~,~]=plot_raw_data_with_move_extraction(str{i},date,"gyro");
end
%%
data_mat = loadMeasurmentMat(date,list_moves(1),1,"INIT");
t = data_mat(:,20);
thold_swl = 50;
thold_swr = 50;
thold_tap = 50;
thold_anc = 50;
[dt_swl,ti_swl,tf_swl] = find_movement_duration(date,length(t),swl_names,thold_swl,6);
% duration_swr = find_movement_duration(date,length(t),swl_names,thold_swr,6);
% duration_tap = find_movement_duration(date,length(t),swl_names,thold_tap,4);
% duration_anc = find_movement_duration(date,length(t),swl_names,thold_anc,5);
%%
num_of_smpls =  10;
dt = 20;                        %[msec]
win_width = dt*num_of_smpls;    %[msec]
% mean1 = 