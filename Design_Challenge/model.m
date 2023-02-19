function m = model(a, w, retract)
    % Geometric Constants
    
    c.l = 63 / 1000; % m
    c.l_c = 26.719 / 1000; % m
    c.l_p = 25 / 1000; % m
    
    % Constant Friction Force
    t_f = 0; % N-m

    % Non-linear Friction Hook Torque
    t_fh = .1; % N-m

%     m = centrifugalTorque(a, w, c) + dragTorque(a, w, c) - springTorque(a, c) - t_f;
    m = centrifugalTorque(a, w, c) - springTorque(a, c) + t_f;

    if (retract)
        m = m + t_fh;
    end
end