function action = set_pwm(device, pwm_value)
%% Sets the PWM of the fan
% Inputs:
%  ~ device: serialport object controlling the real world system
%  ~ pwm_value: A value from 0 to 4095 to set the pulse width modulation of
%  the actuator
% Outputs:
%  ~ action: the control action to change the PWM
%
% Created by:  Kyle Naddeo 2/4/2022
% Modified by: Josh Lamb & Margot Hansen 5/9/2022

%% Force PWM value to be valid
assert(pwm_value >= 0);
assert(pwm_value <= 4095); % Bound value to limits 0 to 4095

%% Send Command
% May need to use flush command to set mode from Continuous to
% Halt-Continuous (clear buffer values)
% use the serialport() command options to change the PWM value to action
%s = serialport("COM5", 19200);
writeline(device, "P" + pwm_value);


end