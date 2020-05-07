
function read_and_resample_data_INIT_to_mat(date)
%open all measurments files from a certain date and save them as matrices
%Measurments arangement in the mat: 
% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4
    textFileName= strcat("..\measurements\",date,"\","*","INIT.mat");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    for i= 1:length(listOfFiles)
        fileName=strcat("..\measurements\",date,"\",listOfFiles{i});
        initialised=load(fileName);
        initialised=initialised.initialised;
        initialised=resample_all_data(initialised);
        initialised=initialised(1:end-1,:);
        name=split(listOfFiles{i},".");
        %save to sample folder
        mat_name=strcat("..\measurements\resample\",date,"\","Data_extraction_",name{1},".mat");
        save(mat_name,'initialised'); 
    end
end