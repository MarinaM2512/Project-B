clc;
close all;
%%Gyro
idx_g=find(N_x_qw=='gyro:')+1;
gyro_x=x_FSR0_qW(idx_g);
gyro_y=y_FSR1_qX(idx_g);
gyro_z=z_FSR2_qY(idx_g);

%%FSR
idx_fsr=find(N_x_qw=='FSR0:');
fsr0=x_FSR0_qW(idx_fsr);
fsr1=y_FSR1_qX(idx_fsr);
fsr2=z_FSR2_qY(idx_fsr);
fsr3=FSR3_qZ(idx_fsr);
fsr4=FSR4_Cal_sys(idx_fsr);

%%Quaternion
idx_q=find(N_x_qw=='qW:');
quat_w=x_FSR0_qW(idx_q);
quat_x=y_FSR1_qX(idx_q);
quat_y=z_FSR2_qY(idx_q);
quat_z=FSR3_qZ(idx_q);

%%Linear accel
idx_accel=find(N_x_qw=='acceleration:')+1;
accel_x=x_FSR0_qW(idx_accel);
accel_y=y_FSR1_qX(idx_accel);
accel_z=z_FSR2_qY(idx_accel);




x_q=1:length(quat_z);
x_fsr=1:length(fsr0);
x_accel=1:length(accel_x);
x_g=1:length(gyro_z);

figure;
title("Gyro");
subplot(3,1,1)
plot(x_g,gyro_x);
title("x");
subplot(3,1,2)
plot(x_g,gyro_y);
title("y");
subplot(3,1,3)
plot(x_g,gyro_z);
title("z");



figure;
title("Quaternions");
subplot(2,2,1)
plot(x_q,quat_w);
title("qW");
subplot(2,2,2)
plot(x_q,quat_x);
title("qX");
subplot(2,2,3)
plot(x_q,quat_y);
title("qY");
subplot(2,2,4)
plot(x_q,quat_z);
title("qZ");

figure;
subplot(2,3,1)
plot(x_fsr,fsr0);
title("fsr0");
subplot(2,3,2)
plot(x_fsr,fsr1);
title("fsr1");
subplot(2,3,3)
plot(x_fsr,fsr2);
title("fsr2");
subplot(2,3,4)
plot(x_fsr,fsr3);
title("fsr3");
subplot(2,3,5)
plot(x_fsr,fsr4);
title("fsr4");

figure;
subplot(3,1,1)
plot(x_accel,accel_x);
title("lin accel x");
subplot(3,1,2)
plot(x_accel,accel_y);
title("lin accel y");
subplot(3,1,3)
plot(x_accel,accel_z);
title("lin accel z");








