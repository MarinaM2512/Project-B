function [S,T]=data2timeSegments(data,times,delay)
% data  - all data collected
% times - time stemps [ms]
% delay - of system   [ms]
% S     - cell of data segmented by time
dim1=floor(times(end)/delay);
S=cell(dim1,1);
T=cell(dim1,1);
end_of_frame=1;
i=1;
for k=1:dim1
    if(i<length(data))
       end_of_frame = find((abs(times(i:end)-times(i)-delay)<=7),1);
    else
        S(dim1,1)={data(i:length(data))};
        T(dim1,1)={times(i:length(data))};
        break
    end
    S(k,1)={data(i:end_of_frame)};
    T(k,1)={times(i:end_of_frame)};
    i=end_of_frame;
end
end

