function [distance,pwm,target,deadpan] = read_data(device)
%% Reads data sent back from Ball and Pipe system
% Inputs:
%  ~ device: serialport object controlling the real world system
% Outputs:
%  ~ distance: the IR reading from the time of flight sensor
%  ~ pwm: the PWM from the manual knob of the system (NOT THE SAME AS THE
%  PWM YOU MAY SET THROUGH SERIAL COMMUNICATION)
%  ~ target: the desired height of the ball set by the manual knob of the
%  system
%  ~ deadpan: the time delay after an action set by the manual knob of the
%  system
%
% Created by:  Kyle Naddeo 1/3/2022
% Modified by: YOUR NAME and DATE

%% Ask nicely for data
% use the serialport() command options to write the correct letter to the
% system (Hint: the letters are in the spec sheet)
writeline(device, "S")

%% Read data
% use the serialport() command options to read the response
data = read(device, 20, "char")

%% Translate
% translate the response to 4 doubles using str2double() and
% extractBetween() (Hint: the response is in the spec sheet)
distance  = str2double(extractBetween(data, 2, 5,"Boundaries","inclusive")); %dddd
manual_pwm = str2double(extractBetween(data, 7, 10, "Boundaries","inclusive")); %pppp
target     = str2double(extractBetween(data, 12, 15, "Boundaries","inclusive")); %ssss
deadpan    = str2double(extractBetween(data, 17, 20, "Boundaries","inclusive"; %hhhh

end