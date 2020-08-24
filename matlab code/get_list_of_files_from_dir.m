function listOfFiles = get_list_of_files_from_dir (DirPath ,date, measType)
    if(~strcmp(measType,""))
        textFileName= strcat(DirPath,"\",date,"\","*",measType,"*.mat");
    else
        textFileName= strcat(DirPath,"\",date,"\","*",measType,".mat");
    end
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
end