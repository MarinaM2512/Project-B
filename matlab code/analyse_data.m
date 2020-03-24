clc;
close all;
len=length(qZ);
idx_g=find(N_x_qw=='x:');
gyro_x=x_qW(idx_g);
gyro_y=y_qX(idx_g);
gyro_z=z_qY(idx_g);

idx_q=find(N_x_qw=='qW:');
quat_w=x_qW(idx_q);
quat_x=y_qX(idx_q);
quat_y=z_qY(idx_q);
quat_z=qZ(idx_q);
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







