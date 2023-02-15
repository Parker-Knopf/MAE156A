clear all; close all; clc;

step = 30;
time = linspace(0, 29, step);

v0 = 0 * (2*pi) / 60; % rad / s
v1 = 1600 * (2*pi) / 60; % rad / s
% v2 = 1300 * (2*pi) / 60; % rad / s
v2 = 0 * (2*pi) / 60; % rad / s

vp1 = linspace(v0, v1, step);
% vp2 = linspace(v1, v2, step);
vp2 = linspace(v1, v2, step);

velocity = [vp1, vp2(2:end)];

%% Angle profile
itr = 100;

a = linspace(30, 55, itr); % Min and Max angles
a = a .* 2.*pi ./ 360; % Convert angles to rad

w = linspace(0, v1, itr);

ang = zeros(1, itr);
for i = 1:itr
    m = zeros(1, itr);
    for j = 1:itr
        m(j) = model(a(j), w(i), false);
    end
    ang(i) = a(m==min(m));
end
ang

m = zeros(1, 2*step-1);
%% Rise to 1600 RPM
a = linspace(30, 55, step); % Min and Max angles
a = a .* 2.*pi ./ 360; % Convert angles to rad

for i = 1:step
    m(i) = model(a(i), velocity(i), false);
end

%% Lower to 0 RPM
a = linspace(55, 30, step); % Min and Max angles
a = a .* 2.*pi ./ 360; % Convert angles to rad

for i = 1:step
    m(i+29) = model(a(i), velocity(i+29), true);
end

plot(m)