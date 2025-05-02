close all
% System Frequency Response Analysis
% Transfer function: H(s) = 1/(s^2 + s + 1)

% Define the system
num = 1;
den = [1 1 1];
sys = tf(num, den);

% Display the transfer function
disp('System Transfer Function:');
sys

% Define the frequencies to test (rad/s)
frequencies = [0.1, 0.3, 0.5, 0.7, 1, 5, 10];

% Time vector for simulation
t = 0:0.01:30; % 30 seconds is enough to see steady-state response

% Create a figure for all responses
figure('Position', [100, 100, 1000, 800]);

% Loop through each frequency
for i = 1:length(frequencies)
    omega = frequencies(i);
    
    % Create sinusoidal input: u(t) = sin(omega*t)
    u = sin(omega*t);
    
    % Simulate system response to the sinusoidal input
    [y, ~] = lsim(sys, u, t);
    
    % Plot input and output
    subplot(length(frequencies), 1, i);
    plot(t, u, 'b--', 'LineWidth', 1); hold on;
    plot(t, y, 'r-', 'LineWidth', 1.5);
    
    % Add grid and labels
    grid on;
    ylabel('Amplitude');
    title(sprintf('Frequency = %.1f rad/s', omega));
    legend('Input sin(ωt)', 'Output response');
    
    % Only add x-label to the bottom plot
    if i == length(frequencies)
        xlabel('Time (seconds)');
    end
    
    % Adjust axis limits to better show the response
    if omega < 1
        xlim([0, min(30, 20/omega)]); % Show enough periods
    else
        xlim([0, min(30, 10/omega)]); % Show enough periods
    end
    ylim([-1.5, 1.5]);
end

% Adjust spacing between subplots
sgtitle('System Response to Sinusoidal Inputs: H(s) = 1/(s^2 + s + 1)');

% Bode plot to show frequency response
figure('Position', [100, 100, 800, 600]);
bode(sys, frequencies);
grid on;
title('Bode Plot of System H(s) = 1/(s^2 + s + 1)');

% Plot the magnitude and phase at exactly our test frequencies
figure('Position', [100, 100, 800, 600]);

% Calculate frequency response
[mag, phase, wout] = bode(sys, frequencies);
mag = squeeze(mag);
phase = squeeze(phase);

% Create subplots
subplot(2,1,1);
semilogx(frequencies, 20*log10(mag), 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
grid on;
title('Magnitude Response at Test Frequencies');
ylabel('Magnitude (dB)');
xlim([0.09, 11]);

subplot(2,1,2);
semilogx(frequencies, phase, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 8);
grid on;
title('Phase Response at Test Frequencies');
xlabel('Frequency (rad/s)');
ylabel('Phase (degrees)');
xlim([0.09, 11]);

% Display a table of the frequency response values
disp('Frequency Response at Test Frequencies:');
disp('-----------------------------------------------------');
disp('Frequency (rad/s) | Magnitude (abs) | Magnitude (dB) | Phase (deg)');
disp('-----------------------------------------------------');
for i = 1:length(frequencies)
    fprintf('%14.1f | %14.4f | %13.4f | %10.2f\n', ...
        frequencies(i), mag(i), 20*log10(mag(i)), phase(i));
end
disp('-----------------------------------------------------');