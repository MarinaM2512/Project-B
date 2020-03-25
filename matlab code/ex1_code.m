clc;
clear all;
i=1;
for name = ["sit_tap", "sit_side_ancle" ,"sit_swipe_R", "sit_swipe_L"]
    for k=1:3
        textFileName= strcat("..\measurements\25_03\",name,num2str(k),".txt");
        if exist(textFileName, 'file')
            s=fileread(textFileName); 
            begining_idx=regexp(s,'FSR4')+length('FSR4')+1;
            s=s(begining_idx:end);
            expression=' ';
            splitStr = regexp(s,expression,'split');
            writecell(splitStr,'tmp.txt')
            final=readmatrix('tmp.txt');
            final=final(1:end-1,:);
            mat_mame=strcat("Data_extraction",name,num2str(k),".mat");
            save(mat_mame,'final');
        else
            fprintf('File %s does not exist.\n', textFileName);
        end
    end
end
