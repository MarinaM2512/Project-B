function all_data= convert_data_mat(extracted_mat)
features=["accel_x", "accel_y","accel_z" ,"gyro_x", "gyro_y","gyro_z", "quat_w", "quat_x" ...
    "quat_y", "quat_z","accel_x", "accel_x" , "accel_x" , "accel_x", "fsr0", "fsr1" ,"fsr2" ,"fsr3","fsr4"];
meas_len=length(extracted_mat.accel_x);
all_data=zeros(meas_len,19);
for feture=1:19
    field=double(getfield(extracted_mat,features(feture)));
    if(length(field)>meas_len)
        field=field(end-meas_len+1:end);
%     if(feture>=11 && feture<=14)
%         field=field(end-meas_len+1:end);
    end
            all_data(:,feture)=field;
        end
end
         