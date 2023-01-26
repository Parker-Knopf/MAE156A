clear all; clc; close all;
hold on;

%% Given Parameters

n_b = 8; % Qty of bolts
n_n = 2; % Qty of nuts per bolt
pwm = 100; % PWM Percent Value (100, 75, 50)
data1 = importdata(sprintf("Data/data_motor_b%d_n%d_pwm%d_t1.csv", n_b, n_n, pwm));
data2 = importdata(sprintf("Data/data_motor_b%d_n%d_pwm%d_t2.csv", n_b, n_n, pwm));

% Set frame of view (time)
t_end = 10; % s

% Gear Ratio
n = 4.43;

%% Parameters

% Stall Torque
t_s = (0.17 * 9.81 / 100); % Nm
t_s = t_s * pwm / 100; % PWM Load

% Inertia
J = inertia(n, n_b, n_n);

% Motor parameters
V_eff = 12 * pwm /100; % Effective Voltage
w_nl = 7910.21; % Pratical No-load Speed

% K = 1.39*10^-2; % Inital val
% R = 0.986; % Inital val
% w_nl = 8200 * (2*pi) / 60; % rads / s

K = 12 / (w_nl * (2*pi) / 60);
R = K * 12 / t_s;

% Pratical Terminal Velocity
w_tv = V_eff / K; % rads / s

%% Numerical Solution

% Set frame of view (time)
tspan = [0, t_end];
% Inital conditions
y0 = [0, 0];

% Numerical solution defiition
[t, y] = ode45(@(t,y) odefcn(t, y, J, t_s, w_tv, n, n_b, n_n), tspan, y0);

% Set correct units
y(:,2) = y(:,2) ./ (2*pi) * 60; % rpm

plot(t, y(:,2));

f_v = terminalVelocity(y(:,2));
t_r = riseTime(f_v, t, y(:,2));

%% Closed-Form Solution

% % Set frame of view (time)
% t = linspace(0, t_end, t_end*100);
% 
% % Closed-form Solution
% w = velocityProfile(J, t_s, w_tv); % Change inertia here
% 
% plot(t, w(t));
% 
% f_v = terminalVelocity(w(t));
% t_r = riseTime(f_v, t, w(t));

%% Theoretical Results

fprintf("Theoretical Results for %d bolts, %d nuts:\n", n_b, n_n);
fprintf("Rise Time: %.3f\n", t_r);
fprintf("Terminal Velocity: %.3f\n\n", f_v);

%% Experimental Results

[t1, wf1] = expVelocityPlot(data1);
[t2, wf2] = expVelocityPlot(data2);

f_v1 = terminalVelocity(wf1);
f_v2 = terminalVelocity(wf2);
f_v = (f_v1 + f_v2) / 2;

t_r = (riseTime(f_v1, t1, wf1) + riseTime(f_v2, t2, wf2)) / 2;

fprintf("Experimental Results for %d bolts, %d nuts:\n", n_b, n_n);
fprintf("Rise Time: %.3f\n", t_r);
fprintf("Terminal Velocity: %.3f\n\n", f_v);

hold on;
plot(t1, wf1);

%% Plot

title(sprintf("Model vs Results for %d Bolts, %d Nuts", n_b, n_n));
xlabel("Time (s)");
ylabel("RPM");
legend("Theory", "Experimental Results", "Location", "southeast");