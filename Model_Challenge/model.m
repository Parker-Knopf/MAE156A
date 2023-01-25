clear all; clc; close all;
hold on;

%% Given Parameters

n_b = 8; % Qty of bolts
n_n = 1; % Qty of nuts per bolt
pwm = 255; % PWM Value
data = importdata("Data/motor_data_b8_n2_t1.csv");

% Set frame of view (time)
t_end = 10; % s

% Gear Ratio
n = 4.43;

%% Parameters

% Stall Torque
t_s = (0.17 * 9.81 / 100); % Nm
t_s = t_s * pwm / 255; % PWM Load
t_s = t_s - stallTorqueFriction(n_b, n_n, t_s);

% Inertia
J = inertia(n, n_b, n_n);

% No load speed
w_nl = 8200 * (2*pi) / 60; % rads / s

%% Numerical Solution

% % Set frame of view (time)
% tspan = [0, t_end];
% % Inital conditions
% y0 = [0, 0];
% 
% % Numerical solution defiition
% [t, y] = ode45(@(t,y) odefcn(t, y, J_m, t_s, w_nl), tspan, y0);
% 
% % Set correct units
% ts = t(:) .* 1000; % ms
% y(:,2) = y(:,2) ./ (2*pi) * 60; % rpm
% 
% plot(ts, y(:,2));

%% Closed-Form Solution

% Set frame of view (time)
t = linspace(0, t_end, t_end*100);

% Closed-form Solution
w = velocityProfile(J, t_s, w_nl); % Change inertia here

plot(t, w(t));

%% Experimental Results

[t, wf] = expVelocityPlot(data);

hold on;
plot(t, wf);

%% Plot

title(sprintf("Model vs Results for %d Bolts, %d Nuts", n_b, n_n));
xlabel("Time (s)");
ylabel("RPM");
legend("Theory", "Experimental Results", "Location", "southeast");