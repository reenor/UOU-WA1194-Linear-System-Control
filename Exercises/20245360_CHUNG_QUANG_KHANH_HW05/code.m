% Given transfer function parameters
omega_n = sqrt(50);  % Natural frequency (omega_n)
zeta = 6 / (2 * omega_n);  % Damping ratio (zeta)
sigma = zeta * omega_n;  % Damping factor (sigma)
omega_d = omega_n * sqrt(1 - zeta^2);  % Damped frequency (omega_d)

% Transfer function: G(s) = 50 / (s^2 + 6s + 25)
numerator = 50;
denominator = [1 6 25];  % s^2 + 6s + 25
sys = tf(numerator, denominator);

% Time vector for simulation (0 to 5 seconds)
t = linspace(0, 5, 1000);

% Step response (y(t))
[y, t] = step(sys, t);

% Plot the step response
figure;
plot(t, y, LineWidth=1.5, Color='r');
title('Step Response of the Second Order System');
xlabel('Time (s)');
ylabel('Response');
grid on;

% Calculating Settling Time (t_s), Peak Time (t_p), and Maximum Overshoot (M_p)

% Settling time (t_s) approximation (4 / sigma)
t_s = 4 / sigma;

% Peak time (t_p) approximation (pi / (omega_n * sqrt(1 - zeta^2)))
t_p = pi / (omega_n * sqrt(1 - zeta^2));

% Maximum overshoot (M_p) approximation
M_p = exp((-zeta * pi) / sqrt(1 - zeta^2)) * 100;

%%
% Define the transfer function
num = 50;
den = [1 6 25];
sys = tf(num, den);

% Calculate system parameters
[wn, zeta] = damp(sys);  % Natural frequency and damping ratio
% Since this is a second-order system with identical poles, both values are the same
% We need to use just the first element from these arrays
wn = wn(1);  % Get first element of natural frequency array
zeta = zeta(1);  % Get first element of damping ratio array

% Calculate time-domain specifications
ts = 4/(zeta*wn);        % 2% Settling time
tp = pi/(wn*sqrt(1-zeta^2));  % Peak time
Mp = exp(-pi*zeta/sqrt(1-zeta^2))*100;  % Maximum overshoot percentage

% Display the calculated values
fprintf('Natural Frequency (wn): %.4f rad/s\n', wn);
fprintf('Damping Ratio (zeta): %.4f\n', zeta);
fprintf('Settling Time (ts): %.4f seconds\n', ts);
fprintf('Peak Time (tp): %.4f seconds\n', tp);
fprintf('Maximum Overshoot (Mp): %.4f%%\n', Mp);

% Create step response plot
figure;
t = 0:0.01:3;  % Time vector from 0 to 3 seconds
step(sys, t);
grid on;

% Add annotations to the plot
title('Step Response: G(s) = 50/(s^2 + 6s + 25)');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Add vertical lines for peak time and settling time
hold on;
stepinfo_data = stepinfo(sys);
actual_peak_time = stepinfo_data.PeakTime;
actual_settling_time = stepinfo_data.SettlingTime;

% Calculate step response data for annotations
[y, t] = step(sys, t);
final_value = y(end);
peak_value = max(y);

% Add vertical lines for peak time and settling time
line([actual_peak_time actual_peak_time], [0 peak_value], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
line([actual_settling_time actual_settling_time], [0 final_value], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);

% Add horizontal line for final value and max overshoot
line([0 t(end)], [final_value final_value], 'Color', 'k', 'LineStyle', ':', 'LineWidth', 1);
line([0 t(end)], [peak_value peak_value], 'Color', 'b', 'LineStyle', ':', 'LineWidth', 1);

% Add legend
legend('Step Response', 'Peak Time', 'Settling Time', 'Final Value', 'Maximum Overshoot');

% Add text annotations
text(actual_peak_time, peak_value*1.05, ['Peak Time = ' num2str(actual_peak_time, '%.3f') ' s']);
text(actual_settling_time, final_value*0.9, ['Settling Time = ' num2str(actual_settling_time, '%.3f') ' s']);
text(t(end)*0.7, peak_value*1.02, ['Max Overshoot = ' num2str((peak_value/final_value - 1)*100, '%.2f') '%']);
text(t(end)*0.7, final_value*0.95, ['Final Value = ' num2str(final_value, '%.2f')]);

% Optional: Create a second figure with more detailed information
figure;
step(sys, t);
grid on;
title('Step Response of the System');
xlabel('Time');
ylabel('Amplitude');

