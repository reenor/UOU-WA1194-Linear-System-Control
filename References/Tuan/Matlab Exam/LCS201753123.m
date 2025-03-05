% Problem 3: Estimate the parameter a1, a2, b1, b2 and b3 using the algorithm of Recursive Least square

close all; clc; clear all

% Load data
load inout.dat -ascii

% Initial parameters
Ts = 0.1;  % sampling time
N = length(inout);
t = 0:0.1:(N-1)*0.1; % time

U = inout(:,1); 
Y = inout(:,2);

syms a1 a2 b1 b2 b3
num = [0 b1 b2 b3];
den = [1 a1 a2];
Az = den;
Bz = num;

% To get delay "d ==  num of first zeros in Bz"
d = find(Bz == 0);

B = Bz(d+1:end); % Contains [b1 b2 b3]
A = Az(2:end); % Contains [a1 a2]

nb = length(B) - 1;
na = length(A);
nu = na + nb + 1;

% Estimation
theta = zeros(nu,1); % Initial Parameters
P = 10^6 * eye(nu,nu); % Initial Covariance Matrix
phi = zeros(1,nu); % Initial phi
for i = 1 : length(U)
    [a(:,i),b(:,i)] = RecuisiveLeastSquare(U(1:i),Y(1:i),d,nb,na,P,theta,phi,i);
end

% Plot the change of parameter a1, a2, b1, b2, b3
Sa = size(a);
Sb = size(b);
colors = ['b','r','g','k'];
figure;
hold on
for m = 1:Sa(1)
    plot(t,a(m,:),'color',colors(m),'LineWidth',1.5)
    grid on
    title('The change of paramters a_i')
    xlabel('Time (s)')
    ylabel('Paramter')
end
legend('a_1','a_2')

figure;
hold on
for m = 1:Sb(1)
    plot(t,b(m,:),'color',colors(m),'LineWidth',1.5)
    grid on
    title('The change of paramters b_i')
    xlabel('Time (s)')
    ylabel('Paramter')
end
legend('b_1','b_2','b_3')

function [a, b] = RecuisiveLeastSquare(U,Y,d,nb,na,P,theta,phi,n)
% This function Identify the system parameters for a known system input and output.

% Inputs:
% U : is the system input raw vector, Y is the system output raw vector.
% d : is the delay.
% nb: is the number of zeros of the equired system model.
% na: is the number of poles of the equired system model.
% k : is the instant of time at which parameters are to be calculated.
% P, theta, phi: are the last calculated ones.

% Outputs:
% a and b are vectors of the system estimated parameters.

nu = na + nb + 1;  

for j = 1:nu
        if j <= na % terms of Y
            if (n-j)<=0
                phi(n,j) = 0;
            else
                phi(n,j) = -Y(n-j);
            end
        else       % terms of U
            if (n-d-(j-(na+1)))<=0
                phi(n,j) = 0;
            else
                phi(n,j) = U(n-d-(j-(na+1)));
            end
        end
end

% Estimation 
K = P * phi(n,:)' * inv(1 + phi(n,:) * P * phi(n,:)');
Yhat = phi(n,:) * theta;
theta = theta + K * (Y(n) - Yhat);
P = P - P * phi(n,:)' * inv(phi(n,:) * P * phi(n,:)' + 1) * phi(n,:) * P;

% Estimated System Parameters
a = theta(1:na);
b = theta(na+1:end);
end