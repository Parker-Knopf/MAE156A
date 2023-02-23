clear all; clc; close all;

% Spring Anchor
s0 = [36.5; 16.5; 0];

% Wing Spring Moment Arm
inc = 30;
s1 = [linspace(-17.599, -24.439, inc); linspace(39.277, 20.483, inc); zeros(1, inc)];
s2 = [linspace(-15.595, -27.604, inc); linspace(44.208, 28.215, inc); zeros(1, inc)];

% Piviot Point
p = [0; 35; 0];

% Com
com1 = [-20; 26; 0];
com2 = [-22.5; 32; 0];

% Constants
k = 1850;
x_nom = 20;
minRPM = 0 * 2 * pi / 60; % rads / s
maxRPM = 1800 * 2 * pi / 60; % rads / s
step = .5;

%% Phase 1

PopOut = zeros(inc, 1);
for i = 1:length(s1)
    s_x = norm(s1(:,i)-s0);
    
    s = (s1(:,i) - s0);
    rs = (s1(:,i) - p);
    
    rp = (com1 - p);
    rc = (com1);
    
    m = zeros(length(minRPM:step:maxRPM), 1);
    w = minRPM:step:maxRPM;
    for j = 1:length(w)
        m(j) = torqueC(w(j), rc, rp) - torqueS(k, s, s_x, x_nom, rs);
    end
    PopOut(i) = w(find(m>0, 1))*60/2/pi;
end

%% Phase 2

PopIn = zeros(inc, 1);
for i = 1:length(s2)
    s_x = norm(s2(:,i)-s0);
    
    s = (s2(:,i) - s0);
    rs = (s2(:,i) - p);
    
    rp = (com2 - p);
    rc = (com2);
    
    m = zeros(length(minRPM:step:maxRPM), 1);
    w = minRPM:step:maxRPM;
    for j = 1:length(w)
        m(j) = torqueC(w(j), rc, rp) - torqueS(k, s, s_x, x_nom, rs);
    end
    PopIn(i) = w(find(m>0, 1))*60/2/pi;
end

%% Optimize

e = 3 * abs(PopOut(:) - PopIn(:) - 300) + abs(PopOut - 1600);
e_min = min(e);
ind = find(e==e_min);

fprintf("Minimum Error Meteric: %.2f\n---------------------------------\n", e_min)
fprintf("Pop-out Angular Velocity: %.2f RPM\n", PopOut(ind));
fprintf("Pop-in Angular Velocity: %.2f RPM\n", PopIn(ind));
fprintf("Location of spring on wing: (x,y) (%.2f,%.2f)\n", s1(1, ind), s1(2, ind));

%% Spring

function t = torqueS(k, s, x, x_nom, r_s)
    t = cross(forceS(k, s, x, x_nom), r_s);
    t = t(3);
end

function f = forceS(k, s, x, x_nom)
    f = k * (x - x_nom);
    f = f .* normVector(s);
end

%% Centrifugal Force

function t = torqueC(w, rc, rp)
    t = cross(forceC(w, rc), rp);
    t = t(3);
end

function f = forceC(w, r)
    m = .05;
    f = m * w^2 * norm(r);
    f = f .* normVector(r);
end

%% functions

function v = normVector(v)
    v = v./norm(v);
end