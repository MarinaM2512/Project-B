function all_data_medfilt=median_data_filt(all_data,n)
% function uses medfilt1(matlab function) to mdian filtering all data
% INPUT:
% 1. all_data -  is a mat of type double dim: length x num field(20) 
% 2. n - order of the one-dimensional median filter. The center of the med
%        filt is in floor(0.5n)+1 ( see n in help for Matlab func medfilt1)
%        this param is used only when type is "MEDIAN"
% OUTPUT:
% all_data_medfilt - al data after median filtering
 [len,num_field]=size(all_data);          
all_data_medfilt=zeros(len,num_field);
for ii=1:num_field
    if (ii<=10 || ii>=num_field-5)
        all_data_medfilt(:,ii)=medfilt1(all_data(:,ii),n);
    end
end
end


            
    


