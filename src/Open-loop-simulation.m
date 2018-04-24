clear all
close all

% Create time vector (Discretized system)
DeltaT = 0.01;            % Time step size [sec]
t = 0:DeltaT:(2*60*60);   % Total Simulation time (hour*min*sec/min)

% Input current signals]
Current = zeros(size(t))';      % Size of Current
Current(mod(t,800) < 700) = -2.3/2;   % 700sec 0.5C pulse discharge
% Current = -2.3/2 * ones(size(t))';  % 20sec 5A pulse discharge

figure
plot(t,Current)
xlabel('Time (sec)')
ylabel('Current')
title('Input')

% Iuput outside temperature 

Tf = ones(size(t))';     
Tf = Tf * 23.15 + sin(t'/size(t,2)*100*pi);   % 20sec 5A pulse discharge

figure
plot(t,Tf)
xlabel('Time (sec)')
ylabel('Temperature')
title('Input')


input_data = [t' Current Tf];
states0 = [0;0;0; 23.15; 23.15;1];

[tsim,states] = ode45(@(t,x) ode1(t,x,input_data),t,states0);

SOC = states(:,1) * 100;
Tc = states(:,4);
Ts = states(:,5);
SOH = states(:,6) * 100;

figure
plot(t,SOC)
xlabel('Time (sec)')
ylabel('SOC [%]')
title('SOC')

figure
plot(t,Tc)
xlabel('Time (sec)')
ylabel('Temperature [0C]')

hold on
plot(t,Ts)
title('Temperature changing')
legend('core','surface')

figure
plot(t,SOH)
ylim([99.99 100])
xlabel('Time [sec]')
ylabel('SOH [100%]')
title('SOH')
