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

%%
date = "17_04";
list_moves  = get_all_meas_names(date, "FILTERED_INIT", 1);

%%
figure();
print_templates(temp_swl(:,1),temp_swl(:,2),temp_swl(:,3),t_sl,"swipe left");
print_templates(temp_swr(:,1),temp_swr(:,2),temp_swr(:,3),t_sr,"swipe right");
print_templates(temp_tap(:,1),temp_tap(:,2),temp_tap(:,3),t_tap,"tap");
print_templates(temp_ank(:,1),temp_ank(:,2),temp_ank(:,3),t_anc,"ancle");

%%
function print_gyro(date,movement_name,resampled)
data_mat = loadMeasurmentMat(date,movement_name,1,"INIT")
    time_vec = data_mat(:, end);
    gyro_mat = data_mat(:, 4:6);
    subplot(3,1,1);
    hold on;
    plot(t,);
    subplot(3,1,2);
    subplot(3,1,3);