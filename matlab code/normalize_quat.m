function q_n=normalize_quat(window,t,Fs)
q_init = find_quat_init(window,t,Fs);
q_init_conj = quatconj(q_init);
q_n = quatmultiply(window,q_init_conj);
end