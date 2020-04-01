
clc;
clear all;
close all;
function read_data_to_mat(date)
%%open all measurments files from a certain date and save them as matrices

num_meas=10;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:num_meas
        textFileName= strcat("..\measurements\",date,"\",name,num2str(k),".txt");
        if exist(textFileName, 'file')
            s=fileread(textFileName); 
            %begining_idx=regexp(s,'measurments')+length('measurments')+1;
            begining_idx=regexp(s,'Test')+length('Test')+1;
            s=s(begining_idx:end);
            expression=' \n';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,1:end-1);
            mat_name=strcat("..\measurements\",date,"\","Data_extraction_",name,num2str(k),".mat");
            save(mat_name,'final'); 
        else
            fprintf('File %s does not exist.\n', textFileName);
        end
    end
end
end