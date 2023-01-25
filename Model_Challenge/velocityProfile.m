function w = velocityProfile(J, t_s, w_nl)
    % Return velocity profile of motor with J inertia, t_s stall torque,
    % and w_nl no load speed
    tr = w_nl * J / t_s;
    w = @(t) w_nl * (1 - exp(-t/tr)) / (2*pi) * 60;
end