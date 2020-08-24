function address = read_data_to_mat(date)
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
        begining_idx=regexp(s,'measurments')+length('measurments')+1;%use for measurments after 30_03 
        %begining_idx=regexp(s,'Test')+length('Test')+1;
        s=s(begining_idx:end);
        newStr = splitlines(s);
        idx=find(~cellfun(@isempty,newStr));
        line=newStr{idx(1)};
        first_time=seperate_timeString(line);
        times=zeros(length(newStr),1);
        split_line= strsplit(line,{'[',']'});
        original_string=[split_line{end} ' ' num2str(0)];
        num_rows=length(idx);
        for k=2:length(idx)
            line=newStr{idx(k)};
            time=seperate_timeString(line);
            num_ms=dt_func(first_time,time);
           times(k)=num_ms;
           split_line= strsplit(line,{'[',']'});
           original_string=[original_string newline split_line{end} ' ' num2str(num_ms)];
        end
        splitStr={original_string};
        writecell(splitStr,'tmp.txt');
        final=readmatrix('tmp.txt');
        final=final(1:end-1,:);
        name=split(listOfFiles{i},".");
        %save to sample folder
        mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name{1},".mat");
        save(mat_name,'final'); 
        address = mat_name;
    end
end