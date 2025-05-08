% LQG Control Simulation for Wind Turbines
% Based on the paper "Linear Quadratic Gaussian (LQG) Control of Wind Turbines"
% by Abdulrahman Kalbat

clear all; close all; clc;

% System matrices from the paper - CART 3-state model
A = [-1.4454e-1, -3.1078e-6, 0.0;
     2.6910e7, 0.0, -2.6910e7;
     0.0, 1.5601e-5, 0.0];
 
B = [-3.4559; 0.0; 0.0];

C = [0, 0, 1]; % Only generator speed is measured

G = [7.8938e-2; 0.0; 0.0]; % Turbine system noise gain matrix

% Check controllability and observability
disp('Checking controllability:')
controllability = rank(ctrb(A,B));
if controllability == size(A,1)
    disp('System is controllable')
else
    disp('System is not controllable')
end

disp('Checking observability:')
observability = rank(obsv(A,C));
if observability == size(A,1)
    disp('System is observable')
else
    disp('System is not observable')
end

% Define noise covariances
W = 0.1; % Turbine system noise covariance
V = 0.1; % Measurement noise covariance

% LQG Design - First calculate Kalman filter gain
[kalmf,L,P] = kalman(ss(A,[B G],C,0),W,V);
Kk = P*C'*inv(V); % Optimal state estimation gain
disp('Kalman filter gain:')
disp(Kk)

% Define weighting matrices for LQR design
Qf = [1 0 0; 0 1e-13 0; 0 0 1];
Rf = 1;

% Calculate LQR gain
[Kf,S,e] = lqr(A,B,Qf,Rf);
disp('LQR gain:')
disp(Kf)

% Create the open-loop system
sys_ol = ss(A,B,C,0);

% Create the closed-loop LQG system
A_cl = [A-B*Kf, B*Kf; 
        zeros(size(A)), A-Kk*C];
B_cl = [G, zeros(size(B,1),1);
        G, Kk];
C_cl = [C, zeros(1,size(A,1))];  % Fixed dimension issue
D_cl = zeros(1,2);

sys_cl = ss(A_cl,B_cl,C_cl,D_cl);

% Time simulation parameters
t = 0:0.1:70;
sim_time = length(t);

% Create step wind speed inputs varying from 14 m/s to 20 m/s
wind_speed = zeros(sim_time,1);
wind_speed(1:100) = 14;
wind_speed(101:200) = 15;
wind_speed(201:300) = 16;
wind_speed(301:400) = 17;
wind_speed(401:500) = 18;  % Control design point (18 m/s)
wind_speed(501:600) = 19;
wind_speed(601:701) = 20;

% Create white noise for the system and measurement
rng(42); % Set random seed for reproducibility
w_noise = randn(sim_time,1)*sqrt(W);
v_noise = randn(sim_time,1)*sqrt(V);

% Create the input matrix for simulation
u_sim = [w_noise, v_noise];

% Simulate the open-loop and closed-loop responses
[y_ol, t_ol, x_ol] = lsim(sys_ol, w_noise.*G(1), t);
[y_cl, t_cl, x_cl] = lsim(sys_cl, u_sim, t);

% Calculate pitch angle (control input) for closed-loop system
pitch_angle = zeros(sim_time,1);
for i = 1:sim_time
    % Extract the estimated states
    x_est = x_cl(i,4:6)';
    % Calculate the control input using LQR gain
    pitch_angle(i) = -Kf*x_est;
end

% Converting generator speed to RPM (assuming rad/s to RPM conversion)
% The paper indicates 42 RPM at the operating point
y_ol_rpm = y_ol * (60/(2*pi)) + 42;  % Adding offset to center around 42 RPM
y_cl_rpm = y_cl * (60/(2*pi)) + 42;  % Adding offset to center around 42 RPM

% Plot the results
figure(1);

% Plot wind speed
subplot(3,1,1);
plot(t, wind_speed);
title('Wind Speed (m/s)');
grid on;
ylabel('Speed (m/s)');
xlim([0 70]);

% Plot generator speed
subplot(3,1,2);
plot(t, y_ol_rpm, 'b', t, y_cl_rpm, 'r');
title('Generator Speed (RPM)');
grid on;
ylabel('Speed (RPM)');
legend('Open-loop', 'Closed-loop');
xlim([0 70]);

% Plot pitch angle
subplot(3,1,3);
plot(t, pitch_angle+12);  % Adding 12 degrees offset (operating point)
title('Pitch Angle (degrees)');
grid on;
ylabel('Angle (deg)');
xlabel('Time (sec)');
xlim([0 70]);

% Plot poles and zeros of the closed-loop system
figure(2);
pzmap(sys_cl);
title('Poles/Zeros Plot of the Closed-loop System');
grid on;

% Create Bode plots comparing open-loop and closed-loop systems
figure(3);
bode(sys_ol, 'b', sys_cl, 'r');
title('Bode Plot of Open-loop and Closed-loop Systems');
legend('Open-loop', 'Closed-loop');
grid on;

% Add more detailed analysis - step response
figure(4);
step(sys_ol, 'b', sys_cl(:,1), 'r', t);
title('Step Response Comparison');
legend('Open-loop', 'Closed-loop (From System Noise)');
grid on;

% Impulse response
figure(5);
impulse(sys_ol, 'b', sys_cl(:,1), 'r', t(1:200));
title('Impulse Response Comparison');
legend('Open-loop', 'Closed-loop (From System Noise)');
grid on;

% Time domain metrics
disp('Time domain metrics:');
info_ol = stepinfo(sys_ol);
info_cl = stepinfo(sys_cl(:,1));

fprintf('Open-loop rise time: %.4f seconds\n', info_ol.RiseTime);
fprintf('Closed-loop rise time: %.4f seconds\n', info_cl.RiseTime);
fprintf('Open-loop settling time: %.4f seconds\n', info_ol.SettlingTime);
fprintf('Closed-loop settling time: %.4f seconds\n', info_cl.SettlingTime);
fprintf('Open-loop overshoot: %.4f%%\n', info_ol.Overshoot);
fprintf('Closed-loop overshoot: %.4f%%\n', info_cl.Overshoot);