function [time]=seperate_timeString(X)
time=[];
if(~isempty(X))
remain = strrep(X,'[','');
[year,remain] = strtok(remain,'-');
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
