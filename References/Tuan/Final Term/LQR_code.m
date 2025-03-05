% Optimal control of DC motor using LQR
close all; clear all; clc

% DC Motor specifications
J = 0.01; % kgm^2
Km = 0.023; % torque constant & back emf constant
b = 0.00003; % Nms
R = 1; % Ohms
L = 0.5; % Henry

% The open-loop transfer function
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

% State-space systems 
A = [-b/J   Km/J
    -Km/L   -R/L];
B = [0; 1/L];
C = [1 0];
D = 0;
sys = ss(A,B,C,D);

% Linear Quadratic Regulator (LQR)
Q = [0.1 0; 0 0.0001];
R_opt = 0.1;
[K_opt,P_opt,e] = lqr(A,B,Q,R_opt);
sys_lqr = ss(A-B*K_opt,B,C,0);
[yout_lqr,x] = step(sys_lqr,t);
figure;
plot(x,yout_lqr,'r-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('LQR step response')

pole_opt = eig(A-B*K_opt);
Kc = place(A,B,[pole_opt(1) pole_opt(2)]);

% Compute setting time and maximum overshoot
stepinfo_cl = stepinfo(sys_cl);
stepinfo_lqr = stepinfo(sys_lqr);

% Plot step response of all
figure;
plot(x,yout_cl,'b-')
hold on
plot(x,yout_lqr,'r-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('Step response of diferent method controls')
legend('Closed loop','LQR')

