%% Proportional (P) control using transfer function

% Given Parameters
J = 0.01;    % kgm^2
Km = 0.023;  % torque constant (Nm/A)
b = 0.00003; % Nms
R = 1;       % Ohms
L = 0.5;     % Henry

% Define the Transfer Function for the DC Motor
s = tf('s');
G_motor = Km / ( (J*s + b) * (L*s + R) + Km^2 );

% --- Unity Feedback (Closed-Loop System) ---
T1 = feedback(G_motor, 1);  % Unity negative feedback

% --- Plot the Closed-Loop Step Response ---
figure;
step(T1, 10); % Simulate for 50 seconds
title('Closed-Loop Step Response of the DC Motor');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
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
[y, t_out] = step(sys_p, 10);

% Plot
figure;
plot(t_out, y, 'b', 'LineWidth', 1.5);
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
Q = C'*C; % Penalize state deviation (e.g., speed)
R = 1;    % Penalize control effort (e.g., current)
K = lqr(A, B, Q, R);  % Compute LQR gain matrix

% Perform closed-loop system with LQR
% Control law: u(t) = -K * x(t)
AA = A - B*K; % Compute new transition matrix
sys_lqr = ss(AA, B, C, D);

% Simulate step response
[y, t_out] = step(sys_lqr, 10);

% Plot
figure;
plot(t_out, y, 'r', 'LineWidth', 1.5);
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

% Create a state-space model object
sys = ss(A, B, C, D);

% ===== Proportional (P) control =====
% Choose P gain (try Kp = 1, 5, ...)
Kp = 1;

% Perform closed-loop system with P
% Control law: u(t) = -Kp * [y(t) - r(t)]
sys_p = feedback(sys * Kp, 1);

% Simulate step response
[y_p, t_out_p] = step(sys_p, 10);

% ============ LQR control ============
% Design LQR Controller
Q = C'*C; % Penalize state deviation (e.g., speed)
R = 1;    % Penalize control effort (e.g., current)
K = lqr(A, B, Q, R);  % Compute LQR gain matrix

% Perform closed-loop system with LQR
% Control law: u(t) = -K * x(t)
AA = A - B*K; % Compute new transition matrix
sys_lqr = ss(AA, B, C, D);

% Simulate step response
[y_lqr, t_out_lqr] = step(sys_lqr, 10);

% ===========================================
% Plot both step responses on the same figure
figure;
plot(t_out_p, y_p, 'b-', 'LineWidth', 1);      % P controller in blue
hold on;
plot(t_out_lqr, y_lqr, 'r-', 'LineWidth', 1); % LQR controller in red dashed
hold off;

% Add labels and legend
xlabel('Time (s)', 'FontSize', 14);
ylabel('Angular Velocity (rad/s)', 'FontSize', 14);
title('Step Responses: P Controller vs LQR Controller');
legend('P Controller', 'LQR Controller');
grid on;







