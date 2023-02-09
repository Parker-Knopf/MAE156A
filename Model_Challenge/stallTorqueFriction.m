function t_f = stallTorqueFriction(n, n_b, n_n)
    n_n = n_n * n_b; % define number of nuts on flywheel

    % Constants
    u = 0.11; % Dynamic friction coeficient
    f_d = 1.18 / 1000 * 100^3; % kg/m^3
    g = 9.801; % m/s^2

    % Measurements
    l_b = 6.6 / 1000; % m
    l_c = 9.9 / 1000; % m
    r_s = 2E-3; % m
    f_t = 0.18 * 0.0254; % m
    f_r = 4.5/2 * 0.0254; % m
    b_r = 0.25 * 0.0254; % m

    % Acrylic Mass
    a_r = (pi*(f_r^2))-(pi*12*(b_r^2)); % m^2
    m_acrylc = a_r*f_d*f_t; % kg

    % Masses
    m_b = 7.09 / 1000; % kg
    m_n = 3.02 / 1000; % kg
    m_hub = 65 / 1000; % kg
    m_nb = (m_b*n_b)+(m_n*n_n)+m_hub; % mass in kg of parts on flywheel
    m_fw = m_acrylc+m_nb;

    t_f = u*r_s*m_fw*g*(1+(2*(l_c/l_b)))*(1/n);
end