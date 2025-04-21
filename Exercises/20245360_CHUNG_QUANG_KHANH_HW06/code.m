% Second-order system step response with ωn = 1, ζ = 0.5
clear all; close all;

% System parameters
wn = 1;   % Natural frequency
zeta = 0.5;  % Damping ratio

% Create transfer function
num = wn^2;
den = [1 2*zeta*wn wn^2];  % s^2 + 2*zeta*wn*s + wn^2
sys = tf(num, den);

% Calculate important metrics
% Settling time (2% criterion)
ts = 4/(zeta*wn);  % For 2% criterion, ts = 4/(zeta*wn)

% Peak time
wd = wn*sqrt(1-zeta^2);  % Damped natural frequency
tp = pi/wd;

% Peak overshoot (percentage)
Mp_percentage = 100*exp(-pi*zeta/sqrt(1-zeta^2));
Mp_actual = 1 + Mp_percentage/100;  % The actual peak value

% Step response simulation
t = 0:0.01:15;  % Time vector
[y, t] = step(sys, t);

% Plot
figure;
plot(t, y, 'LineWidth', 1.5);
hold on;
grid on;

% Mark settling time (2% band)
plot([0 ts], [1.02 1.02], 'r--');
plot([0 ts], [0.98 0.98], 'r--');
plot([ts ts], [0 1], 'r--');
text(ts+0.2, 0.3, ['t_s = ' num2str(ts, 3) ' s'], 'FontSize', 10);

% Mark peak time and overshoot
plot([tp tp], [0 Mp_actual], 'g--');
plot([0 tp], [Mp_actual Mp_actual], 'g--');
text(tp+0.2, Mp_actual+0.05, ['t_p = ' num2str(tp, 3) ' s'], 'FontSize', 10);
text(tp/2, Mp_actual+0.05, ['M_p = ' num2str(Mp_percentage, 3) '%'], 'FontSize', 10);

% Add circle at the peak
plot(tp, Mp_actual, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Add labels
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Step Response of Second-Order System with \omega_n = 1, \zeta = 0.5');
legend('Step Response', 'Location', 'best');

% Add annotations for key metrics in text box
annotation('textbox', [0.15, 0.15, 0.3, 0.15], 'String', ...
    {['Natural frequency \omega_n = ' num2str(wn)], ...
     ['Damping ratio \zeta = ' num2str(zeta)], ...
     ['Settling time t_s = ' num2str(ts, 3) ' s'], ...
     ['Peak time t_p = ' num2str(tp, 3) ' s'], ...
     ['Percent overshoot M_p = ' num2str(Mp_percentage, 3) '%']}, ...
     'EdgeColor', 'none', 'BackgroundColor', [0.9 0.9 0.9]);