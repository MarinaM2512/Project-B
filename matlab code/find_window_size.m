function window_size=find_window_size(all_data)
[num_meas,num_features,num_movements] =size(all_data);
frame_len = 10;
% avg_size_accel_gyro_quat=zeros(40);
max_size=0;
for i=1:num_movements
    for j=1:10 
        for k=1:num_meas
            meas_vec=cell2mat(all_data(i,j,k));
            sum_frames=devide_to_farames(meas_vec,10);
            sum_frames=sort(sum_frames);
            thresh=sum_frames(length(sum_frames)-130); %check how to make better
            thresh_vec=zeros(1,length(y_1));
            thresh_vec(find(abs(diff(y_1))>thresh))=max(abs(y_1));
            rows=length(thresh_vec/100);
            [idx,~]=find(thresh_vec>0);
            len=mod(length(thresh_vec),100);
            windows=zeros(1,length(y_1));
            for i=(1+len):100:(length(thresh_vec)-100)
                frame=thresh_vec(i:i+100);
                idx=find(frame>0)+i+1;
                if(~isempty(idx))
                    start=idx(1);
                    ending=idx(end);
                    max_size=max(max_size,ending-start);
                end
            end
        end
    end
end
end
    
    


            
            
