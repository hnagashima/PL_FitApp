
function [rasid,A,simy] = ExponConv(taus,t,y,irf)
% fitting amplitude (return results)
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
pos = I(1);% peak position of the experimental data
base = @(tau) cvs(tau,irf,pos,t);
z = base(taus);
rd = zeros(size(z,3));
for k = 1:size(z,3)
    A = z(:,:,k).'\expdata.';
    A(A<0) = 0;
    rd(k) = sum(abs(y - A.' * z(:,:,k)));
end
[~,I] = min(rd);

z2 = squeeze(z(:,:,I(1)));
A = z2.'\expdata.';

simy = A.'*z2;
rasid = y - simy;

end

function z = cvs(tau,irf,datapeak,t)
% convolute and shift
% tau: time constant
% irf: instrumental function 
% xshift: peak position of data
% L: length of data

t = reshape(t,1,[]);
tdef = t; % default time

% if t(1) == 0
%     tL = fliplr(t);
%     tL(end) = [];
%     t = [-tL,tdef];
% end
tL = fliplr(2*t(1) - t);
tL(end) = [];
t = [tL,t];
%size(t)
pe = principle_exponential(tau,t);
a = zeros(size(pe) + [0, length(irf)-1]);
for k = 1:size(pe,1)
    a(k,:) = conv(pe(k,:),irf);
end

[~,I] = max(a,[],2);
I = (min(I)-5:max(I)+5).';
z = zeros([size(a,1), length(tdef), length(I)]);
for k = 1:length(I)
    pos = I(k);% peak position of simulation    
    tshift = pos - datapeak + 1;
    tshift_min = max(tshift,0);
   % [tshift, tshift_min]
    %[1+tshift, (tshift+length(t))]
    z(:,:,k) = a(:,1+tshift_min:(tshift_min+length(tdef)));
end

end