function [cyl_po] = sal_cyclify(cyl_p, bdc, rpm, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_cyclify - convert time resolved dataset to complete engine cycles  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_cyclify -  version 0.9 - Jake McKenzie - mofified: 01/02/14
% 
% inputs:
%  - cyl_p	[pressure] : cylinder pressure, time resolved
%  - bdc	[digital]  : BDC signal, rising edge on bdc compression 
%			     falling edge on BDC gas exchange
%  - rpm	[rpm]      : engine speed in rpm, scalar
%  - mode	[string]   : mode string
%			     'free'     - do not adjust offset of cyl. p.
%			     'peg'      - shift beginning of cyl. p. to 0
%			     'resample' - shift beginning of cyl. p. to 0
%					  and return downsampled pressure
%
% outputs:
%  - cyl_po	[pressure] : cylinder pressure for one cycle, may be
%			     crank angle resolved using 'resample' mode
%
% notes:
%  - Code contains a basic check to determine if BDC signal is 180 deg out
%    of phase. 
%  - Code assumes that the speed is constant within one cycle.
%  - Resampled cylinder pressure is returned at 4/CAD resolution.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% error checking: peak pressure should NOT occur before ~162 deg aBDC
[~, maxi] = max(cyl_p(:,1));
if (maxi < length(cyl_p(:,1))*0.9/4)
    disp('sal_cyclify: data appears to be off by 360 deg, attempting to fix')
    trunc = length(cyl_p(:,1))*1/4;
    cyl_p = cyl_p(trunc:end);
    bdc   = bdc(trunc:end);
    bdc   = ~(bdc >= 1);
    %%% DEBUG
    %
    %figure,plot(1:length(cyl_p),cyl_p,1:length(bdc),bdc)
    %
    %%%
end

% convert variables to column vectors
cyl_p = cyl_p(:);
rpm   = rpm(:);
bdc   = bdc(:) >= 1;                     % convert bdc to boolean
trig  = xor(bdc,circshift(bdc,1)) & bdc; % generate trig pulse on each bdc rising edge
ind   = find(trig);

% initialize output cell vectors
cyl_po{length(ind)-1} = [];
rpm_o{length(ind)-1}  = [];

% 
for i = 1:(length(ind)-1)
    if(strcmp(mode,'peg') || strcmp(mode,'resample'))
        cyl_po{i} = cyl_p(ind(i):ind(i+1))-mean(cyl_p(ind(i):(ind(i)+10)));
    else
        cyl_po{i} = cyl_p(ind(i):ind(i+1));
    end
    rpm_o{i}  = rpm(ind(i):ind(i+1));
end

ca = 0:0.25:719.75;
if(strcmp(mode,'resample'))
    for i = 1:length(cyl_po)
        dur     = length(cyl_po{i})/100000;
        domega  = mean(diff(smooth(rpm_o{i}*360/60,1000,'loess'))/(1/100000))
        omega   = 720/dur + domega*(linspace(-0.5*dur,0.5*dur,length(cyl_po{i})));
        theta   = omega.*linspace(0,dur,length(cyl_po{i}));
        plot(theta),hold on,pause
        
        cylo(:,i) = interp1(theta,cyl_po{i},ca);
    end
    cyl_po = cylo;
end


end
