function [duration,ti,Ii,tf,If] = find_movement_duration(date,t_len,list_moves,thold,axis_num)
%axis num can be only: 4-6
%4- x
%5-y
%6-z
dt = zeros(t_len,length(list_moves));
ti = zeros(t_len,length(list_moves));
tf = zeros(t_len,length(list_moves));
Ii = zeros(t_len,length(list_moves));
If = zeros(t_len,length(list_moves));
    for i = 1:length(list_moves)
        [t,extraction] = plot_raw_data_with_move_extraction(list_moves{i},date,"gyro");
        z = extraction(:,axis_num);
        ind1 = find(abs(z)-thold>=1,1);
        t0 = t(ind1); Ii(1,i) = ind1;
        cnt = 1;
        d = 1;
        for k = ind1 +1 :length(z)
            if z(k) >= thold
                tfinal = t(k);
                cnt = cnt+1;
            else
                if cnt > 0
                    dt(d,i) = tfinal-t0;
                    ti(d,i) = t0;     Ii(d+1,i) = k;
                    tf(d,i) = tfinal; If(d  ,i) = k;
                    d = d+1;
                    cnt = 0;
                end
                t0 = t(k);
            end
        end
    end
duration = mean(nonzeros(dt));
for i = 1:length(ti)
    ti(:,i) = ti(:,i)-ti(1,i);
    tf(:,i) = tf(:,i)-ti(1,i);
end
    
close all;
end
