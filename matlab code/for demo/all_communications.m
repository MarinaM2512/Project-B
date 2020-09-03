%
close all; clear all; clc;
% parameters to change:
WIN_WID = 100; %window width of samples analysis
COM_NAME = "COM6"; % check the COM number and update accoringly
BLE_NAME_ADDR = "Haifa3D"; %"240AC460A01E" or "A4CF129A672A"
oldpath = path;
path(oldpath,"C:\Users\Marina\Documents\Technion\Winter semester 2020\Project B\Project-B\matlab code");
id = "signal:findpeaks:largeMinPeakHeight";
warning('off',id);
%% movements definitions:
global movements
movements{1}.name = 'close';
movements{1}.len = uint8(5);%movement length byte
movements{1}.torque = uint8(bin2dec('11111000'));%torque [wrist,finger1,fin2,...]
movements{1}.time = uint8(10);%stop time
movements{1}.active = uint8(bin2dec('01111000'));%active motor  [wrist,finger1,fin2,...]
movements{1}.dir = uint8(bin2dec('11111000'));%motor direction  [wrist,finger1,fin2,...]

movements{2}.name = 'open';
movements{2}.len = uint8(5);%movement length byte, torque,time,active motor, motor direction
movements{2}.torque = uint8(bin2dec('11111000'));%movement length byte, torque,time,active motor, motor direction
movements{2}.time = uint8(10);%movement length byte, torque,time,active motor, motor direction
movements{2}.active = uint8(bin2dec('01111000'));%movement length byte, torque,time,active motor, motor direction
movements{2}.dir = uint8(bin2dec('00000000'));%movement length byte, torque,time,active motor, motor direction
%% ble_communication
HAND_DIRECT_EXECUTE_SERVICE_UUID =     "e0198000-7544-42c1-0000-b24344b6aa70";
EXECUTE_ON_WRITE_CHARACTERISTIC_UUID = "e0198000-7544-42c1-0001-b24344b6aa70";
BLE_NAME_ADDR = "2462ABF9729E";
b = ble(BLE_NAME_ADDR); % if bad connection run: blelist("Name","Haifa3D") and copy the address into BLE_NAME_ADDR
global ble_char
ble_char = characteristic(b,HAND_DIRECT_EXECUTE_SERVICE_UUID,...
    EXECUTE_ON_WRITE_CHARACTERISTIC_UUID); % uuid service , uuid charachteristic

%% arduino communication
arduinoObj = serialport(COM_NAME,115200); % baud rate
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);

arduinoObj.UserData.Data={};
arduinoObj.UserData.Count=0;
arduinoObj.UserData.isBufferFull = 0;
%% read sensor data parameters:
arduinoObj.UserData.win_wid = WIN_WID;
arduinoObj.UserData.statrt_time = now;
%% start sensor reading:
configureCallback(arduinoObj,"terminator",@readSensorData);
%% define the event variables:
% event flag when buffer is full and analysis can begin:
arduinoObj.UserData.Event = BufferEvent;
rtb = RespondToBufferEvent(arduinoObj.UserData.Event);
%event flag when a leg movement was detected and a message is needed to be
%sent:
arduinoObj.UserData.Event.Msg = MsgEvent;
rte = RespondToEvent(arduinoObj.UserData.Event.Msg);

%% callbacks:
function readSensorData(src, ~)
win_wid = src.UserData.win_wid;
% Read the ASCII data from the serialport object.
data = readline(src);
d = datestr(now,'[yyyy-mm-dd HH:MM:SS.FFF]');
line = strcat(d," ", data);
fprintf(strcat(line,"\n"));
% save the data as a string in the UserData property of the serialport
% object.
if(~(contains(data,"CALIBRATION") || contains(data,"BNO") || ...
        contains(data,"start") || contains(data,"measurments") ...
        || contains(data,"Orientation Sensor Test\n")))
src.UserData.Data{end+1} =line;

%
% Update the Count value of the serialport object.
src.UserData.Count = src.UserData.Count + 1;
else
    fprintf(strcat(line,"\n"));
    if(contains(data,"press s"))
        writeline(src,'s') 
    end
end
% if the data buffer is full, remove the first element (the oldest sample)
if src.UserData.Count > win_wid
    src.UserData.isBufferFull = 1;
end
if src.UserData.isBufferFull
    src.UserData.Data = src.UserData.Data(2:end);
    src.UserData.Count = src.UserData.Count - 1;
    if( src.UserData.Event.isAnaliseDone)
        src.UserData.Event.isAnaliseDone = 0;
        src.UserData.Event.currentData = src.UserData.Data;
        src.UserData.Event.OnEventChange(true);
    end
end
t = now;
if((t-src.UserData.statrt_time)>=0.0008)
    str = input("would you like to stop?\n",'s');
    if(strcmp(str,"stop"))
        configureCallback(src, "off");
        src.UserData.Event.OnEventChange(false);
        fprintf("all done :)");
    else
        src.UserData.statrt_time = now;
    end
end
end      
