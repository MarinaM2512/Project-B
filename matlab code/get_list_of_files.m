function listOfFiles = get_list_of_files (date , type , resample)
    textFileName= strcat("..\measurements\",date,"\","*",type,".mat");
    if(resample)
        textFileName= strcat("..\measurements\resample\",date,"\","*",type,".mat");
    end
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
end