close all;clear;clc;
%% Retrieve Data File + Simulated Values
filename = input('File Name:','s');
%%Record simulated value

n_trials = 1; %this version of the code is meant for testing only one data set at a time.
sim_terminal_V=zeros(1,n_trials);
sim_trise=zeros(1,n_trials);
for i=1:n_trials
        %record simulated value
        prompt_str_1 = sprintf('Simulated terminal velocity(RPM) for config%i : ', i);
        prompt_str_2 = sprintf('Simulated risetime(s) for config%i : ', i);
        sim_terminal_V(i) = str2double(input(prompt_str_1,'s'));
        sim_trise(i) = str2double(input(prompt_str_2,'s'));
end
%% Calculate experimental terminal velocity and risetime
%initialize array
exp_terminal_V = zeros(1,n_trials);
exp_trise = zeros(1,n_trials);
D = cell(1,n_trials);
wfi = cell(1,n_trials);
time = cell(1,n_trials);
%set filtering constant
t=0.01; %{s}

%import data
for i=1:n_trials
    D{i}= importdata(filename);
end

%process data
%
for i=1:n_trials
    
    
    %experimental data
    time{i} = D{i}(:,1)/10^6; %{s}time data
    count = abs(1*D{i}(:,2));%Encoder count
    %determining motor initation time (the time encoder count remains zero)
    true_motor_start_time_index = length(find(count == 0));
    time_shift = time{i}(true_motor_start_time_index);
    time{i} = time{i}(true_motor_start_time_index:end) - time_shift;
    count = count(true_motor_start_time_index:end);
    %continue using modified more accurate hisotry data

    rot = count/48;  %{motor shaft rotation} position data in rotation
    wfi{i}=zeros(1,length(time{i}));  %initialize array of filtered velocity (omega_filtered)
    for j=2:length(time{i})
        %apply 1st order filter to calculate filtered velocity
        wfi{i}(j)=(rot(j)-rot(j-1)+t*wfi{i}(j-1))/(time{i}(j)-time{i}(j-1)+t);%{rps}filtered velovity
    end
    wfi{i}=wfi{i}*60;%{RPM}experimental rotational velocity on rotor

    %find experimental terminal velocity and risetime
    exp_terminal_V(i) = mean(wfi{i}(end-100:end));%{RPM} averaging the last 100 data point of a 10sec run. This should be when terminal velocity is reached. 
    exp_trise(i) = time{i}(find(wfi{i}>=0.63*exp_terminal_V(i),1));%{s}

    fprintf('Experimental Terminal Velocity for config %1d = %.4f \n', i, exp_terminal_V(i))
    fprintf('Experimental Rise Time for config %1d = %.4f \n', i,  exp_trise(i))
end

%%








%% calculate error metric
%initialize array
error_metric = zeros(1,n_trials);
fprintf('\n');
%calculate error
for i=1:n_trials
    e_V = abs(exp_terminal_V(i)-sim_terminal_V(i))/exp_terminal_V(i);
    e_T = abs(exp_trise(i)-sim_trise(i))/exp_trise(i);
    error_metric(i)=(e_V+e_T)*100;% percent error
    fprintf('Error metric for config %1d = %.4f %%\n', i,error_metric(i))
end
    avg_error_metric = mean(error_metric);
    fprintf('\nAverage error metric = %.4f %%\n', avg_error_metric)
    %ax = gca;
    %exportgraphics(ax,sprintf('Tau_Comparison.jpg'));
%% Plot velocity vs time
%Config plot style
figure(1);hold on;
color = ['b','y'];set(gca,'color',[0.6,0.6,0.6]);
for i=1:n_trials
    %Set plot color for each config
    plotstyle=strcat('-',color(i));
    
    %plot terminal velocity
    ylinepos= {'left','right','center'};
    xlinepos = {'top','top','bottom'};
    Terminal_v_labels = sprintf('V_t = %.f RPM',mean(wfi{i}(end-100:end)));
    yline(mean(wfi{i}(end-50:end)),plotstyle, Terminal_v_labels,'LabelHorizontalAlignment',ylinepos{i},'LabelVerticalAlignment',xlinepos{i});
    
    %Plot Risetime
    t_rise_labels = sprintf('T_r = %.4f s',exp_trise(i));
    xlinepos = {'top','middle','bottom'};
    xline(exp_trise(i),plotstyle, t_rise_labels,'LabelOrientation','horizontal','LabelVerticalAlignment',xlinepos{i},'LabelHorizontalAlignment','right');
    
    %Plot TvsV
    tvplot(i)=plot(time{i},wfi{i},plotstyle);
end
    xlabel('Time(s)');ylabel('Velocity(RPM)');
    title(sprintf('Filtered Velocity VS Time'));
    axis([0 10 0 9000]);