function [wfit] = sal_wiebefit(mfb,spk)

% spk is deg bTDC firing

%%% fit wiebe function to mass of fuel burned curve

%%% wiebe fitting
wiebefcn = @(w,xdata)(1-exp(-w(1)*((xdata-xdata(1))/(xdata(end)-xdata(1))).^w(2)));

nsamp = length(mfb)/720;

soci  = round(nsamp*(180-spk));
eoci  = find(mfb > 0.99,1,'first') + 10*nsamp;
opts  = optimset('lsqcurvefit');
opts  = optimset(opts,'Display','off');



interval = soci:eoci;
w        = lsqcurvefit(wiebefcn,[5,3],((interval-1)/nsamp)',mfb(interval),[],[],opts);

wfit.a   = w(1);
wfit.n   = w(2);
wfit.dt  = (interval(end)-interval(1))/nsamp;


%%% diagnostics
% figure
% plot((180-spk):1/nsamp:((180-spk)+wfit.dt),mfb(soci:(soci+wfit.dt*nsamp)),(180-spk):1/nsamp:((180-spk)+wfit.dt),wiebefcn([wfit.a wfit.n],(180-spk):1/nsamp:((180-spk)+wfit.dt)))
