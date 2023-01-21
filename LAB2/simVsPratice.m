clear all; close all; clc;

%% Parameters

n = 4.43;

J_m = 5*10^(-7); % kgm^2

h_r = 0.5 * 0.0254; % m
m_hub = 65 / 1000; % kg
J_hub = 1/2 * m_hub * h_r^2; % kgm^2

f_r = 4.5/2 * 0.0254; % m
f_t = 0.18 * 0.0254; % m
f_d = 1.18 / 1000 * 100^3; % kg/m^3
f_2r = 2 * 0.0254; % m
f_1r = 1 * 0.0254; % m
b_r = 0.25 * 0.0254; % m
J_fw = (pi * f_t * f_d) * ((1/2 * (f_r)^4) - b_r^2*(4*f_1r^2+8*f_2r^2)); % kgm^2

n_b = 8; % Qty
n_w = 0; % Qty
n_n = 16; % Qty
m_b = 7.09 / 1000; % kg
m_w = 5.95 / 1000; % kg
m_n = 3.02 / 1000; % kg
b_w = 14 / 1000; % kg
J_w = (n_b*m_b + n_w*m_w + n_n*m_n) * (1/2*b_r^2 + 1/2*f_2r^2);

J_tot = (J_hub + J_fw + J_w) / n^2 + J_m; % kgm^2

%% Data
data = importdata("motor_flywheelB_data.csv");

%% Config Data

time = data(:, 1) ./ 10^6; % min

% cpr
cpr = 211.2/4.4;
data = data(:, 2) ./ cpr;

w = zeros(length(data), 1);
for i = 1:length(data)-1
    w(i) = (data(i+1) - data(i)) / (time(i+1) - time(i));
end

w = w(:) .* 60; % RMP

t_f = 0.005;
wf = zeros(length(data), 1);
for i = 2:length(data)
    b = (time(i)-time(i-1)) / (time(i)-time(i-1) + t_f);
    wf(i) = b* w(i) + (1 - b) * wf(i-1);
end

plot(time, wf)

v = terminalVelocity(wf);
rt = riseTime(v, time, wf);
disp("Experimental Values:")
fprintf("Terminal Velocity: %.2f rads/s\n", v / 2 /pi)
fprintf("Rise Time: %.4f s\n\n", rt)

%% Theory - Motor

figure(1)
hold on;
t_end = 10;
t = linspace(0, t_end, t_end*100); % Timeframe
w = velocityProfile(J_tot); % Change inertia here

plot(t, w(t))

title("Sim vs Pratice")
xlabel("Time (s)");
ylabel("RPM");
legend("Experimental", "Theory", "Location", "southeast");

v = terminalVelocity(w(t));
rt = riseTime(v, t, w(t));
disp("Theoretical Values:")
fprintf("Terminal Velocity: %.2f rads/s\n", v / 2 /pi);
fprintf("Rise Time: %.4f s\n", rt);

%% Functions

function v = terminalVelocity(data)
    n = 100;
    v = sum(data(end-n:end)) / n;
end

function rise_t = riseTime(fv, time, data)
    val = (exp(1) -1) / exp(1);
    for i = 1:length(data)
        if data(i) >= val * fv
            rise_t = time(i);
            break
        end
    end
end

function w = velocityProfile(J)
    W_nl = 8200 * 2*pi / 60; %Rad/s
    T_s = 0.17 * 9.81 / 100; %Nm

    tr = W_nl * J / T_s;
    w = @(t) W_nl * (1 - exp(-t/tr)) / (2*pi) * 60;
end