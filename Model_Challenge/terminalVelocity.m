function v = terminalVelocity(data)
    n = int32(length(data) / 4);
    v = sum(data(end-n+1:end)) / double(n);
end