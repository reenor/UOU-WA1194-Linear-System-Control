% Problem 2: Design a state feed back controller and simulate with respect 
%to the following nonlinear system dynamics and initial conditions.

close all; clear all; clc

% Initial parameters
x0 = [0.05; 0; 0];
f = 0;

% Desired Pole Position
pole = [-3 -2+3i -2-3i];