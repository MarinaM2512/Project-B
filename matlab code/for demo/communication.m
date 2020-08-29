% ble_communication
close all; clear all; clc;

HAND_DIRECT_EXECUTE_SERVICE_UUID =     "e0198000-7544-42c1-0000-b24344b6aa70";
EXECUTE_ON_WRITE_CHARACTERISTIC_UUID = "e0198000-7544-42c1-0001-b24344b6aa70";

b = ble("Haifa3D");
c = characteristic(b,HAND_DIRECT_EXECUTE_SERVICE_UUID,...
    EXECUTE_ON_WRITE_CHARACTERISTIC_UUID); % uuid service , uuid charachteristic

data = read(c);
% write(c,1);