% Optimal control of DC motor using LQR
close all; clear all; clc

% Initial paramerters
J = 0.01; % Kmg.m^2/s^2
Km = 0.023; % torque constant & bacKm emf constant
b = 0.00003; % Nms
R = 1; % Ohms
L = 0.5; % Henrys

% State-space systems 
A = [-b/J   Km/J
    -Km/L   -R/L];
B = [0
    1/L];
C = [1 0];
D = 0;
sys = ss(A,B,C,D);

s = tf('s');
P_motor = Km /((J*s + b)*(L*s + R) + Km^2);

% Closed loop system
sys_cl = feedback(P_motor,1);
t = 0:0.01:10;
[yout_cl,x] = step(sys_cl,t);
figure;
plot(x,yout_cl,'b-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('Closed loop step response')

% PID control
Kp = 10; Ki = 10; Kd = 5;
Cs = pid(Kp,Ki,Kd);
sys_pid = feedback(Cs*P_motor,1);
[yout_pid,x] = step(sys_pid,t);
figure;
plot(x,yout_pid,'b-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('PID control step response')

% LQR
Q = [0.1 0; 0 0.0001];
R_opt = 0.1;
[K_opt,P_opt,e] = lqr(A,B,Q,R_opt);
sys_lqr = ss(A-B*K_opt,B,C,0);
[yout_lqr,x] = step(sys_lqr,t);
figure;
plot(x,yout_lqr,'g-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('LQR step response')

pole_opt = eig(A-B*K_opt);
Kc = place(A,B,[pole_opt(1) pole_opt(2)]);

% Compute setting time and maximum overshoot
stepinfo_cl = stepinfo(sys_cl);
stepinfo_pid = stepinfo(sys_pid);
stepinfo_lqr = stepinfo(sys_lqr);

% Compute damting ratio and time constants
[Wn,zeta] = damp(sys_cl);
tau = 1./(zeta.*Wn);

% Plot step response of all
figure;
plot(x,yout_cl,'g-')
hold on
plot(x,yout_pid,'b-')
hold on
plot(x,yout_lqr,'r-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('Step response of diferent method controls')
legend('Closed loop','PID control','LQR')

