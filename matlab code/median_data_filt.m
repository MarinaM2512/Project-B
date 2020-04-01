function all_data_medfilt=median_data_filt(all_data,n) 
%all_data is a mat of type double dim: length x num field 
 [len,num_field]=size(all_data);          
all_data_medfilt=zeros(len,num_field);
for ii=1:num_field
    if (ii<=10 || ii>=num_field-5)
        all_data_medfilt(:,ii)=medfilt1(all_data(:,ii),n);
    end
end
end


            
    


