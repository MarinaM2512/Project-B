% data  - all data collected
% times - time stemps [ms]
% delay - of system   [ms]
% S     - cell of data segmented by time
% T     - cell of timestemp with corelation to S
function [S,T]=data2timeSegments(data,times,delay)
% dim1=floor(times(end)/delay);
dim1=ceil(times(end)/delay);
S=cell(dim1,1);
T=cell(dim1,1);
end_of_frame=[];
i=0;
re_ind=1;
d_ind=20;
remain=times;
for k=1:dim1
        if(~isempty(remain(re_ind:end)))
            remain=remain(re_ind:end);
            diff=remain-remain(1)-delay;
            end_of_frame = find(diff<=d_ind);
            ind=i+end_of_frame;
            if( ind(end) <= length(data))
                data_tmp=data(ind);
                time_tmp=times(ind);
                S(k,1)={data_tmp};
                T(k,1)={time_tmp};
                re_ind=end_of_frame(end);
                i=i+end_of_frame(end);       
            else
                S(dim1,1)={data(i:length(data))};
                T(dim1,1)={times(i:length(data))};
                break
            end
        end
end
end

