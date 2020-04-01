
function read_data_to_mat(date)
%open all measurments files from a certain date and save them as matrices
%Measurments arangement in the mat: 
% accel_x accel_y accel_z gyro_x gyro_y gyro_z qW qX qY qZ 
% Cal_sys Cal_gyro Cal_accel Cal_mag FSR0 FSR1 FSR2 FSR3 FSR4
%num_meas=10;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    %for k=1:num_meas
        %textFileName= strcat("..\measurements\",date,"\",name,num2str(k),".txt");
        textFileName= strcat("..\measurements\",date,"\",name,"*",".txt");
        DirList     = dir(fullfile(textFileName));
        listOfFiles = {DirList.name};
        for file= listOfFiles
        %if exist(textFileName, 'file')
            s=fileread(file); 
            %begining_idx=regexp(s,'measurments')+length('measurments')+1;%use for measurments after 30_03 
            begining_idx=regexp(s,'Test')+length('Test')+1;
            s=s(begining_idx:end);
            expression=' \n';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,1:end-1);
            mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name,num2str(k),".mat");
            save(mat_name,'final'); 
        end
end
end
%end