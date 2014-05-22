function [knocking, knockind] = sal_knockchk(cyl_p, threshold, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%       sal_knockchk - check time resolved pressure data for knock        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_knockchk -  version 0.92 - Jake McKenzie - mofified: 05/01/14
%
% inputs:
%  - cyl_p     [pressure] : time resolved data series
%  - threshold [pressure] : knock intensity threshold (after filtering)
%
% outputs:
%  - knocking  [pressure] : zero if not knocking, otherwise max knock intensity
%  - knockCA   [deg]      : crank angle of knock
%
% notes:
%  -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% parse arguments
narginchk(2,3);
if (nargin == 2) || (nargout == 1)
  type = 'auto';
else
  type = varargin{1};
end

%%% filter and find maximum knock amplitude
pflt  = sal_hpf(cyl_p);  % filter cylinder pressure
maxKI = max(abs(pflt));  % find maximum knock intensity

%%% if knocking
if( maxKI > threshold )
    kind = find(abs(pflt) > threshold, 1, 'first'); % find first crossing threshold
    
    switch type
        case 'manual'
        %%% manually identify the start of knock
            h = figure;
            plot(-40:20,cyl_p(kind-40:kind+20),'-k',0,cyl_p(kind),'-sr')
            x = ginput(1);
            close(h);
            
            knockind = kind+round(x(1));
        otherwise
        %%% check type not recognized or provided
            knockind = kind;
    end
    knocking = maxKI;
else
    knocking = 0;
    knockind  = [];
end
    
    %%% search for start of knock in the 100 samples preceeding trigger
%     r     = 100;
%     range = kind-r:kind;
%     perr  = abs([0;diff(cyl_p(range)-mean(cyl_p(range))-lpflt(range))]);
    %pstd  = 20*std(perr(1:round(0.5*r)));
    %pstd  = 0.2*max(perr);
%    for i = 1:length(perr)
%        perr(i) = max(perr(1:i));
%    end
    
%     indo  = find(wrev(edge(perr)) == 1,1,'last');
    
%     fitfcn = @(w,xdata)(max(perr).*heaviside(w(1)-xdata));
%     opts  = optimset('lsqcurvefit');
%     opts  = optimset(opts,'Display','off');
%     w     = lsqcurvefit(fitfcn,50,[1:length(perr)]',wrev(perr),[],[],opts);
%     indo  = w(1)
%     
%     if(isempty(indo))
%         indo = 1;
%     end
    
     %figure(101),plot(perr)
     %figure(102),plot(edge(perr))
     %figure(102),plot(abs([diff(cyl_p-mean(cyl_p)-lpflt);0]));
    
%    figure(110),plot(slerr)
%     pwind = abs(pflt(kind-100:kind));
%     for i = 2:length(pwind)
%         pwind(i) = max(pwind(1:i));
%     end
%     pwind = wrev(pwind);
     %figure(101),plot(1:length(pflt),cyl_p-mean(cyl_p),'-k',1:length(lpflt),lpflt,'-r')

%     figure(102),plot(cyl_p)
%     
%     fitfcn = @(w,xdata)((pwind(1)-pwind(end))*exp(-w(1).*xdata)+pwind(end));
%     opts  = optimset('lsqcurvefit');
%     opts  = optimset(opts,'Display','off');
%     w     = lsqcurvefit(fitfcn,1,[0:(length(pwind)-1)]',pwind,[],[],opts);
%     
%     figure(100),plot(0:(length(pwind)-1),pwind-pwind(end))
%     figure(100),hold on, plot(0:(length(pwind)-1),fitfcn(w,0:(length(pwind)-1)),'-r'),hold off
%    indo  = find(fitfcn(w,0:(length(pwind)-1)) <= 0.2,1,'first');
%    indo = find(abs(wrev(slerr)) >= 0.25,1,'first');

    
    %indo  = find(pwind-pwind(end) <= 0.4,1,'first');
%    kind  = kind - indo;
    
    %while (abs(pflt(kind)) > abs(pflt(kind-1)))
    %    kind = kind-1;
    %end
    %kind = kind-1;
        
%     if strcmp(varargin{1},'t')
%         knockCA = kind;
%     else
%         knockCA  = 720*kind/(length(pflt)-1) - 180; % compute CA of knock relative to TDC comp
%     end
%     knocking = maxKI;


%%%
%  diagnostics
%%%


end