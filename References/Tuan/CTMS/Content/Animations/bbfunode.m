function dx = bbFUNODE(t,x)

%**************************************************************%
%This functions is to be used with the bbGUI.m and BBFUN.m     %
%files.  It contains the necessary information to run the non- %
%simulation of the ball and beam example.		               %                                %
%                                                              %
%Copyright (C) 1997 by the Regents of the University of        %
%Michigan.                                                     %
%Modified by Asst. Prof. Rick Hill (U Detroit-Mercy) and his   %
%student Li Guan.                                              %
%**************************************************************%
global K
global Nbar
global stepval
%Representation of the non-linear system.    
   dx=zeros(4,1);
   dx(1)=x(2);
   dx(2)=-5/7*(-9.8)*sin(x(3))+5/7*x(1)*x(4)^2;
   dx(3)=x(4);
   dx(4)=-K*[x(1) x(2) x(3) x(4)]'+Nbar*stepval; 

