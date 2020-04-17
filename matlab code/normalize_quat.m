%FUNCTION normlize quats in each segment
%Sw,Sx,Sy,Sz quats data segments in each axis
function q_norm=normalize_quat(Sw,Sx,Sy,Sz)
qw_init_vec = find_quat_init(Sw);
qx_init_vec = find_quat_init(Sx);
qy_init_vec = find_quat_init(Sy);
qz_init_vec = find_quat_init(Sz);

q_init= [qw_init_vec qx_init_vec qy_init_vec qz_init_vec];
q_init_conj = quatconj(q_init);
q_norm = cell(length(Sw),1);
for i=1:length(Sw)
    S = [Sw(i)' Sx(i)' Sy(i)' Sz(i)'];
    S = cell2mat(S);
    if(~isempty(S))
       q_norm(i) = {quatmultiply(S,q_init_conj(i,:))};
    end
end
end
