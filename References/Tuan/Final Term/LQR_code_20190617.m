% Simple plant using LQR
close all; clear all; clc

% The open-loop transfer function
s = tf('s');
G = 1/(s^2 + 0.5*s + 1);

% State-space systems 
[A,B,C,D] = ssdata(G);

% Open loop system
t = 0:0.01:50;
[yout_cl,x] = step(G,t);
figure;
plot(x,yout_cl,'b-')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('Step response')

% Linear Quadratic Regulator (LQR)
Q = cell(1,3);
Q{1} = [0.1 0; 0 0.0001];
Q{2} = [0.0001 0; 0 0.1];
Q{3} = [0.1 0; 0 0.1];
R = [0.1; 0.0001];

K = zeros(6,2);
for j = 1:2
    for i = 1:3
        K(3*(j-1)+i,:) = lqr(A,B,Q{i},R(j));
    end
end

figure;
colorstring = 'rbkgmy';
for i = 1:6
    sys_lqr = ss(A-B*K(i,:),B,C,0);
    t = 0:0.01:50;
    [yout_lqr,x] = step(sys_lqr,t);
    plot(x,yout_lqr,'Color', colorstring(i))
    hold on
end
hold off;
xlabel('Time (seconds)')
ylabel('Amplitude')
grid
title('LQR step response')
legend('LQR using Q1, R1','LQR using Q2, R1','LQR using Q3, R1','LQR using Q1, R2','LQR using Q2, R2','LQR using Q3, R2')

