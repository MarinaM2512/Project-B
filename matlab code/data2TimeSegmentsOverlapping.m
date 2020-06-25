% data  - all data collected
% times - time stemps [ms]
% delay - of system - aka window width #samples
% S     - cell of data segmented by time
% T     - cell of timestemp with corelation to S
% overlap - overlap between neighbouring segmants #samples
function [S,T]=data2timeSegmentsOverlapping(data,times,delay,overlap)
Ts = times(2)-times(1);
delayT = delay*Ts;
overlapT = overlap*Ts;
dim1=ceil((times(end)-delayT)/(delayT-overlapT))+1;
S=cell(dim1,1);
T=cell(dim1,1);
i=0;
re_ind=1;
remain=times;
for k=1:dim1
        if(~isempty(remain(re_ind:end)))
            remain=remain(re_ind:end);
            diff=remain-remain(1);
            end_of_frame = find(diff<delay);
            
            ind=i+end_of_frame;
            if( ind(end) <= length(data))
                data_tmp=data(ind);
                time_tmp=times(ind);
                S(k,1)={data_tmp};
                T(k,1)={time_tmp};
                re_ind=end_of_frame(end)-overlap;
                i=i+end_of_frame(end);       
            else
                S(dim1,1)={data(i:length(data))};
                T(dim1,1)={times(i:length(data))};
                break
            end
        end
end
end

