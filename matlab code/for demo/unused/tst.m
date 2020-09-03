%%tst
%% 
clear all; close all; clc; 
% add matlab code to search path
oldpath = path;
path(oldpath,"C:\Users\Marina\Documents\Technion\Winter semester 2020\Project B\Project-B\matlab code");
%%
fid = fopen('tst2.txt');
line = fgetl(fid);
i=1;
window_size = 80; % 140 worked but may be too long  
line_cell = cell(window_size,1);
while (line~=-1)
    if(contains(line,"CALIBRATION") || contains(line,"BNO") || contains(line,"start") || contains(line,"measurments"))
        continue;
    end
    if (i>window_size)
        line_cell(1:end-1) = line_cell(2:end);
        line_cell(end) = {line};
        tic
        [msg(i),j] = analyze_data(line_cell,75,i);
        toc
        while(i<j)
            i=i+1;
            line = fgetl(fid);
            line_cell(1:end-1) = line_cell(2:end);
            line_cell(end) = {line};
        end
    else
        line_cell(i) = {line};
    end
    line = fgetl(fid);
    i=i+1;
end
fclose(fid);