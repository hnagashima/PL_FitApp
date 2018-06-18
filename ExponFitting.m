function [bestTau, bestA, yFit] = ExponFitting(tau0,t,expy,irf)
% [bestTau, bestA, yFit, iGuess] = ExponFitting(tau0,t,y,irf)

% tau0, initial parameter
% t, time
% y, experimental data
% irf, instrumental function
y = reshape(expy,1,[]);
fun = @(taus) ExponConv(taus,t,y,irf);
lb = zeros(size(tau0));
bestTau = lsqnonlin(fun,tau0,lb);
% plot(t,y,t,fun(bestTau)+y)
[~,bestA,yFit] = fun(bestTau);

bestA = reshape(bestA,[],1);
bestTau = reshape(bestTau,[],1);

end

