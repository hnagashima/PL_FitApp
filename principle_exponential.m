function y = principle_exponential(tau,time)
% tau = [tau1, tau2, tau3,...]
% y = [y1; y2; y3;...];
% y(n,:) = exp(-t/tau(n))

t = reshape(time,1,[]);

taus = reshape(tau,1,[]);
[TAU, T] = ndgrid(taus,t);
x = -T./TAU;
y = exp(x);
y(:,t<0) = 0;
end