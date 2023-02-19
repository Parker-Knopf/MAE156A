function t_s = springTorque(a, c)

%     k = 274.4;
    k = 800.4;
    s0 = 28.22 / 1000; % m
    l_s = 35 / 1000; % m
    l_rx = 5 / 1000; % m
    l_ry = 30 / 1000; % m

    ang = atan(l_rx / (c.l_p + l_ry));
    l_q = l_rx / sin(ang);

    s = side(l_s, l_q, a + ang);
    s_ang = angle(l_q, s, a + ang);

    t_s = k * (s-s0) * sin(s_ang) * l_s;
end