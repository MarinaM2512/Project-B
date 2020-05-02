function  [GyroX ,GyroY, GyroZ] = getGyroFromQuat(quat, F_S)
%%Goal: diffrentiate quaternions to get angulat velocity

%%Input Arguments:
% quat - matrix nX4 of measured 4 point quaternions 

%%Return:
% GyroX ,GyroY, GyroZ - 3 vectors of size mx1 of anguar velocity on each
% axis
window_width =50;
q_dot = numeric_diff_shunit(quat,F_S, 'window',window_width,1);
GyroX = zeros(length(q_dot),1);
GyroY = zeros(length(q_dot),1);
GyroZ = zeros(length(q_dot),1);
for i = 1:length(q_dot)
    GyroX(i)=[quat(i,4) -quat(i,3) quat(i,2) -quat(i,1)]*q_dot(i,:)';
    GyroY(i)=[quat(i,3) quat(i,4) -quat(i,1) -quat(i,2)]*q_dot(i,:)';
    GyroZ(i)=[quat(i,2) quat(i,1) quat(i,4) -quat(i,3)]*q_dot(i,:)';
end