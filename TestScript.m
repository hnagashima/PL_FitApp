clear; clf;


t = -20:100;

% double exponential 
tau1 = rand(1)*50;
tau2 = rand(1)*5;
y = 0.5 * exp(-t/tau1) + 0.6 * exp(-t/tau2);
y(t<=0) = 0;


% instrumental function
t2 = -10:10;
c = 0; lw = 2;
irf = 1/sqrt(pi*lw)*exp(-(t2-c).^2/lw^2);

% convoluted
z = conv(y, irf,'same');
z = addnoise(z,1000000);


% plotting
% plot(t,y,t2,irf);
% ylim([0 Inf])
% hold on;
% plot(t,z);
% legend({'non-convoluted';'IRF';'convoluted'})

tau0 = [rand(1)*50 rand(1)*5];
[bestTau, bestA, yFit] = ExponFitting(tau0,t,z,irf);
semilogy(t,z,t,yFit)
ylim([0.01 1.05])

bestTau



function [bestTau, bestA, yFit] = ExponFitting(tau0,t,y,irf)

fun = @(taus) ExponConv(taus,t,y,irf);
lb = zeros(size(tau0));
bestTau = lsqnonlin(fun,tau0,lb);
% plot(t,y,t,fun(bestTau)+y)
[~,bestA,yFit] = fun(bestTau);



end


function [rasid,A,simy] = ExponConv(taus,t,y,irf)
% t, time
% y, experimental data
% irf, instrumental function
% N_taus, number of taus

% z_sum, simulation data
% z, separately calculated exponentials
% A, amplitudes
% z_sum = A * z_sep

expdata = reshape(y,1,[]);




[~,I] = max(expdata);
pos = I(1);



base = @(tau) cv(tau,irf,pos,t);

A = base(taus).'\expdata.';
A(A<0) = 0;
%plot(t,y,t,A.' * base(taus))
amp = rand(size(A))*max(y);
lb = zeros(size(A));
%A = lsqlin(base(taus).',y.',[],[],[],[],lb,[]);
simy = A.'*base(taus);
rasid = y - simy;

end

function z = cv(tau,irf,datapeak,t)
% tau: time constant
% irf: instrumental function 
% xshift: peak position of data
% L: length of data
pe = principle_exponential(tau,t);
a = zeros(size(pe) + [0, length(irf)-1]);
for k = 1:size(pe,1)
    a(k,:) = conv(pe(k,:),irf);
end

[~,I] = max(a,[],2);
pos = I(1);% peak position of simulation
tshift = pos - datapeak + 1;
%[1+tshift, (tshift+length(t))]
z = a(:,1+tshift:(tshift+length(t)));

end