function [knocking, knockCA] = sal_knockchk(cyl_p, threshold)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%       sal_knockchk - check time resolved pressure data for knock        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_knockchk -  version 0.91 - Jake McKenzie - mofified: 04/29/14
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

pflt  = sal_hpf(cyl_p);  % filter cylinder pressure
maxKI = max(abs(pflt));  % find maximum knock intensity

if( maxKI > threshold )
    kind = find(abs(pflt) > threshold, 1, 'first');
    knockCA  = 720*kind/(length(pflt)-1) - 180; % compute CA of knock relative to TDC comp
    knocking = maxKI;
else
    knocking = 0;
    knockCA  = [];
end

end