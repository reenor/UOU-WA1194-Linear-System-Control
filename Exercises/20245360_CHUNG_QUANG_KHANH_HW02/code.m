% Define parameters
m = 1;
b = 4;
k = 40;

% Define the Laplace variable 's' and the transfer function H(s)
% H(s) = (b*s + k)/(m*s^2 + b*s + k) relates u(t) (road input) to x(t) (car body displacement)
s = tf('s');
H = (b*s + k) / (m*s^2 + b*s + k);

% Create a time vector for simulation
t = linspace(0, 5, 500); % from 0 to 5 seconds

% Define the road input u(t) as a unit step (1 for all t)
u = ones(size(t));

% Use lsim to simulate the time response x(t) to the road input u(t)
x = lsim(H, u, t);

% Plot the response
figure;
plot(t, x, 'LineWidth', 2);
title('Car Suspension Response using lsim');
xlabel('Time (sec)');
ylabel('x(t)');
grid on;
