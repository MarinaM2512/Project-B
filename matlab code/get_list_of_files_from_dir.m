function listOfFiles = get_list_of_files_from_dir (DirPath ,date, measType)
% function get name list of all diffrenet files in th directory
% "DirPath/date" 
% INPUT: 
% 1. DirPath - path directory all measurments are saved
% 2. date - directory in DirPath where the data collected in date was saved 
% "DirPath/date" is the Directory Path where raw data is saved
% 3. measType - can get the following:
%            a. "" : empty string - to get listOfFiles for raw data
%            b. "FILTERED_INIT" : to get listOfFiles of the filtered
%            measurments
% OUTPUT:
% listOfFiles - cell of srings 
%               contains all names of all files in the directory

    if(~strcmp(measType,""))
        textFileName= strcat(DirPath,"\",date,"\","*",measType,"*.mat");
    else
        textFileName= strcat(DirPath,"\",date,"\","*",measType,".mat");
    end
    DirList = dir(fullfile(textFileName));
    listOfFiles = {DirList.name};
end