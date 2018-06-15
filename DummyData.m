clear; close all;
%function [t,y] = DummyData

t = -20:100;

% double exponential 
tau1 = 20;
tau2 = 3;
y = 0.5 * exp(-t/tau1) + 0.5 * exp(-t/tau2);
y(t<=0) = 0;

% instrumental function
c = 0; lw = 2;
irf = 1/sqrt(pi*lw)*exp(-(t-c).^2/lw^2);

% convoluted
z = conv(irf, y);

% plotting
semilogy(t,y,t,irf);
ylim([1e-2 max(y)])
hold on;
plot(z);
