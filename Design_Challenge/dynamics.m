clear all; clc; close all;

% Spring Anchor
s = [30, 5.5, 0];

% Wing Spring Moment Arm
c = [-11, 35, 0];

% Piviot Point
p = [0 35, 0];

com = [-20, 27, 0];

k = 200;
x_nom = 20;
x = sqrt(sum((c-s).^2)) - x_nom;
f_s = k * x;
a = f_s.*normalize(p-c)
b = s-c
m_s = cross(a,b)