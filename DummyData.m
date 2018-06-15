clear; clf;
%function [t,y] = DummyData

t = -20:100;

% double exponential 
tau1 = 20;
tau2 = 3;
y = 0.5 * exp(-t/tau1) + 0.6 * exp(-t/tau2);
y(t<=0) = 0;

% instrumental function
t2 = -10:10;
c = 0; lw = 2;
irf = 1/sqrt(pi*lw)*exp(-(t2-c).^2/lw^2);

% convoluted
z = conv(y, irf,'same');

% plotting
plot(t,y,t2,irf);
ylim([1e-2 max(y)])
hold on;
plot(t,z);
legend({'non-convoluted';'IRF';'convoluted'})
