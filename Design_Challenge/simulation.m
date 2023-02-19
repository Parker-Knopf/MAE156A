clear all; close all; clc;

v0 = 0 * (2*pi) / 60; % rad / s
v1 = 1600 * (2*pi) / 60; % rad / s
v2 = 0 * (2*pi) / 60; % rad / s

%% Angle profile
itr = 100;

a = linspace(30, 55, itr); % Min and Max angles
a = a .* 2.*pi ./ 360; % Convert angles to rad

%% Rise to 1600 RPM
w1 = linspace(0, v1, itr);

ang1 = zeros(1, itr);
for i = 1:itr
    m = zeros(1, itr);
    for j = 1:itr
        m(j) = model(a(j), w1(i), false);
    end
    ang1(i) = a(abs(m)==min(abs(m)));
end
ang1(find(ang1==a(end),1):end) = a(end);

%% Fall to 0 RPM
w2 = linspace(v1, v2, itr);

ang2 = zeros(1, itr);
for i = 1:itr
    m = zeros(1, itr);
    for j = 1:itr
        m(j) = model(a(j), w2(i), true);
    end
    ang2(i) = a(abs(m)==min(abs(m)));
end
ang2(1:find(ang2<=a(end),1)) = a(end);

m = zeros(1, itr);
%% Rise to 1600 RPM

m1 = m;
for i = 1:itr
    m1(i) = model(ang1(i), w1(i), false);
end

pop_out = w1(length(m1) - find(abs(flip(m1))<=0.01, 1));
fprintf("Pops out at: %.2f\n", pop_out)
figure(1)
plot(w1, m1)

%% Lower to 0 RPM

m2 = m;
for i = 1:itr
    m2(i) = model(ang2(i), w2(i), true);
end
pop_in = w2(find(abs(m2)<=0.01, 1));
fprintf("Pops in at: %.2f\n", pop_in)

figure(2)
plot(w2, m2)