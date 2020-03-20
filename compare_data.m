clc;clear all;

%tap
tap1= load('Data_extraction_tap1_sit.mat');
qW_tap1=tap1.quat_w;%quaternions
qX_tap1=tap1.quat_x;
qY_tap1=tap1.quat_y;
qZ_tap1=tap1.quat_z;
gX_tap1=tap1.gyro_x;%gyro
gY_tap1=tap1.gyro_y;
gZ_tap1=tap1.gyro_z;

x_tap1=1:length(qW_tap1);

tap2=load('Data_extraction_tap2_sit.mat');
qW_tap2=tap2.quat_w;%quaternions
qX_tap2=tap2.quat_x;
qY_tap2=tap2.quat_y;
qZ_tap2=tap2.quat_z;
gX_tap2=tap2.gyro_x;%gyro
gY_tap2=tap2.gyro_y;
gZ_tap2=tap2.gyro_z;

x_tap2=1:length(qW_tap2);

tap3=load('Data_extraction_tap3_sit.mat');
qW_tap3=tap3.quat_w;%quaternions
qX_tap3=tap3.quat_x;
qY_tap3=tap3.quat_y;
qZ_tap3=tap3.quat_z;
gX_tap3=tap3.gyro_x;%gyro
gY_tap3=tap3.gyro_y;
gZ_tap3=tap3.gyro_z;

x_tap3=1:length(qW_tap3);


%swipe left
swipeL1= load('Data_extraction_L1_sit.mat');
qW_L1=swipeL1.quat_w;%quaternions
qX_L1=swipeL1.quat_x;
qY_L1=swipeL1.quat_y;
qZ_L1=swipeL1.quat_z;
gX_L1=swipeL1.gyro_x;%gyro
gY_L1=swipeL1.gyro_y;
gZ_L1=swipeL1.gyro_z;

x_L1=1:length(qW_L1);


swipeL2= load('Data_extraction_L2_sit.mat');
qW_L2=swipeL2.quat_w;%quaternions
qX_L2=swipeL2.quat_x;
qY_L2=swipeL2.quat_y;
qZ_L2=swipeL2.quat_z;
gX_L2=swipeL2.gyro_x;%gyro
gY_L2=swipeL2.gyro_y;
gZ_L2=swipeL2.gyro_z;

x_L2=1:length(qW_L2);

swipeL3= load('Data_extraction_L3_sit.mat');
qW_L3=swipeL3.quat_w;%quaternions
qX_L3=swipeL3.quat_x;
qY_L3=swipeL3.quat_y;
qZ_L3=swipeL3.quat_z;
gX_L3=swipeL3.gyro_x;%gyro
gY_L3=swipeL3.gyro_y;
gZ_L3=swipeL3.gyro_z;

x_L3=1:length(qW_L3);

%swipe right
swipeR1= load('Data_extraction_R1_sit.mat');
qW_R1=swipeR1.quat_w;%quaternions
qX_R1=swipeR1.quat_x;
qY_R1=swipeR1.quat_y;
qZ_R1=swipeR1.quat_z;
gX_R1=swipeR1.gyro_x;%gyro
gY_R1=swipeR1.gyro_y;
gZ_R1=swipeR1.gyro_z;

x_R1=1:length(qW_R1);


swipeR2= load('Data_extraction_R2_sit.mat');
qW_R2=swipeR2.quat_w;%quaternions
qX_R2=swipeR2.quat_x;
qY_R2=swipeR2.quat_y;
qZ_R2=swipeR2.quat_z;
gX_R2=swipeR2.gyro_x;%gyro
gY_R2=swipeR2.gyro_y;
gZ_R2=swipeR2.gyro_z;

x_R2=1:length(qW_R2);

swipeR3= load('Data_extraction_R3_sit.mat');
qW_R3=swipeR3.quat_w;%quaternions
qX_R3=swipeR3.quat_x;
qY_R3=swipeR3.quat_y;
qZ_R3=swipeR3.quat_z;
gX_R3=swipeR3.gyro_x;%gyro
gY_R3=swipeR3.gyro_y;
gZ_R3=swipeR3.gyro_z;

x_R3=1:length(qW_R3);

