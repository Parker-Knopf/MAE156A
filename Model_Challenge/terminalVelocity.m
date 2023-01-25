function v = terminalVelocity(data)
    n = 100;
    v = sum(data(end-n:end)) / n;
end