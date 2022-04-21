% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by YOUR NAME AND DATE

%% Start fresh
close all; clc; clear device;
syms s;
Kp = .1;
Ki = .1;
Kd = .1;
new_percentage = 0;
%% Connect to device
device = serialport("COM5", 19200);
%% Parameters
target      = 0.5;   % Desired height of the ball [m]
sample_rate = 0.25;  % Amount of time between controll actions [s]
pwm_value = 4000;

%% Give an initial burst to lift ball and keep in air
set_pwm(device,pwm_value); % Initial burst to pick up ball
pause(2); % Wait 0.1 seconds
pwm_value = 2625; %2625
set_pwm(device,pwm_value); % Set to lesser value to level out somewhere in
% the pipe

%% Initialize variables
action      = 2625; % Same value of last set_pwm   
error       = 0;
error_sum   = 0;

%% Feedback loop
while true
    %% Read current height
   
    [distance,pwm,target1,deadpan] = read_data(device);
    y = ir2y(distance/1000, new_percentage); % Convert from IR reading to distance from bottom [m]
    
    %% Calculate errors for PID controller
    error_prev = error;             % D
    error      = target - y;        % P
    error_sum  = error + error_sum; % I
    
    %% Control
    prev_action = action;
    %action = 2625; % Come up with a scheme no answer is right but do something
    %action = (target - error) * CONSTANT0 = ki + Kd
    %Ki = = CONSTANT1(error + error_sum) %value should be positive
    %Kd = = CONSTANT2(error - error_sum) %value should be negative
    if error > 0
    action = prev_action + Kp*error + Ki*(1/error_sum) + Kd*(error_prev-error);
    end

    if error < 0
    action = prev_action + Kp*error + Ki*(1/error_sum) + Kd*(error_prev-error);
    end

    %inital thoughts
    %Ki will naturally begin to have no effect 
    %Will need a loop for if error is positive or negative
    %i have no idea how to get the values (he may have made the equations last week)

    
   % sys = pid(kp, ki, kd, tf(a, 1 a 0));
    

    set_pwm(device, action); % Implement action
        

    

    % Wait for next sample
    pause(sample_rate)
end

%might need to mulitply system by a aka a^2 on top for final value theroem
%syms s
%a = error
%system = a^2/(s*(s+a));



