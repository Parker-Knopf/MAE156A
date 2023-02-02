clear all; close all; clc;

config = [[8, 2]; [4, 1]; [2, 1]; [4, 2]];
pwm = [100, 75, 50];

plot = false;

if (plot)
    subplot(length(config),length(pwm),1)
end
jma=[1.0*10^(-7),1.5*10^(-7),2.0*10^(-7),2.5*10^(-7),3.0*10^(-7),3.5*10^(-7),4.0*10^(-7),4.5*10^(-7),5.0*10^(-7),5.5*10^(-7)];
mewa=[0.12,0.13,0.14,0.15,0.16,0.17,0.18,0.19,0.20,0.21];
cda=[18,19,20,21,22,23,24,25,26,27];
o=1;
p=1;
s = zeros(length(config), length(pwm));
for i = 1:length(config)
    for j = 1:length(pwm)
        for k=1:10
            for l=1:10
                for m=1:10
                    if (plot)
                        subplot(length(config),length(pwm), length(pwm)*(i-1) + j)
                    end
                    Jm=jma(m);
                    mew=mewa(l);
                    Cad=cda(k);

                    s(p,o) = modelConfig(config(i, 1), config(i, 2), pwm(j), plot,mew,Jm,Cad);
                    p=p+1;
                end
            end
        end
        p=1;
        o=o+1;
    end 
end

if (plot)
    sgtitle("All Configurations: Model vs Results")
end
for i=1:1000
    b(i) = mean(s(i,:));
end



%fprintf("Model Accuracy: %.3f\n", b);
