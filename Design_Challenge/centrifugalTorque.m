function t_c = centrifugalTorque(a, w, c)
    % Constants
    m_l = 0; % kg

    % Side Length
    s = side(c.l_c, c.l_p, a);

    % Torque
    t_c = m_l * w^2* s * sin(angle(c.l_p, s, a));
end