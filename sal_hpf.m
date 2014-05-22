function [Xf] = sal_hpf(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%             sal_hpf - high pass filter time resolved data               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_hpf -  version 0.92 - Jake McKenzie - mofified: 05/05/14
%
% inputs:
%  - X  : time resolved data series
%
% outputs:
%  - Xf : time resolved data that has been high-pass filtered
%
% notes:
%  - sampling frequency and cutoff frequency are hardcoded
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% configuration parameters
Fs = 100000;   % sampling freq (Hz)
Fc = 10000;     % cutoff freq (Hz)

%%% frequency range
L  = length(X);
dF = Fs/L;
f  = (-Fs/2:dF:Fs/2-dF)';

% filter
flt = (Fc < abs(f));

%%% compute fft and ifft
X     = X-mean(X);
spect = fftshift(fft(X))/L;
spect = flt.*spect;
X     = ifft(ifftshift(spect));
Xf    = sign(real(X)).*abs(X)*L;

%%% debug
%
% figure, plot(Xf)
% figure, plot(spect)
%
%%%
end