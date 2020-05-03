%% Script Info
% Mechanics Lab final project: using hall effect sensors and a permanent
% magnet to control the distance between two carts on a track. Cart 1, in
% front, has the magnet and Cart 2 has the sensor and a motor with which to
% dynamically adjust its speed.

%% Setup
clear;
clf;
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
sensor_response_time = 13 * 10^-6;
% cart 2 speed range (m/s)
v_min = 0;
v_max = 0.5;
% acceleration due to friction (m/s^2), calculated from force balance
coeff_friction = 0.5;
acc_friction = coeff_friction*9.81;

%% Situational Variables
n = 3000001;
t_end = 3;
T = linspace(0, t_end, n);
dt = t_end/(n-1);
phase_delay = ceil(sensor_response_time/dt);    % # of steps in euler method to delay response by
x1 = zeros(1, n);
x2 = zeros(1, n);
v1 = zeros(1, n);
v2 = zeros(1, n);
% initial postions (m)      % measured from the magnet and the hall sensor respectively
x1(1) = 0.1;
x2(1) = 0;
% velocity of cart 1 over time

%% Animation variables
% cart dimensions (m)
cart_length = 0.1;
cart_width = 0.07;

%% Animation runtime options
% Save information
file_name = 'animated_hall_effect_experiment_3';
movie_dur = t_end;                              % s - time for movie to last
frame_dur = 0.01;                               % s - frame duration
num_frames = floor(n/(0.01/dt));                % number of frames in animation
save_animation = 1;                             % if true, save animation to file

%% Run Euler's Method
for i = 2:n
    v1(i-1) = v1fun(i, n, T);
    
    if i > 2 + phase_delay
        dist = x1(i-1-phase_delay) - x2(i-1-phase_delay);
        field_strength = getFieldStrength(dist);
        sensor_output = getSensorOutput(field_strength, sensor_null_voltage, sensor_sensitivity, sensor_up_lim, sensor_low_lim);
        if sensor_output <= 0
            v2(i-1) = v2(i-2) - acc_friction*dt;   % if sliding
        else
            v2(i-1) = v2(i-2) + setMotorAcc(sensor_output)*acc_friction*dt;     % if speed controlled directly by motor
            v2(i-1) = max(min(v2(i-1), v_max), v_min);
        end
    end
    
    instant_dist = x1(i-1) - x2(i-1);
    if instant_dist <= 0
        v2(i-1) = 0;    % stops on collision
        x2(i-1) = x1(i-1);
    end
    
    x1(i) = x1(i-1) + v1(i-1)*dt;
    x2(i) = x2(i-1) + v2(i-1)*dt;
end

%% Plot Results
figure(1)
plot(T, x1, T, x2, "LineWidth", 2)
xlabel("Time (s)")
ylabel("Position (m)")
legend("Cart 1 (independent)", "Cart 2 (speed determined by sensor)")
grid on

%% Setup Animation
figure(2)
ax1 = gca;           % store handle for axis
hold on
grid on

% Plot initial locations
cart1 = rectangle('Position', [x1(1), -cart_width/2, cart_length, cart_width], 'FaceColor', 'b');
cart2 = rectangle('Position', [x2(1)-cart_length, -cart_width/2, cart_length, cart_width], 'FaceColor', 'r');

% Add labels
title('Hall Effect Simulation')
xlabel('X (m)')
ylabel('Y (m)')

% Add axis limits so plot stays same size
ax1.XLim = [min(x2) - cart_length, max(x1) + cart_length];
ax1.YLim = [-3*cart_width, 3*cart_width];
daspect([1, 1, 1]);                  % fix 1:1 ratio for axes

%% Animate
frames{num_frames} = getframe(gcf);         % initial storage for movie frames
for j = 1:num_frames
    i = j*floor(n/num_frames);
    cart1.Position = [x1(i), -cart_width/2, cart_length, cart_width];
    cart2.Position = [x2(i)-cart_length, -cart_width/2, cart_length, cart_width];
    drawnow                     % update the plot
    
    % Store the frame. This will be written to a video file in the next cell
    if save_animation
        frames{j} = getframe(gcf);
    end
end

%% Write to file
if save_animation
        
    v = VideoWriter([file_name,'.mp4']);    %Create a video file object
    
    v.FrameRate = 1 / frame_dur;            %Set the frame rate
    
    open(v)                                 %Open video to start writing
    for i = 1:num_frames
        writeVideo(v, frames{i})             %Write frames
    end
    close(v)                                %Close video / create final file
    disp('Video Saved');
end

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

function [acc_factor] = setMotorAcc(sensor_output)
    % sensor_output: sensor output (V)
    % acc_factor: speed to set motor to accelerate cart by this amount
    % times acc_friction
    if sensor_output > 2.5492
        % if within ~1 cm, full brakes
        acc_factor = -1;
    elseif sensor_output > 2.5141
        % ~1-2 cm
        acc_factor = -0.9;
    elseif sensor_output > 2.5066
        % ~2-3 cm
        acc_factor = -0.8;
    elseif sensor_output > 2.5038
        % ~3-4 cm
        acc_factor = -0.6;
    elseif sensor_output > 2.5025
        % ~4-5 cm
        acc_factor = -0.4;
    else
        acc_factor = 1;
    end
end

function [speed] = v1fun(i, n, T)
    % i, n : on the i'th iteration out of n iterations
    % T : time vector
    % speed: set speed to [speed] m/s
    if i/n < 1/8
        speed = 0;
    elseif i/n < 1.5/8
        speed = 0.8;
    elseif i/n < 4/8
        speed = 0.1;
    elseif i/n < 0.7143
        speed = 0.25 + 0.25*sin(20*T(i-1) - 1);
    elseif i/n < 6.5/8
        speed = 0.8;
    else
        speed = 0;
    end
end

function [speed] = v1fun_2(i, n, T)
    if i/n < 0.2
        speed = 0;
    else
        speed = -0.75*(i/n - 1);
    end
end
