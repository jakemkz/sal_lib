function [Xf] = sal_hpf(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%             sal_hpf - high pass filter time resolved data               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_hpf -  version 0.91 - Jake McKenzie - mofified: 04/29/14
%
% inputs:
%  - X  : time resolved data series
%
% outputs:
%  - Xf : time resolved data that has been high-pass filtered
%
% notes:
%  -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fs = 100000;  % sampling freq (Hz)
Fc = 10000;   % cutoff freq (Hz)

L  = length(X);
NFFT = 2^nextpow2(L);

Y  = fft(X,NFFT)/L;
f  = Fs/2*linspace(0,1,NFFT/2+1);

a  = find(f>Fc & f<(Fs/2));

Yf    = zeros(size(Y));
Yf(a) = Y(a)*L;

Xf = ifft(Yf);
Xf = real(Xf(1:length(X)));

%%% 
%
% diagnostics
%
%%%

% figure, plot(real(Xf))
end