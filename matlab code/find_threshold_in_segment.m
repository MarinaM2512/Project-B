function Flags=find_threshold_in_segment(vec,w_len,treshold,w_diff,times)
% stop_ind=floor(length(data)/w_diff)*w_diff;
% S,w_len,treshold,w_diff
dim1=floor(times(end)/w_diff);
Flags=cell(dim1,1);
w_diff_ind=1;
i=1;
k=1;
%     vec=cell2mat(S);
%     times=cell2mat(T_seg);
    
    while (w_diff_ind<=length(times))
        
        w_len_ind=find(abs(times(i:end)-times(i)-w_len)<=1,1);
        if (w_diff_ind+w_len_ind<=length(times))
           [pks,locs]=findpeaks(vec(i:i+w_len_ind));
           w_diff_ind=find((abs(times(i:i+w_len_ind)-times(i)-w_diff)<=1),1);
           i=w_diff_ind;
        else 
            [pks,locs]=findpeaks(vec(i:end));
            w_diff_ind=length(times)+1;
        end

            flags=locs(find(pks>=treshold));
            if(~isempty(flags))
                Flags(k)=flags;
                k=k+1;
            end
    end
end
    