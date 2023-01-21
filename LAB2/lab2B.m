% Lab2B
clear all; close all; clc;

data = importdata("motor_data.csv");

time = data(:, 1) ./ 10^6; % min

% Time window
timevar2=time<=2; % Seconds for window
var2=sum(timevar2)+1;

%% Unfiltered data

% cpr
cpr = 211.2 / 4.4;
data = data(:, 2) ./ cpr;

w = zeros(length(data), 1);
for i = 1:length(data)-1
    w(i) = (data(i+1) - data(i)) / (time(i+1) - time(i));
end

w = w(:) .* 60;
plot(time(1:var2), w(1:var2));

%% Filtered data

t_f = [0.002, 0.005, 0.05];
for j = 1:length(t_f)

    wf = zeros(length(data), 1);
    for i = 2:length(data)
        b = (time(i)-time(i-1)) / (time(i)-time(i-1) + t_f(j));
        wf(i) = b* w(i) + (1 - b) * wf(i-1);
    end

    hold on;
    plot(time(1:var2), wf(1:var2))
end

title("Motor with Gearbox RPM")
xlabel("Time (s)");
ylabel("RPM");
legend("Data", "tf= .002", "tf= .005", "tf= .05", "Location", "southeast");