%% Script Info
% Mechanics Lab final project: using hall effect sensors and a permanent
% magnet to control the distance between two carts on a track. Cart 1, in
% front, has the magnet and Cart 2 has the sensor and a motor with which to
% dynamically adjust its speed.

%% Setup
clear;
clc;

%% Material Variables
% sensor sensitivity (V/Gauss)
sensor_sensitivity = 2.5 * 10^-3;
% sensor output at 0 Gauss (V)
sensor_null_voltage = 2.5;
% sensor output limits (V)  [using a 5V supply]
sensor_low_lim = 0.2;
sensor_up_lim = 4.8;
% sensor response time (s)
sensor_response_time = 3 * 10^-6;

%% Situational Variables
n = 3000001;
t_end = 3;
T = linspace(0, t_end, n);
dt = t_end/(n-1);
x1 = zeros(1, n);
x2 = zeros(1, n);
v1 = zeros(1, n);
v2 = zeros(1, n);
% initial postions (m)      % measured from the magnet and the hall sensor respectively
x1(1) = 0.1;
x2(1) = 0;
% velocity of cart 1 over time

%% Main
% X = linspace(0, 0.02);
% Y1 = getFieldStrength(X);
% Y2 = getSensorOutput(Y1, sensor_null_voltage, sensor_sensitivity, sensor_up_lim, sensor_low_lim);

% euler's method
for i = 2:n
    if i/n < 2/7
        v1(i-1) = 2;
    elseif i/n < 4/7
        v1(i-1) = 0.2;
    else
        v1(i-1) = 1 + sin(20*T(i-1));
    end
    
    dist = x1(i-1) - x2(i-1);
    field_strength = getFieldStrength(dist);
    sensor_output = getSensorOutput(field_strength, sensor_null_voltage, sensor_sensitivity, sensor_up_lim, sensor_low_lim);
    v2(i-1) = setMotorSpeed(sensor_output);
    
    x1(i) = x1(i-1) + v1(i-1)*dt;
    x2(i) = x2(i-1) + v2(i-1)*dt;
end

plot(T, x1, T, x2, "LineWidth", 2)
xlabel("Time (s)")
ylabel("Position (m)")
grid on

%% Subfunctions
function [field_strength] = getFieldStrength(dist)
    % dist: distance between sensor and magnet (m)
    % field_strength: magnetic field strength (Gauss) at given distance
    % equation detremined "experimentally"
    field_strength = 2615./(dist.*1000 + 1.534).^2;
end

function [sensor_output] = getSensorOutput(field_strength, sensor_null_voltage, sensor_sensitivity, sensor_up_lim, sensor_low_lim)
    % field strength: strength of the magnetic field (Gauss)
    % sensor_output: analog sensor output (V)
    sensor_output = sensor_null_voltage + sensor_sensitivity.*field_strength;
    sensor_output = max(min(sensor_output, sensor_up_lim), sensor_low_lim);
end

function [motor_speed] = setMotorSpeed(sensor_output)
    % sensor_output: sensor output in volts
    % motor_speed: speed to set motor to
    if sensor_output > 2.5492
        % if within ~1 cm, full brakes
        motor_speed = 0;
    elseif sensor_output > 2.5141
        % ~2 cm
        motor_speed = 0.4;
    elseif sensor_output > 2.5066
        % ~3 cm
        motor_speed = 0.8;
    elseif sensor_output > 2.5038
        % ~4 cm
        motor_speed = 1.2;
    else
        motor_speed = 1.6;
    end
end