clc;clear all; close all;
B=load("..\measurements\04_04\Data_extraction_sit_swipe_L1_FILTERED");
A=B.filtered_mat;
B1=load("..\measurements\04_04\Data_extraction_sit_swipe_L1");
A1=B1.final;
A(:,20)=A1(:,20);
%%
delay=200;
[S_qw,T_qw]= data2timeSegments(A(:,7),  A(:,20), delay);
[S_qx,T_qx]= data2timeSegments(A(:,8),  A(:,20), delay);
[S_qy,T_qy]= data2timeSegments(A(:,9),  A(:,20), delay);
[S_qz,T_qz]= data2timeSegments(A(:,10), A(:,20), delay);
q_norm1=normalize_quat(S_qw,S_qx,S_qy,S_qz);
q_norm=cell2mat(q_norm1);
t=A(:,20);
%%
figure();
subplot(2,2,1);
plot(t,q_norm(1:end-1,1));
title('w');
subplot(2,2,2);
plot(t,q_norm(1:end-1,2));
title('x');
subplot(2,2,3);
plot(t,q_norm(1:end-1,3));
title('y');
subplot(2,2,4);
plot(t,q_norm(1:end-1,4));
title('z');
%% div 1st 2nd order and gyro
mat=[q_norm(:,2),q_norm(:,3),q_norm(:,4)]; % x,y,z
Fs=50e6;
window_width=10;
% diff1 = numeric_diff_shunit(mat,Fs,'window',window_width,1);
% diff2 = numeric_diff_shunit(mat,Fs,'window',window_width,10);
diff1 = numeric_diff_shunit(mat,Fs,'poly',window_width,1);
diff2 = numeric_diff_shunit(mat,Fs,'poly',window_width,3);
%% plotting
close all;
d1_x = diff1(:,1);
d2_x = diff1(:,1);
t1_x = t(1:length(d1_x));
t2_x = t(1:length(d2_x));
figure();
plot(t1_x,d1_x,t2_x,d2_x,t,A(:,4));
% plot(t2_x,d2_x,t1_x,d1_x);
% legend('div2','div1');
legend('div1','div2','gyro x');
title('x');

d1_y = diff1(:,1);
d2_y = diff1(:,1);
t1_y = t(1:length(d1_y));
t2_y = t(1:length(d2_y));
figure();
plot(t1_y,d1_y,t2_y,d2_y,t,A(:,5));
legend('div1','div2','gyro y');
title('y');

d1_z = diff1(:,1);
d2_z = diff1(:,1);
t1_z = t(1:length(d1_z));
t2_z = t(1:length(d2_z));
figure();
plot(t1_z,d1_z,t2_z,d2_z,t,A(:,6));
legend('div1','div2','gyro z');
title('z');
