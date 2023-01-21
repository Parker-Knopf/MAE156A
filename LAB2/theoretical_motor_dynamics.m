 % Theoretical Motor Dynamics
clear all; close all; clc;

%% Parameters

J_m = 5*10^(-7); % kgm^2

Hub_r = 0.5 * 0.0254; % m
Hub_w = 65 / 1000; % kg
J_Hub = 1/2 * m_hub * h_r^2; % kgm^2

f_r = 4.5/2 * 0.0254; % m
f_t = 0.18 * 0.0254; % m
f_d = 1.18 / 1000 * 100^3; % kg/m^3
f_2r = 2 * 0.0254; % m
f_1r = 1 * 0.0254; % m
J_fw = (pi * f_t * f_d) * ((1/2 * (f_r)^4) - b_r^2*(4*f_1r^2+8*f_2r^2)); %Kgm^2

n_b = 8; % Qty
n_w = 0; % Qty
n_n = 16; % Qty
m_b = 7.09 / 1000; % kg
m_w = 5.95 / 1000; % kg
m_n = 3.02 / 1000; % kg
b_w = 14 / 1000; % kg
b_r = 0.25 * 0.0254; % m
J_w = (n_b*m_b + n_w*m_w + n_n*m_n) * (1/2*b_r^2 + 1/2*f_2r^2);

%% Motor

figure(1)
t = linspace(0, .5, 100);
w = velocityProfile(J_m);

plot(t, w(t))

title("Motor")
xlabel("Time (s)")
ylabel("Angular Rotation (rpm)")

%% Motor with Flywheel

figure(2)
t = linspace(0, 200, 20000);
w = velocityProfile(J_m + J_fly + J_Hub);

plot(t, w(t))

title("Motor with Flywheel")
xlabel("Time (s)")
ylabel("Angular Rotation (rpm)")

%% Functions

function w = velocityProfile(J)
    W_nl = 8200 * 2*pi / 60; %Rad/s
    T_s = 0.17 * 9.81 / 100; %Nm

    tr = W_nl * J / T_s;
    w = @(t) W_nl * (1 - exp(-t/tr)) / (2*pi) * 60;
end