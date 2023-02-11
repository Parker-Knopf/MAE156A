function t_s = springTorque(a, c)

    k = 0;
    s0 = 0;
    l_s = 0;
    l_rx = 0;
    l_ry = 0;

    ang = atan(l_rx / (c.l_p + l_ry));
    l_q = l_rx / sin(ang);

    s = side(l_s, l_q, a + ang);
    s_ang = angle(l_q, s, a + ang);

    t_s = k * (s-s0) * sin(s_ang) * l_s;
end