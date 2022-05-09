% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by YOUR NAME AND DATE

%% Start fresh
close all; clc; clear device;
syms s;
Kp = 0;    %constant for proportional
Ki = 0;    %constant for proportional-plus-integral (error) (should be very small)
Kd = .5;    %constant for proportional-plus-derivative (transient response)
new_percentage = 0;
%% Connect to device
device = serialport("COM5", 19200);     % baud rate of 19,200
%% Parameters
target      = 0.5;   % Desired height of the ball [m]
sample_rate = 0.01;  % Amount of time between controll actions [s]
pwm_value = 4000;    %pwm of 4000 keeps ball at top of pipe

%% Give an initial burst to lift ball and keep in air
set_pwm(device,pwm_value); % Initial burst to pick up ball
pause(2);                  % Wait 2 seconds
pwm_value = 2625;          %2625 found to put ball around 0.5m target
set_pwm(device,pwm_value); % Set to lesser value to level out 

%% Initialize variables
action      = 2625; % Same value of last set_pwm   
error       = 0;    % Inital error 
error_sum   = 0;

%% Feedback loop
while true
    %% Read current height
   
    [distance,pwm,target1,deadpan] = read_data(device); %pwm, target1, and deadpan unused
    y = ir2y(distance/1000); % Convert from IR reading (mm) to distance from bottom [m]
    
    %% Calculate errors for PID controller
    error_prev = error;             % D
    error      = target - y;        % P
    error_sum  = error + error_sum; % I
    
    %% Control
    prev_action = action;

   Kp = 0; %Initial K constants set equal to 0
   Kd = 0;
   Ki = 0;
   Final_Kp = Kp * error; %Kp proportional to error
   Final_Kd = Kd * (error-error_prev); %Kd proportional to derivative of error
   Final_Ki = Ki * error_sum; %Ki proportional to integral/sum of error
   Sum_Final_K = Final_Kp + Final_Kd + Final_Ki; %Kpid

   action = prev_action + Sum_Final_K;

   set_pwm(device, action); % Implement action

   pause(sample_rate); %Wait for next sample
end



