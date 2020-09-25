% accel_x, accel_y,accel_z ,gyro_x, gyro_y, gyro_z, 
% quat_w, quat_x, quat_y, quat_z,cal,cal,cal,cal, fsr0, fsr1 ,fsr2 ,fsr3, fsr4];
date="17_04";
movement_name = ["sit_N_swipe_L2"    "sit_N_swipe_R2" ...
                 "sit_N_tap1"    "sit_N_side_ancle2"];

for i= 1:length(movement_name)

    data_mat = loadMeasurmentMat(date,movement_name(i),0,'INIT');
    t=data_mat(:,20);
    data_matR = loadMeasurmentMat(date,movement_name(i),1,'INIT');
    tR=data_matR(:,20);
    
    figure(i);
    subplot(2,3,1);
    plot(t,data_mat(:,1),tR,data_matR(:,1));
    legend("1","r");
    title("accelX");
    subplot(2,3,2);
    plot(t,data_mat(:,6),tR,data_matR(:,6));
    legend("1","r");
    title("accelZ");
    subplot(2,3,3);
    plot(t,data_mat(:,9),tR,data_matR(:,9));
    legend("1","r");
    title("qaut_Y");
    subplot(2,3,4);
    plot(t,data_mat(:,end-3),tR,data_matR(:,end-3));
    legend("1","r");
    title("fsr2");
    subplot(2,3,5);
    plot(t,data_mat(:,end-2),tR,data_matR(:,end-2));
    legend("1","r");
    title("fsr3");
    subplot(2,3,6);
    plot(t,data_mat(:,end-1),tR,data_matR(:,end-1));
    legend("1","r");
    title("fsr4");
end

