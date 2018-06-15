clear; clf;


t = linspace(-20,100, 480);

% double exponential 
tau1 = 30;
tau2 = 3;
y = 0.5 * exp(-t/tau1) + 0.6 * exp(-t/tau2);
y(t<=0) = 0;


% instrumental function
t2 = -10:10;
c = 0; lw = 2;
irf = 1/sqrt(pi*lw)*exp(-(t2-c).^2/lw^2);

% convoluted
z = conv(y, irf,'same');
z = addnoise(z,200);


% plotting
% plot(t,y,t2,irf);
% ylim([0 Inf])
% hold on;
% plot(t,z);
% legend({'non-convoluted';'IRF';'convoluted'})

tau0 = [rand(1)*50 rand(1)*5]
[bestTau, bestA, yFit] = ExponFitting(tau0,t,z,irf);
semilogy(t,z,t,yFit)
ylim([0.01 max(y)+0.2])

bestTau