%% plot Quats
fig=figure(1);%tap
set(fig,'Name','tap');
subplot(2,2,1);%quat W
plot(x_tap1,qW_tap1);
hold all;
plot(x_tap2,qW_tap2);
plot(x_tap3,qW_tap3);
legend("qw1","qw2","qw3");
subplot(2,2,2);%quat X
plot(x_tap1,qX_tap1);
hold all;
plot(x_tap2,qX_tap2);
plot(x_tap3,qX_tap3);
legend("qx1","qx2","qx3");
subplot(2,2,3);%quat Y
plot(x_tap1,qY_tap1);
hold all;
plot(x_tap2,qY_tap2);
plot(x_tap3,qY_tap3);
legend("qy1","qy2","qy3");
subplot(2,2,4);%quat Z
plot(x_tap1,qZ_tap1);
hold all;
plot(x_tap2,qZ_tap2);
plot(x_tap3,qZ_tap3);
legend("qZ1","qZ2","qZ3");

fig2=figure(2);%swipe right
set(fig2,'Name','swipe right');
subplot(2,2,1);%quat W
plot(x_R1,qW_R1);
hold all;
plot(x_R2,qW_R2);
plot(x_R3,qW_R3);
xlim([50,1500]);
legend("qw1","qw2","qw3");
subplot(2,2,2);%quat X
plot(x_R1,qX_R1);
hold all;
plot(x_R2,qX_R2);
plot(x_R3,qX_R3);
xlim([50,1500]);
legend("qx1","qx2","qx3");
subplot(2,2,3);%quat Y
plot(x_R1,qY_R1);
hold all;
plot(x_R2,qY_R2);
plot(x_R3,qY_R3);
xlim([50,1500]);
legend("qy1","qy2","qy3");
subplot(2,2,4);%quat Z
plot(x_R1,qZ_R1);
hold all;
plot(x_R2,qZ_R2);
plot(x_R3,qZ_R3);
xlim([50,1500]);
legend("qZ1","qZ2","qZ3");

fig3=figure(3);%swipe left
set(fig3,'Name','swipe left');
subplot(2,2,1);%quat W
plot(x_L1,qW_L1);
hold all;
plot(x_L2,qW_L2);
plot(x_L3,qW_L3);
legend("qw1","qw2","qw3");
subplot(2,2,2);%quat X
plot(x_L1,qX_L1);
hold all;
plot(x_L2,qX_L2);
plot(x_L3,qX_L3);
legend("qx1","qx2","qx3");
subplot(2,2,3);%quat Y
plot(x_L1,qY_L1);
hold all;
plot(x_L2,qY_L2);
plot(x_L3,qY_L3);
legend("qy1","qy2","qy3");
subplot(2,2,4);%quat Z
plot(x_L1,qZ_L1);
hold all;
plot(x_L2,qZ_L2);
plot(x_L3,qZ_L3);
legend("qZ1","qZ2","qZ3");

%% Plot Gyros
fig4=figure(4);%tap
set(fig4,'Name','tap');
subplot(3,1,1);%gyro X
plot(x_tap1,gX_tap1);
hold all;
plot(x_tap2,gX_tap2);
plot(x_tap3,gX_tap3);
legend("gx1","gx2","gx3");
subplot(3,1,2);%gyro Y
plot(x_tap1,gY_tap1);
hold all;
plot(x_tap2,gY_tap2);
plot(x_tap3,gY_tap3);
legend("gy1","gy2","gy3");
subplot(3,1,3);%gyro Z
plot(x_tap1,gZ_tap1);
hold all;
plot(x_tap2,gZ_tap2);
plot(x_tap3,gZ_tap3);
legend("gZ1","gZ2","gZ3");

fig5=figure(5);%swipe right
set(fig5,'Name','swipe right');
subplot(3,1,1);%gyro X
plot(x_R1,gX_R1);
hold all;
plot(x_R2,gX_R2);
plot(x_R3,gX_R3);
legend("gx1","gx2","gx3");
subplot(3,1,2);%gyro Y
plot(x_R1,gY_R1);
hold all;
plot(x_R2,gY_R2);
plot(x_R3,gY_R3);
legend("gy1","gy2","gy3");
subplot(3,1,3);%gyro Z
plot(x_R1,gZ_R1);
hold all;
plot(x_R2,gZ_R2);
plot(x_R3,gZ_R3);
legend("gZ1","gZ2","gZ3");

fig6=figure(6);%swipe left
set(fig6,'Name','swipe left');
subplot(3,1,1);%gyro X
plot(x_L1,gX_L1);
hold all;
plot(x_L2,gX_L2);
plot(x_L3,gX_L3);
legend("gx1","gx2","gx3");
subplot(3,1,2);%gyro Y
plot(x_L1,gY_L1);
hold all;
plot(x_L2,gY_L2);
plot(x_L3,gY_L3);
legend("gy1","gy2","gy3");
subplot(3,1,3);%gyro Z
plot(x_L1,gZ_L1);
hold all;
plot(x_L2,gZ_L2);
plot(x_L3,gZ_L3);
legend("gZ1","gZ2","gZ3");


