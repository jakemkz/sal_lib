function [cyl_po] = sal_cyclify(cyl_p,bdc,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_cyclify - convert time resolved dataset to complete engine cycles  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_cyclify -  version 0.92 - Jake McKenzie - mofified: 05/22/14
% 
% inputs:
%  - cyl_p	[pressure] : cylinder pressure, time resolved
%  - bdc	[digital]  : BDC signal, rising edge on bdc compression 
%			             falling edge on BDC gas exchange, same size as
%			             cyl_p
%  - mode	[string]   : mode string
%			     'free'     - return unpegged, time resolved data
%			     'resample' - return crank angle resolved pressure
%
% outputs:
%  - cyl_po	[pressure] : cylinder pressure for one cycle, may be
%			             crank angle resolved using 'resample' mode output
%			             is a 2D array if resample is used, otherwise it is
%			             a cell vector that contains an array of data for
%			             each cycle.
%
% notes:
%  - Code contains a basic check to determine if BDC signal is 180 deg out
%    of phase. 
%  - Resampled data assumes that the speed is constant within one cycle.
%  - If no edges are found on BDC signal cyl_p is placed into cell
%    array as-is.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% configurable parameters
dCA = 0.25;   % crank angle increment for resampled output

%%% decode optional arguments, function accepts 2 to 3 arguments
narginchk(2,3);
if (nargin == 3)
    mode = varargin{1};
else
    mode = 'free';
end


%%% error checking: peak pressure should NOT occur before ~162 deg aBDC
[~, maxi] = max(cyl_p(:,1));
if (maxi < length(cyl_p(:,1))*0.9/4)
    disp('sal_cyclify: data appears to be off by 180 deg, attempting to fix')
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
bdc   = bdc(:) >= 1;                     % convert bdc to boolean
trig  = xor(bdc,circshift(bdc,1)) & bdc; % generate trig pulse on each bdc rising edge
ind   = find(trig);

% if edges are detected on bdc signal use them, otherwise move data to cell
if ~isempty(ind)
    cyl_p = cyl_p(:);
    
    % initialize output cell vectors
    cyl_po{length(ind)-1} = [];
    
    % move cycle data into cell vectors
    for i = 1:(length(ind)-1)
        cyl_po{i} = cyl_p(ind(i):ind(i+1));
    end
    
    % computations for resampling. speed is assumed constant within cycle
    if(strcmp(mode,'resample'))
        ca    = 0:dCA:(720-dCA);
        cyl_o = zeros(length(ca),length(cyl_po));
        for i = 1:length(cyl_po)
            theta = linspace(0,720,length(cyl_po{i}));
            cyl_o(:,i) = interp1(theta,cyl_po{i},ca);
        end
        cyl_po = cyl_o;
    end
else
    cyl_po{length(cyl_p(1,:))} = [];
    for i = 1:length(cyl_p(1,:))
        cyl_po{i} = cyl_p(:,i);
    end
end

end
