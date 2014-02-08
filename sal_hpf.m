function [Xf] = sal_hpf(X)

Fs = 100000;   % sampling freq (Hz)
L  = length(X);
NFFT = 2^nextpow2(L);

Y  = fft(X,NFFT)/L;
f  = Fs/2*linspace(0,1,NFFT/2+1);

a  = find(f>10000 & f<50000);

Yf    = zeros(size(Y));
Yf(a) = Y(a)*L;

Xf = ifft(Yf);
Xf = real(Xf(1:length(X)));

%%% diagnostics
% figure
% plot(real(Xf))
% 
% figure
% plot(X)
end