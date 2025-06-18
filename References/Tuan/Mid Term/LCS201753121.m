% Problem 1: Plot a Bode diagram with the plant
% G(s) =  = 1/(s^2 + 0.3*s +1);
close all; clear all; clc

% Initial parameters
zeta = 0.3/2; w_n = 1;
w = [0.1 0.3 0.5 0.7 0.9 1.0 1.3 1.5 1.8 2.0 2.5 3.0 5.0 7.0 10];

% Compute magnitude and phase
for i = 1:length(w)
    % Magnitude
    magitude(i) = w_n^2*((w_n^2 - w(i)^2)^2 + 4*zeta^2*w_n^2*w(i)^2)^(-1/2);
    
    % Phase
    phase(i) = -atan(2*zeta*w_n*w(i)/(w_n^2 - w(i)^2))*180/pi;
    if (phase(i) > 0)
        phase(i) = -180 + phase(i);
    end
end

% Plot a Bode diagram
figure;
subplot(2,1,1)
plot(w,20*log10(magitude));
xlabel('Fequency (rad/s)')
ylabel('Magnitude (dB)')
title('Bode Diagram')
axis([0.1 10 -40 20])
subplot(2,1,2)
plot(w,phase);
xlabel('Fequency (rad/s)')
ylabel('Phase (deg)')
axis([0.1 10 -180 0])
