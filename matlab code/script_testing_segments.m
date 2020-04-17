B=load("..\measurements\04_04\Data_extraction_sit_swipe_L1");
A=B.final;

%%
delay=200;
[S_qw,T_qw]= data2timeSegments(A(:,7),  A(:,20), delay);
[S_qx,T_qx]= data2timeSegments(A(:,8),  A(:,20), delay);
[S_qy,T_qy]= data2timeSegments(A(:,9),  A(:,20), delay);
[S_qz,T_qz]= data2timeSegments(A(:,10), A(:,20), delay);
q_norm1=normalize_quat(S_qw,S_qx,S_qy,S_qz);

%%
q_norm=cell2mat(q_norm1);
t=A(:,20);
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