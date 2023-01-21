% Lab2B
clear all; close all; clc;

%% Parameters

J_m = 5*10^(-7); %kgm^2

Fly_r = 4.5/2 * 0.0254; %m
Fly_t = 0.18 * 0.0254; %m
Fly_d = 1.18 / 1000 * 100^3; %kg/m^3
Fly_w = 14 / 1000; %kg
Fly_wr = 0.25 * 0.0254; %m
Fly_wr2 = 2 * 0.0254; %m
Fly_wr1 = 1 * 0.0254; %m

Hub_r = 0.5 * 0.0254; %m
Hub_w = 65 / 1000; %kg
J_Hub = 1/2 * Hub_w * Hub_r^2; %kgm^2

J_fly = (pi * Fly_t * Fly_d) * ((1/2 * (Fly_r)^4) - 4*(Fly_wr^2*Fly_wr1^2) - 8*(Fly_wr^2*Fly_wr2^2)) + 8*(Fly_w*Fly_wr2^2); %Kgm^2

%% Data
dataA = importdata("motor_flywheelA_data.csv");
dataB = importdata("motor_flywheelB_data.csv");

%% Config Data

config = {dataC, dataC2};
for j = 1:length(config)

    data = cell2mat(config(j));
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
    
    figure(j)
    plot(time, wf)

end

%% Theory - Motor

figure(1)
hold on;
t = linspace(0, .5, 100);
w = velocityProfile(J_m);

plot(t, w(t))

title("Compare Config A with theory")
xlabel("Time (s)");
ylabel("RPM");
legend("ConfigA", "A Theory", "Location", "southeast");

%% Theory - Motor with Flywheel

figure(2)
hold on;
t = linspace(0, 200, 20000);
w = velocityProfile(J_m + J_fly + J_Hub);

plot(t, w(t))

title("Compare Config B with theory")
xlabel("Time (s)");
ylabel("RPM");
legend("ConfigB", "B Theory", "Location", "southeast");

%% Functions

function w = velocityProfile(J)
    W_nl = 8200 * 2*pi / 60; %Rad/s
    T_s = 0.17 * 9.81 / 100; %Nm

    tr = W_nl * J / T_s;
    w = @(t) W_nl * (1 - exp(-t/tr)) / (2*pi) * 60;
end