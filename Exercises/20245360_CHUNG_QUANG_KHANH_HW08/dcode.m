% Define system
num = [1];
den = [1 1 1];
sys = tf(num, den);

% Frequencies to test (rad/s)
frequencies = [0.1 0.3 0.5 0.7 1 5 10];

% Time vector - long enough to see steady-state
t = 0:0.01:100;

% Prepare figure
figure;
for i = 1:length(frequencies)
    w = frequencies(i);
    % Input sinusoid
    u = sin(w * t);
    
    % Simulate system response
    [y, ~] = lsim(sys, u, t);
    
    % Plot input and output
    subplot(length(frequencies), 1, i)
    plot(t, u, 'b--', t, y, 'r')
    title(['Input and Output at \omega = ' num2str(w) ' rad/s'])
    xlabel('Time (s)')
    ylabel('Amplitude')
    legend('Input', 'Output')
end

%%
% Define system transfer function: H(s) = 1 / (s^2 + s + 1)
num = [1];
den = [1 1 1];
sys = tf(num, den);

% Define test frequencies (rad/s)
frequencies = [0.1 0.3 0.5 0.7 1 5 10];

% Time vector: long enough to ensure steady-state
t = 0:0.01:100;

% Initialize results
magnitudes = zeros(size(frequencies));
phases = zeros(size(frequencies));

% Loop through each frequency
for i = 1:length(frequencies)
    w = frequencies(i);                 % Frequency (rad/s)
    u = sin(w * t);                     % Input sinusoid
    [y, ~] = lsim(sys, u, t);           % System output

    % Select steady-state portion: last 5 cycles
    N_cycles = 5;
    T = 2*pi/w;                         % Period of sine wave
    idx_start = find(t > (t(end) - N_cycles*T), 1);
    t_ss = t(idx_start:end);
    u_ss = u(idx_start:end);
    y_ss = y(idx_start:end);

    % --- Magnitude calculation ---
    A_in = (max(u_ss) - min(u_ss)) / 2;   % Input amplitude
    A_out = (max(y_ss) - min(y_ss)) / 2;  % Output amplitude
    gain = A_out / A_in;
    magnitudes(i) = 20 * log10(gain);     % Convert to dB

    % --- Phase calculation using FFT ---
    U = fft(u_ss);
    Y = fft(y_ss);
    N = length(t_ss);
    fs = 1 / (t(2) - t(1));               % Sampling frequency
    f = (0:N-1)*(fs/N);                   % Frequency vector
    target_f = w / (2*pi);                % Frequency in Hz
    [~, k] = min(abs(f - target_f));      % Closest FFT bin
    H_fft = Y(k) / U(k);                  % Estimate frequency response
    phase_rad = angle(H_fft);             % Phase in radians
    phase_deg = rad2deg(phase_rad);       % Convert to degrees
    phases(i) = mod(phase_deg + 180, 360) - 180;  % Normalize to [-180, 180]
end

% --- Plot results ---
figure;

% Magnitude Plot
subplot(2,1,1);
semilogx(frequencies, magnitudes, 'b-o', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Magnitude (dB)');
title('Bode Magnitude Plot');

% Phase Plot
subplot(2,1,2);
semilogx(frequencies, phases, 'r-o', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (rad/s)');
ylabel('Phase (degrees)');
title('Bode Phase Plot');
