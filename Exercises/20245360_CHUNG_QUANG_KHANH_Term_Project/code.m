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
step(T1, 50); % Simulate for 50 seconds
title('Closed-Loop Step Response of the DC Motor');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
grid on;

%%
% Given Parameters
J = 0.01;    % kgm^2
Km = 0.023;  % torque constant (Nm/A)
b = 0.00003; % Nms
R = 1;       % Ohms
L = 0.5;     % Henry

% State-Space Representation of the DC Motor (provided)
A = [-b/J   Km/J;
     -Km/L  -R/L];  % State matrix
B = [0; 1/L];      % Input matrix
C = [1 0];         % Output matrix (angular velocity)
D = 0;             % No direct feedthrough

% Convert to state-space system
sys_ss = ss(A, B, C, D);

% --- LQR Controller Design ---
Q = C'*C;    % State cost matrix (penalize angular velocity)
R = 1;       % Control cost matrix (penalize input voltage)
K = lqr(A, B, Q, R);  % Compute the LQR gain

% --- Closed-Loop System with LQR ---
Acl = A - B*K;  % New A matrix for closed-loop system
Bcl = B;        % Same B matrix as before
Ccl = C;        % Same C matrix as before
Dcl = D;        % Same D matrix as before
sys_lqr = ss(Acl, Bcl, Ccl, Dcl);  % Closed-loop system

% --- Plot Step Response ---
figure;
step(sys_lqr, 50);  % Simulate for 50 seconds
title('Closed-Loop Step Response with LQR Control');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
grid on;
