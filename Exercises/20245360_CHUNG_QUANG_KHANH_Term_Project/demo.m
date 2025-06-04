%% Proportional (P) control using transfer function

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of transfer function
s = tf('s');
Gs = Ki / ( (J*s + b) * (L*s + R) + Ke * Ki );

% Choose P gain (try Kp = 1, 5, ...)
Kp = 1;

% Perform closed-loop system with P
% Control law: u(t) = -Kp * [y(t) - r(t)]
sys_p = feedback(Gs * Kp, 1);

% Simulate step response
t = 0:0.01:10;
[y_p, t_out_p] = step(sys_p, t);

% Extract performance metrics
info = stepinfo(y_p, t_out_p);

ts = info.SettlingTime; % Settling time
tp = info.PeakTime;     % Peak time
Mp = info.Overshoot;    % Max overshoot in percent

fprintf('Settling Time: %.4f s\n', ts);
fprintf('Peak Time: %.4f s\n', tp);
fprintf('Overshoot: %.2f %%\n', Mp);

% Plot
figure;
plot(t_out_p, y_p, 'b', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
title(['Step Response with Proportional Control, K_p = ', num2str(Kp)]);
grid on;

%% Proportional (P) control using state-space model

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of state-space matrices
A = [-b/J     Ki/J;
     -Ke/L   -R/L];
B = [0  1/L]';
C = [1  0];
D = 0;

% Create a state-space model object
sys = ss(A, B, C, D);

% Choose P gain (try Kp = 1, 5, ...)
Kp = 1;

% Perform closed-loop system with P
% Control law: u(t) = -Kp * [y(t) - r(t)]
sys_p = feedback(sys * Kp, 1);

% Simulate step response
t = 0:0.01:10;
[y_p, t_out_p] = step(sys_p, t);

% Extract performance metrics
info = stepinfo(y_p, t_out_p);

ts = info.SettlingTime; % Settling time
tp = info.PeakTime;     % Peak time
Mp = info.Overshoot;    % Max overshoot in percent

fprintf('Settling Time: %.4f s\n', ts);
fprintf('Peak Time: %.4f s\n', tp);
fprintf('Overshoot: %.2f %%\n', Mp);

% Plot
figure;
plot(t_out_p, y_p, 'b', 'LineWidth', 1.5);
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
title(['Step Response with Proportional Control, K_p = ', num2str(Kp)]);
grid on;

%% LQR control

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of state-space matrices
A = [-b/J     Ki/J;
     -Ke/L   -R/L];
B = [0  1/L]';
C = [1  0];
D = 0;

% Design LQR Controller
Q = diag([1, 0]); % Penalize state deviation (e.g., speed)
R = 1;    % Penalize control effort (e.g., current)
K = lqr(A, B, Q, R);  % Compute LQR gain matrix

% Perform closed-loop system with LQR
% Control law: u(t) = -K * x(t)
AA = A - B*K; % Compute new transition matrix
sys_lqr = ss(AA, B, C, D);

% Simulate step response
t = 0:0.01:10;
[y_lqr, t_out_lqr] = step(sys_lqr, t);

% Extract performance metrics
info = stepinfo(y_lqr, t_out_lqr);

ts = info.SettlingTime; % Settling time
tp = info.PeakTime;     % Peak time
Mp = info.Overshoot;    % Max overshoot in percent

fprintf('Settling Time: %.4f s\n', ts);
fprintf('Peak Time: %.4f s\n', tp);
fprintf('Overshoot: %.2f %%\n', Mp);

% Plot
figure;
plot(t_out_lqr, y_lqr, 'r', 'LineWidth', 1.5);
title('Step Response with LQR Control');
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
grid on;

%% LQR control vs Proportional (P) control

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of state-space matrices
A = [-b/J     Ki/J;
     -Ke/L   -R/L];
B = [0  1/L]';
C = [1  0];
D = 0;

% Time vector
t = 0:0.01:10;

% Create a state-space model object
sys = ss(A, B, C, D);

% ===== Proportional (P) control =====
% Choose P gain (try Kp = 1, 5, ...)
Kp = 1;

% Perform closed-loop system with P
% Control law: u(t) = -Kp * [y(t) - r(t)]
sys_p = feedback(sys * Kp, 1);

% Simulate step response
[y_p, t_out_p] = step(sys_p, t);

% ============ LQR control ============
% Design LQR Controller
Q = diag([1, 0]); % Penalize state deviation (e.g., speed)
R = 1;    % Penalize control effort (e.g., current)
K = lqr(A, B, Q, R);  % Compute LQR gain matrix

% Perform closed-loop system with LQR
% Control law: u(t) = -K * x(t)
AA = A - B*K; % Compute new transition matrix
sys_lqr = ss(AA, B, C, D);

% Simulate step response
[y_lqr, t_out_lqr] = step(sys_lqr, t);

% ===========================================
% Plot both step responses on the same figure
figure;
plot(t_out_p, y_p, 'b-', 'LineWidth', 1); % P controller in blue
hold on;
plot(t_out_lqr, y_lqr, 'r-', 'LineWidth', 1); % LQR controller in red dashed
hold off;

% Add labels and legend
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
title('Step Responses: P Controller vs LQR Controller');
legend('P Controller', 'LQR Controller');
grid on;

%% LQR Q/R Comparison

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of state-space matrices
A = [-b/J     Ki/J;
     -Ke/L   -R/L];
B = [0  1/L]';
C = [1  0];
D = 0;

% Time vector
t = 0:0.01:10;

% Definition of Q and R cases
Q_cases = {
    diag([1, 0]),        'Case 1: Penalize speed only'
    diag([1, 1]),        'Case 2: Balanced';
    diag([100, 1]),      'Case 3: Penalize speed more';
    diag([1, 1]),        'Case 4: Less control';
    diag([100, 10]),     'Case 5: Aggressive control';
};
R_cases = {
    1;          % Case 1
    1;          % Case 2
    1;          % Case 3
    10;         % Case 4
    0.01;       % Case 5    
};

% Prepare storage for stepinfo
info_list = [];

% Plot step responses
figure;
hold on;

colors = lines(length(Q_cases));  % Color for each case

for i = 1:length(Q_cases)
    Q = Q_cases{i, 1};
    R = R_cases{i};
    case_name = Q_cases{i, 2};

    % Perform closed-loop system with LQR
    % Control law: u(t) = -K * x(t)
    K = lqr(A, B, Q, R);
    AA = A - B*K;
    sys_lqr = ss(AA, B, C, D);

    % Simulate step response
    [y, t_out] = step(sys_lqr, t);

    % Get performance metrics
    info = stepinfo(y, t_out);
    info_list = [info_list; info];

    % Plot
    plot(t_out, y, 'LineWidth', 1.5, 'DisplayName', case_name, 'Color', colors(i,:));
end

xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
title('Step Responses for LQR Controllers with Various Q/R');
grid on;
legend('Location', 'best');

% Print performance summary
fprintf('\n%-35s  %10s  %10s  %10s\n', 'Case', 't_s (s)', 't_p (s)', 'M_p (%)');
for i = 1:length(info_list)
    info = info_list(i);
    fprintf('%-35s  %10.3f  %10.3f  %10.2f\n', Q_cases{i,2}, info.SettlingTime, info.PeakTime, info.Overshoot);
end

%% LQR Comparison with Reference Tracking

% Definition of DC Motor parameters
J = 0.01;      % kg.m^2
b = 0.00003;   % N.m.s/rad
Ke = 0.023;    % V.s/rad
Ki = 0.023;    % N.m/A
R = 1;         % Ohms
L = 0.5;       % H

% Computation of state-space matrices
A = [-b/J     Ki/J;
     -Ke/L   -R/L];
B = [0; 1/L];
C = [1  0];
D = 0;

% Time vector
t = 0:0.01:10;

% Definition of Q and R cases
Q_cases = {
    diag([1, 0]),        'Case 1: Penalize speed only';
    diag([1, 1]),        'Case 2: Balanced';
    diag([100, 1]),      'Case 3: Penalize speed more';
    diag([1, 1]),        'Case 4: Less control';
    diag([100, 10]),     'Case 5: Aggressive control';
};
R_cases = {
    1;          % Case 1
    1;          % Case 2
    1;          % Case 3
    10;         % Case 4
    0.01;       % Case 5    
};

% Prepare storage for performance metrics
info_list = [];

% Plot step responses
figure;
hold on;
colors = lines(length(Q_cases));  % Assign unique color to each case

for i = 1:length(Q_cases)
    Q = Q_cases{i, 1};
    R = R_cases{i};
    case_name = Q_cases{i, 2};

    % Compute LQR gain
    K = lqr(A, B, Q, R);

    % Compute reference gain for tracking
    K_tilde = -inv(C * inv(A - B*K) * B);

    % Closed-loop system with tracking input
    AA = A - B*K;
    BB = B * K_tilde;
    sys_lqr_tracking = ss(AA, BB, C, D);

    % Simulate step response
    [y, t_out] = step(sys_lqr_tracking, t);

    % Get performance metrics
    info = stepinfo(y, t_out);
    info_list = [info_list; info];

    % Plot response
    plot(t_out, y, 'LineWidth', 1.5, 'DisplayName', case_name, 'Color', colors(i,:));
end

% Label the plot
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
%title('LQR Step Responses with Reference Tracking');
yline(1, '--k', 'Desired Speed = 1 rad/s', 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
grid on;
legend('Location', 'best');

% Print summary
fprintf('\n%-35s  %10s  %10s  %10s\n', 'Case', 't_s (s)', 't_p (s)', 'M_p (%)');
for i = 1:length(info_list)
    info = info_list(i);
    fprintf('%-35s  %10.3f  %10.3f  %10.2f\n', Q_cases{i,2}, info.SettlingTime, info.PeakTime, info.Overshoot);
end
