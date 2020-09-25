% Goal: to go over the data vector using timestemps and not index.
%      Each iteration THE FUNCTION look for peaks in a window that
%      progress in w_diff.
% input arguments:
% 1. vec - input data
% 2. times - timestemps vector [sec]
% 3. w_len - window width [sec]
% 4. w_diff - advance the next window by w_diff [sec]
% 5. treshold - above that value we  mark as peak [units same as vec]
% output arguments:
% Flags- pics after tresholding
function Flags=find_threshold_in_segment(vec,times,w_len,w_diff,treshold)
dim1=floor(times(end)/w_diff);
Flags=cell(dim1,1);
w_diff_ind=1;
i=1;
k=1;

    while (w_diff_ind<=length(times))
        % transform time window into index in  matlab vector
        w_len_ind=find(abs(times(i:end)-times(i)-w_len)<=1,1);
        % find peak
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
    