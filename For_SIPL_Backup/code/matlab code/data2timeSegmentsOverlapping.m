function segmented_data=data2timeSegmentsOverlapping(data,times,delay,overlap)
% data  - data to be divided to time segments - shape = N(number of sampled data points)xNum measured fetures 
% times - time stamps [ms]
% delay - of system - aka window width in #samples
% overlap - overlap between neighbouring segmants in #samples
% segmented_data - a cell array with #segments cells. each cell is a matrix
% of shape -  Num measured fetures + 1 x delay. {x,y,z,t}

segmented_data = cell(length(data),1);
i=0;
re_ind=1;
% remain=times;
remain = 1:length(data);
for k=1:length(data)
        if(~isempty(remain(re_ind:end)))
            remain=remain(re_ind:end);
            diff=(remain-remain(1));
            end_of_frame = find(diff<delay);
            ind=i+end_of_frame;
            if( ind(end) <= length(data))
                if(delay>size(data(ind,:)))
                    data_tmp=padarray(data(ind,:),delay-size(data(ind,:),1),0,'post');
                    data_tmp(:,end+1)= padarray(times(ind),delay-size(times(ind),1),...
                    'replicate','post');
                else
                    data_tmp = data(ind,:);
                    data_tmp(:,end+1) = times(ind);
                end
                segmented_data(k,1) = {data_tmp};
                re_ind=end_of_frame(end)-overlap;
                i=i+end_of_frame(end)-overlap;       
            else
                data_tmp =  padarray(data(i:length(data),:),delay-size(data(i:length(data)),2),0,'post');
                data_tmp(:,end+1)=padarray(times(i:length(data)),delay-size(times(i:length(data)),1),...
                'replicate','post');
                segmented_data(k,1) = {data_tmp};
                break
            end
        end
end
segmented_data =segmented_data(~cellfun('isempty',segmented_data));
end

