function [time]=seperate_timeString(X)
% read the format in the txt file time data is saved at.
% year-month-day hour:min:sec
% X- the string from the txt file
% time - the time data in array of double [year;month;day;hour;min;sec]
time=[];
if(~isempty(X))
remain = strrep(X,'[',''); %replace '[' with ''
[year,remain] = strtok(remain,'-'); %split to year and remain when '-'
% year and remain both cell array of str
% repeat
remain = remain(2:end);
[month,remain] = strtok(remain,'-');
remain = remain(2:end);
[day,remain] = strtok(remain,' ');
remain = remain(2:end);
[hour,remain] = strtok(remain,':');
remain = remain(2:end);
[min,remain] = strtok(remain,':');
remain = remain(2:end);
sec  = strtok(remain,':');

sec = str2double(strtok(sec,']'));
year = str2double(year);
month = str2double(month);
day = str2double(day);
hour = str2double(hour);
min = str2double(min);

time = [year;month;day;hour;min;sec];
end
end
