function [xb, ca10, ca50, ca90] = sal_mfb(cyl_p, cyl_v, ivc, evo, spk, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%     sal_mfb - calculate burn curve based on cylinder pressure data      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_mfb -  version 0.92 - Jake McKenzie - mofified: 06/18/13
% 
% inputs:
%   - cylinder pressure [bar]: pegged, crank angle resolved
%   - cylinder volume   [m^3]: cylinder volume, crank angle resolved
%   - ivc               [cad]: angle at intake valve closing aBDCcomp
%   - evo               [cad]: angle at exhaust valve opens bBDCexch
%   - spk               [cad]: angle at spark bTDCcomp
%
% outputs:
%   - mfb               [1]  : cumulative fraction of fuel burned
%   - ca10              [cad]: crank angle of 10% burn
%   - ca50              [cad]: crank angle of 50% burn
%   - ca90              [cad]: crank angle of 90% burn
%
% notes:
%   the end of fit should be earlier than both tdc and the start of
%   combustion. The start of combustion is often defined as spark timing
%   and the end of combustion may be defined as say 20 deg before exhaust
%   valve opening. Both cyl_p and cyl_v must contain one cycle (720 crank
%   angles) at any encoder resolution. All angles are measured aBDC
%   compression.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsamp = length(cyl_p)/720;          % number of samples per cad
scfi  = round(nsamp*(ivc+10));      % start of compression fit index
eefi  = round(nsamp*(360-evo-10));  % end of expansion fit index
cyl_p = smooth(cyl_p,nsamp*3);      % smooth pressure trace (to remove knock)


%%% locate start of combustion %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% mode 1 - search for start of combustion by fitting
ftln    = nsamp*(180-spk)-scfi;  % fit length (initial value)
ftinc   = nsamp*2;               % fit increment
inbound = 1;

while(inbound)
    [gamc, S]   = polyfit(log10(cyl_v(scfi:scfi+ftln)),log10(cyl_p(scfi:scfi+ftln)),1);
    [ft, delta] = polyval(gamc,log10(cyl_v(scfi+ftln:scfi+ftln+ftinc)),S);
    
    if(max(abs(ft+2*delta) < abs(log10(cyl_p(scfi+ftln:scfi+ftln+ftinc)))) & (delta > 0.0025))
        inbound = 0;
    else
        ftln = ftln+ftinc;
    end
end
soci = scfi+ftln-nsamp*5; % padding of 5CA

%%% mode 2 - start of combustion is spark
% soci = nsamp*(180-spk);
% gamc = polyfit(log10(cyl_v(scfi:soci)),log10(cyl_p(scfi:soci)),1);



%%% debug plot
% figure,plot(log10(cyl_v(scfi:scfi+ftln)),log10(cyl_p(scfi:scfi+ftln)),'-k',...
%             log10(cyl_v(scfi+ftln:scfi+ftln+ftinc)),ft+2*delta,'-g',...
%             log10(cyl_v(scfi+ftln:scfi+ftln+ftinc)),ft-2*delta,'-g',...
%             log10(cyl_v(scfi+ftln:scfi+ftln+ftinc)),log10(cyl_p(scfi+ftln:scfi+ftln+ftinc)),'-r')
        
        
%%% locate end of combustion %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% mode 1 - search for end of combustion by fitting
% ftln    = nsamp*30;  % fit length (initial value)
% ftinc   = nsamp*2;   % fit increment
% inbound = 1;
% 
% while(inbound)
%     [game, S]   = qpolyfit(log10(cyl_v(eefi-ftln:eefi)),log10(cyl_p(eefi-ftln:eefi)),1);
%     [ft, delta] = polyval(game,log10(cyl_v(eefi-ftln-ftinc:eefi-ftln)),S);
%     
%     if(ft-2*delta > log10(cyl_p(eefi-ftln-ftinc:eefi-ftln)) & (delta > 0.0025))
%         inbound = 0;
%     else
%         ftln = ftln+ftinc;
%     end
% end
% eoci = eefi-ftln+nsamp*10; % padding of 10CA


%%% mode 2 - search for end of combustion at max of pV^1.15
[~, eoci] = max(cyl_p.*cyl_v.^1.15);
game = polyfit(log10(cyl_v(eoci:eefi)),log10(cyl_p(eoci:eefi)),1);

%%% debug plot
% figure(1002),plot(log10(cyl_v(eefi-ftln:eefi)),log10(cyl_p(eefi-ftln:eefi)),'-k',...
%                   log10(cyl_v(eefi-ftln-ftinc:eefi-ftln)),ft+2*delta,'-g',...
%                   log10(cyl_v(eefi-ftln-ftinc:eefi-ftln)),ft-2*delta,'-g',...
%                   log10(cyl_v(eefi-ftln-ftinc:eefi-ftln)),log10(cyl_p(eefi-ftln-ftinc:eefi-ftln)),'-r')
        


%%% calculate mass fraction burned - heywood pg. 385 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gamma  = linspace(-gamc(1),-game(1),length(cyl_p(soci:eoci)))';
xb     = zeros(size(cyl_p));
xbp    = (cyl_p(soci:eoci).^(1./gamma).*cyl_v(soci:eoci)-cyl_p(soci).^(1./gamma)*cyl_v(soci))./...
         (cyl_p(eoci).^(1./gamma)*cyl_v(eoci)-cyl_p(soci).^(1./gamma)*cyl_v(soci));
[~, i] = max(xbp);
xbp    = xbp/xbp(i);

%%% gamma iteration
gamma  = -gamc(1) + (-game(1)+gamc(1))*xbp;
xb     = zeros(size(cyl_p));
xbp    = (cyl_p(soci:eoci).^(1./gamma).*cyl_v(soci:eoci)-cyl_p(soci).^(1./gamma)*cyl_v(soci))./...
         (cyl_p(eoci).^(1./gamma)*cyl_v(eoci)-cyl_p(soci).^(1./gamma)*cyl_v(soci));  
[~, i] = max(xbp);
xb(soci:soci+i-1)  = xbp(1:i)/xbp(i);
xb(soci+i:end)     = 1;

ca10 = (find((xb >= .10),1,'first')-1)/nsamp;
ca50 = (find((xb >= .50),1,'first')-1)/nsamp;
ca90 = (find((xb >= .90),1,'first')-1)/nsamp;


%%% warning output if burn duration is larger than 55 CA
if((eoci-soci)/nsamp >= 65)
    disp(['Warning: Combustion duration of ', num2str((eoci-soci)/nsamp), 'crank angles detected, could be erroneous'])
    figure(1003), hold on
    range = linspace((soci-1)/nsamp,(eoci-1)/nsamp,eoci-soci+1);
    [ax, h1, h2] = plotyy(range,cyl_p(soci:eoci),range,xb(soci:eoci));
    set(ax(2),'YLim',[0,1.25])
    plot([ca10,ca50,ca90],cyl_p([ca10,ca50,ca90]*nsamp+1),'or')
    hold off
    figure(1004),loglog(cyl_v,cyl_p,'-k',cyl_v([scfi,soci,eoci,eefi]),cyl_p([scfi,soci,eoci,eefi]),'or')
end




%%% diagnostics

%fit check
% figure(999)
% loglog(cyl_v,cyl_p,'-k',cyl_v([scfi,soci,eoci,eefi]),cyl_p([scfi,soci,eoci,eefi]),'or')

% mfb plot
% figure(1000)
% range = linspace((soci-1)/nsamp,(eoci-1)/nsamp,eoci-soci+1);
% [ax, h1, h2] = plotyy(range,cyl_p(soci:eoci),range,xb(soci:eoci));
% hold on
% set(ax(2),'YLim',[0,1.25])
% plot([ca10,ca50,ca90],cyl_p([ca10,ca50,ca90]*nsamp+1),'or')
% hold off
% 
% figure(1001)
% hold on
% plot(now-fix(now),(eoci-soci)/nsamp,'ok')
% ylabel('Burn Duration, [CAD]')
% hold off
% 
% pause

end
