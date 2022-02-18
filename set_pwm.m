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
% Modified by: YOUR NAME and DATE

%% Force PWM value to be valid
pwm_value = 2000 % Bound value to limits 0 to 4095

%% Send Command
action = 'COM5' % string value of pwm_value for Josh's laptop :?
% use the serialport() command options to change the PWM value to action
s = serialport(action, pwm_value)

end
