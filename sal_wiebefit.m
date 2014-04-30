function [wfit] = sal_wiebefit(mfb,spk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_wiebefit - fit wiebe function to mass fraction burned curve        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_wiebefit -  version 0.9 - Jake McKenzie - mofified: 04/29/14
% 
% inputs:
%  - mfb [unitless] : mass fraction burned curve ranging from 0 to 1
%  - spk [deg bTDC] : spark timing in degrees before TDC firing
%
% outputs:
%  - wfit [struct]
%  - wfit.a         : parameter "a" in wiebe expression below
%  - wfit.n         : parameter "n" in wiebe expression below
%  - wfit.dt        : parameter "dt" in wiebe expression below
%                     1 - e^(-a*((theta_end-theta_start)/(dt)).^(n)
%                     where theta_start is the spark crank angle and
%                     theta_end is the point at which mfb curve first
%                     exceeds 0.99.
%
% notes:
%  - does not perform any error checking.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% define wiebe function (anonymously)
wiebefcn = @(w,xdata)(1-exp(-w(1)*((xdata-xdata(1))/(xdata(end)-xdata(1))).^w(2)));

%%% guess number of samples per crank angle
nsamp = length(mfb)/720;

%%% compute start and end of combustion and set curve fitting options
soci  = round(nsamp*(180-spk));
eoci  = find(mfb > 0.99,1,'first') + 10*nsamp;
opts  = optimset('lsqcurvefit');
opts  = optimset(opts,'Display','off');

%%% compute curve fit
interval = soci:eoci;
w        = lsqcurvefit(wiebefcn,[5,3],((interval-1)/nsamp)',mfb(interval),[],[],opts);

%%% assign results to output structure
wfit.a   = w(1);
wfit.n   = w(2);
wfit.dt  = (interval(end)-interval(1))/nsamp;

%%% debug
%
% figure
% plot((180-spk):1/nsamp:((180-spk)+wfit.dt),mfb(soci:(soci+wfit.dt*nsamp)),(180-spk):1/nsamp:((180-spk)+wfit.dt),wiebefcn([wfit.a wfit.n],(180-spk):1/nsamp:((180-spk)+wfit.dt)))
%
%%%