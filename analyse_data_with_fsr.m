clc;
close all;
%%Gyro
idx_g=find(N_x_qw=='x:');
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

x=1:length(quat_z);

figure;
title("Gyro");
subplot(3,1,1)
plot(x,gyro_x);
title("x");
subplot(3,1,2)
plot(x,gyro_y);
title("y");
subplot(3,1,3)
plot(x,gyro_z);
title("z");



figure;
title("Quaternions");
subplot(2,2,1)
plot(x,quat_w);
title("qW");
subplot(2,2,2)
plot(x,quat_x);
title("qX");
subplot(2,2,3)
plot(x,quat_y);
title("qY");
subplot(2,2,4)
plot(x,quat_z);
title("qZ");

figure;
subplot(2,3,1)
plot(x,fsr0);
title("fsr0");
subplot(2,3,2)
plot(x,fsr1);
title("fsr1");
subplot(2,3,3)
plot(x,fsr2);
title("fsr2");
subplot(2,3,4)
plot(x,fsr3);
title("fsr3");
subplot(2,3,5)
plot(x,fsr4);
title("fsr4");







