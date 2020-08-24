% FUNCTION finds component q_init for single axis
% S cell of segmented data
% T cell of segmented times - הורדתי
% q_init   matrix of quats to normlize by,len as num of segments
% t_init   times where we get q_init or approximation
function q_init=find_quat_init(S) % optional- T
q_init=zeros(length(S),1);
% t_init=zeros(length(S),1);
% app=0.3;
    for i=1:length(S)
        data_tmp = cell2mat(S(i));
        n = length(data_tmp);
        q_init(i,:) = sum(data_tmp)/n;
%         times_tmp = cell2mat(T(i));
%         t_ind = find( abs(data_tmp-q_init(i))<=app ,1);
%         t_init(i) = times_tmp(t_ind);
    end
end
