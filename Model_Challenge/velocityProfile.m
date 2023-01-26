function w = velocityProfile(J, t_s, w_tv)
    % Return velocity profile of motor with J inertia, t_s stall torque,
    % and w_nl no load speed
    tr = w_tv * J / t_s;
    w = @(t) w_tv * (1 - exp(-t/tr)) / (2*pi) * 60;
end