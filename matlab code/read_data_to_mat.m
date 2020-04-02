
function read_data_to_mat(date)
%open all measurments files from a certain date and save them as matrices
%Measurments arangement in the mat: 
% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4
    textFileName= strcat("..\measurements\",date,"\","*",".txt");
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
    for i= 1:length(listOfFiles)
        fileName=strcat("..\measurements\",date,"\",listOfFiles{i});
        s=fileread(fileName); 
        %begining_idx=regexp(s,'measurments')+length('measurments')+1;%use for measurments after 30_03 
        begining_idx=regexp(s,'Test')+length('Test')+1;
        s=s(begining_idx:end);
        expression=' \n';
        splitStr = regexp(s,expression,'split');
        writecell(splitStr,'tmp.txt')
        final=readmatrix('tmp.txt');
        final=final(1:end-1,1:end-1);
        name=split(listOfFiles{i},".");
        mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name{1},".mat");
        save(mat_name,'final'); 
    end
end