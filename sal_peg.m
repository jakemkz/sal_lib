function cyl_p = sal_peg(cyl_p,map)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   sal_peg - peg cylinder pressure data using intake manifold pressure   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_peg - version 0.9 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - cyl_p	[pressure] : cylinder pressure, nsamp by ncycle matrix
%  - map	[pressure] : manifold pressure, nsamp by ncycle matrix
%
% output:
%  - cyl_p	[pressure] : pegged cylinder pressure, nsamp by ncycle
%
% notes:
%  - Current version contains no error checking. 
%  - Assumed firing order is 1-3-4-2, with data collection triggered on 
%    BDC compression of cylinder one.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m, ncycle] = size(cyl_p);
nsamp       = m/720;        % number of samples per cad

map    = circshift(map,5*nsamp);
cyl_ps = circshift(cyl_p,5*nsamp);
cyl_p  = cyl_p - ones(m,1)*mean(cyl_ps(1:10*nsamp,:)) + ones(m,1)*mean(map(1:10*nsamp,:));
end

